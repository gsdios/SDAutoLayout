//
//  OOMDetector.mm
//  QQLeak
//
//  Tencent is pleased to support the open source community by making OOMDetector available.
//  Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
//  Licensed under the MIT License (the "License"); you may not use this file except
//  in compliance with the License. You may obtain a copy of the License at
//
//  http://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//
//

#import <libkern/OSAtomic.h>
#import <sys/mman.h>
#import <mach/mach_init.h>
#import <mach/vm_statistics.h>
#import "zlib.h"
#import "stdio.h"
#import "OOMMemoryStackTracker.h"
#import "QQLeakPredefines.h"
#import "HighSpeedLogger.h"
#import "CStackHelper.h"
#import "OOMDetector.h"
#import "CStacksHashmap.h"
#import "QQLeakMallocStackTracker.h"
#import "OOMDetectorLogger.h"
#import "QQLeakFileUploadCenter.h"
#import "QQLeakDeviceInfo.h"
#import "CommonMallocLogger.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#if defined(USE_VM_LOGGER_FORCEDLY) || defined(DEBUG)
#define USE_VM_LOGGER
#endif

#ifdef USE_VM_LOGGER

#if defined(USE_VM_LOGGER_FORCEDLY)
#warning 请务必在提交app store审核之前注释掉“USE_VM_LOGGER_FORCEDLY”宏！！！
#endif

//__syscall_logger是系统私有API，在appstore版本千万不要引用!!!!!
extern malloc_logger_t* __syscall_logger;

#endif

//static
static OOMDetector *catcher;
static size_t normal_size = 512*1024;
//malloc_logger_t** vm_sys_logger;
COOMDetector* global_oomdetector;

void printLog(char *log)
{
    if ([OOMDetector getInstance].logPrintBlock) {
        [OOMDetector getInstance].logPrintBlock([NSString stringWithUTF8String:log]);
    }
}

void myChunkMallocCallback(size_t bytes, NSString *stack)
{
    if ([OOMDetector getInstance].chunkMallocBlock) {
        [OOMDetector getInstance].chunkMallocBlock(bytes, stack);
    }
}

@interface OOMDetector()
{
    NSString *_normal_path;
    NSRecursiveLock *_flushLock;
    NSTimer *_timer;
    double _dumpLimit;
    BOOL _needAutoDump;
    QQLeakChecker *_leakChecker;
    NSString *_currentDir;
    BOOL _enableOOMMonitor;
    BOOL _enableChunkMonitor;
    BOOL _enableVMMonitor;
}

@end

@implementation OOMDetector

+(OOMDetector *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        catcher = [OOMDetector new];
        global_oomdetector = new COOMDetector();
    });
    return catcher;
}

-(id)init
{
    if(self = [super init]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *LibDirectory = [paths objectAtIndex:0];
        NSDateFormatter* df = [[NSDateFormatter new] autorelease];
        df.dateFormat = @"yyyyMMdd_HHmmssSSS";
        NSString *dateStr = [df stringFromDate:[NSDate date]];
        _currentDir = [[LibDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"OOMDetector/%@",dateStr]] retain];
        _normal_path = [[_currentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"normal_malloc%@.log",dateStr]] retain];
        if(global_memory_zone == nil){
            global_memory_zone = malloc_create_zone(0, 0);
            malloc_set_zone_name(global_memory_zone, "OOMDetector");
        }
        _flushLock = [NSRecursiveLock new];

    }
    return self;
}

- (void)setupWithDefaultConfig
{
    CGFloat OOMThreshhold = 300.f;
    NSString *platform = [QQLeakDeviceInfo platform];
    NSString *prefix = @"iPhone";
    if ([platform hasPrefix:prefix]) {
        if ([[[[platform substringFromIndex:prefix.length] componentsSeparatedByString:@","] firstObject] intValue] > 7) {
            OOMThreshhold = 800.f;
        }
    }
    [self setMaxStackDepth:50];
    [self setNeedSystemStack:YES];
    [self setNeedStacksWithoutAppStack:YES];
    // 开启内存触顶监控
    [self startMaxMemoryStatistic:OOMThreshhold];
    
    // 显示内存悬浮球
    [self showMemoryIndicatorView:YES];
}

- (void)showMemoryIndicatorView:(BOOL)yn
{
    [[OOMStatisticsInfoCenter getInstance] showMemoryIndicatorView:yn];
}

- (void)setupLeakChecker
{
    QQLeakChecker *leakChecker = [QQLeakChecker getInstance];
    _leakChecker = leakChecker;
    
    //设置堆栈最大长度为10，超过10将被截断
    [leakChecker setMaxStackDepth:10];
    [leakChecker setNeedSystemStack:YES];
    //开始记录对象分配堆栈
    [leakChecker startStackLogging];
}

- (QQLeakChecker *)currentLeakChecker
{
    return _leakChecker;
}

- (void)executeLeakCheck:(QQLeakCheckCallback)callback
{
    [[self currentLeakChecker] executeLeakCheck:callback];
}

-(void)registerLogCallback:(logCallback)logger
{
    oom_logger = logger;
}

-(void)startMaxMemoryStatistic:(double)overFlowLimit
{

    [[OOMStatisticsInfoCenter getInstance] startMemoryOverFlowMonitor:overFlowLimit];

}

-(BOOL)startMallocStackMonitor:(size_t)threshholdInBytes needAutoDumpWhenOverflow:(BOOL)needAutoDump dumpLimit:(double)dumpLimit sampleInterval:(NSTimeInterval)sampleInterval
{
    if(!_enableOOMMonitor){
        
        if(global_oomdetector->getStackLogger() == NULL){
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:_currentDir]) {
                [fileManager createDirectoryAtPath:_currentDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (![fileManager fileExistsAtPath:_normal_path]) {
                [fileManager createFileAtPath:_normal_path contents:nil attributes:nil];
            }
            global_oomdetector->initLogger(global_memory_zone, _normal_path, normal_size,printLog);
        }
        _enableOOMMonitor = global_oomdetector->startMallocStackMonitor(threshholdInBytes);
        if(_enableOOMMonitor){
            malloc_logger = (malloc_logger_t *)common_stack_logger;//(malloc_logger_t *)oom_malloc_logger;
        }
    }

    if(needAutoDump){
        _dumpLimit = dumpLimit;
        _timer = [NSTimer timerWithTimeInterval:sampleInterval target:self selector:@selector(detectorTask) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }

    return _enableOOMMonitor;
}


-(void)detectorTask
{
    double currentMemory = [QQLeakDeviceInfo appUsedMemory];
    //flush stack
    if(currentMemory > _dumpLimit){
        [self flush_allocation_stack];
    }
}


-(void)stopMallocStackMonitor
{
    if(_enableOOMMonitor){
        global_oomdetector->stopMallocStackMonitor();
    }
    if(_timer){
        [_timer invalidate];
    }

}

-(void)setupVMLogger
{
#ifdef USE_VM_LOGGER
    global_oomdetector->vm_sys_logger = (malloc_logger_t**)&__syscall_logger;
#else
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你在Release模式下调用了startVMStackMonitor:方法，Release模式下只有打开了USE_VM_LOGGER_FORCEDLY宏之后startVMStackMonitor:方法才会生效，不过切记不要在app store版本中打开USE_VM_LOGGER_FORCEDLY宏" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
#endif
    
}

-(BOOL)startVMStackMonitor:(size_t)threshHoldInbytes
{
    if (NULL == global_oomdetector->vm_sys_logger) {
        [self setupVMLogger];
    }
    if(!_enableVMMonitor && global_oomdetector->vm_sys_logger){
        if(global_oomdetector->getStackLogger() == NULL){
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:_currentDir]) {
                [fileManager createDirectoryAtPath:_currentDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (![fileManager fileExistsAtPath:_normal_path]) {
                [fileManager createFileAtPath:_normal_path contents:nil attributes:nil];
            }
            global_oomdetector->initLogger(global_memory_zone, _normal_path, normal_size,printLog);
        }
        _enableVMMonitor = global_oomdetector->startVMStackMonitor(threshHoldInbytes);
        if(_enableVMMonitor){
            *(global_oomdetector->vm_sys_logger) = oom_vm_logger;
        }
    }
    return YES;
}

-(void)stopVMStackMonitor
{
    if(_enableVMMonitor && global_oomdetector->vm_sys_logger){
        global_oomdetector->stopVMStackMonitor();
        *(global_oomdetector->vm_sys_logger) = NULL;
        _enableVMMonitor = NO;
    }
}

-(BOOL)startSingleChunkMallocDetector:(size_t)threshholdInBytes callback:(ChunkMallocBlock)callback
{
    if(!_enableChunkMonitor){
        _enableChunkMonitor = YES;
        if(_enableChunkMonitor){
            global_oomdetector->startSingleChunkMallocDetector(threshholdInBytes,callback);
            self.chunkMallocBlock = callback;
            malloc_logger = (malloc_logger_t *)common_stack_logger;//(malloc_logger_t *)oom_malloc_logger;
        }
    }
    return _enableChunkMonitor;
}

-(void)stopSingleChunkMallocDetector
{
    if(!_enableOOMMonitor && _enableChunkMonitor){
        global_oomdetector->stopSingleChunkMallocDetector();
        malloc_logger = NULL;
    }
    _enableChunkMonitor = NO;
}

-(void)flush_allocation_stack
{
    [_flushLock lock];
    global_oomdetector->flush_allocation_stack();
    [_flushLock unlock];
}

-(void)uploadAllStack
{
    if ([QQLeakFileUploadCenter defaultCenter].fileDataDelegate) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *OOMDataPath = [self OOMDataPath];
            NSString *currentLogDir = [self currentStackLogDir];
            NSArray *paths = [fm contentsOfDirectoryAtPath:OOMDataPath error:nil];
            for(NSString *path in paths)
            {
                NSString *fullPath = [OOMDataPath stringByAppendingPathComponent:path];
                BOOL isDir = NO;
                if([fm fileExistsAtPath:fullPath isDirectory:&isDir]){
                    if(!isDir) continue;
                    
                    if(currentLogDir == nil || (currentLogDir != nil && ![fullPath isEqualToString:currentLogDir])){
                        
                        NSDirectoryEnumerator *internal_enumerator = [fm enumeratorAtPath:fullPath];
                        NSString *internal_path = [internal_enumerator nextObject];
                        
                        while(internal_path != nil){
                            QQStackReportType reportType = QQStackReportTypeOOMLog;
                            NSString *internal_full_path = [fullPath stringByAppendingPathComponent:internal_path];
                            NSData *data = [NSData dataWithContentsOfFile:internal_full_path];
                            size_t stack_size = strlen((char *)data.bytes);
                            
                            if(stack_size == 0){
                                [fm removeItemAtPath:fullPath error:nil];
                            }
                            
                            if(![internal_path hasPrefix:@"normal_malloc"]){
                                reportType = QQStackReportTypeChunkMemory;
                            }
                            
                            if (stack_size > 0 && data.length > 0) {
                                NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:[[UIDevice currentDevice] systemVersion],@"systemversion",[QQLeakDeviceInfo platform],@"Device",@"normal_malloc",@"type",nil];
                                [[QQLeakFileUploadCenter defaultCenter] fileData:data extra:extra type:reportType completionHandler:^(BOOL completed) {
                                    if (completed) {
                                        [fm removeItemAtPath:fullPath error:nil];
                                    }
                                }];
                            }
                            
                            internal_path = [internal_enumerator nextObject];
                        }
                    }
                }
            }
        });
    }
}

-(NSString *)OOMDataPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *LibDirectory = [paths objectAtIndex:0];
    return [LibDirectory stringByAppendingPathComponent:@"OOMDetector"];
}
                   
-(NSString *)OOMZipPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *LibDirectory = [paths objectAtIndex:0];
    NSString *dir = [LibDirectory stringByAppendingPathComponent:@"Caches/OOMTmp"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dir])
    {
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [dir stringByAppendingPathComponent:@"OOMData.zip"];
}


-(void)setMaxStackDepth:(size_t)depth
{
    if(depth > 0) {
        global_oomdetector->max_stack_depth = depth;
    }
}


-(void)setNeedSystemStack:(BOOL)isNeedSys
{
    global_oomdetector->needSysStack = isNeedSys;
}

-(void)setNeedStacksWithoutAppStack:(BOOL)isNeedStackWithoutAppStack
{
    global_oomdetector->needStackWithoutAppStack = isNeedStackWithoutAppStack;
}

-(NSString *)currentStackLogDir;
{
    return _currentDir;
}

- (void)setStatisticsInfoBlock:(StatisticsInfoBlock)block
{
    [[OOMStatisticsInfoCenter getInstance] setStatisticsInfoBlock:block];
}

-(void)dealloc
{
    self.logPrintBlock = nil;
    self.chunkMallocBlock = nil;
    [super dealloc];
}

- (void)setPerformanceDataDelegate:(id<QQOOMPerformanceDataDelegate>)delegate
{
    [[QQLeakDataUploadCenter defaultCenter] setPerformanceDataDelegate:delegate];
}

- (void)setFileDataDelegate:(id<QQOOMFileDataDelegate>)delegate
{
    [[QQLeakFileUploadCenter defaultCenter] setFileDataDelegate:delegate];
}

@end

