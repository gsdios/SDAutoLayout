//
//  COOMDetector.m
//  libOOMDetector
//
//  Created by rosen on 2017/12/26.
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

#import "COOMDetector.h"

static size_t grained_size = 512*1024;
//extern malloc_logger_t** vm_sys_logger;

COOMDetector::~COOMDetector()
{
    if(normal_stack_logger != NULL){
        delete normal_stack_logger;
    }
    if(stackHelper != NULL){
        delete stackHelper;
    }
}

COOMDetector::COOMDetector()
{
    stackHelper = new CStackHelper();
}

NSString *COOMDetector::chunkDataZipPath()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *LibDirectory = [paths objectAtIndex:0];
    NSString *dir = [LibDirectory stringByAppendingPathComponent:@"Caches/OOMTmp"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dir])
    {
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [dir stringByAppendingPathComponent:@"ChunkData.zip"];
}

void COOMDetector::get_chunk_stack(size_t size)
{
    if(enableChunkMonitor){
        vm_address_t *stacks[max_stack_depth_sys];
        size_t depth = backtrace((void**)stacks, max_stack_depth_sys);
        NSMutableString *stackInfo = [[[NSMutableString alloc] init] autorelease];
        NSDateFormatter* df1 = [[NSDateFormatter new] autorelease];
        df1.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSString *dateStr1 = [df1 stringFromDate:[NSDate date]];
        [stackInfo appendFormat:@"%@ chunk_malloc:%.2fmb stack:\n",dateStr1,(double)size/(1024*1024)];
        for(size_t j = 2; j < depth; j++){
            vm_address_t addr = (vm_address_t)stacks[j];
            segImageInfo segImage;
            if(stackHelper->getImageByAddr(addr, &segImage)){
                [stackInfo appendFormat:@"\"%lu %s 0x%lx 0x%lx\" ",j - 2,(segImage.name != NULL) ? segImage.name : "unknown",segImage.loadAddr,(long)addr];
            }
        }
        [stackInfo appendFormat:@"\n"];
        
        if ([QQLeakFileUploadCenter defaultCenter].fileDataDelegate) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [stackInfo dataUsingEncoding:NSUTF8StringEncoding];
                if (data && data.length > 0) {
                    NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:[[UIDevice currentDevice] systemVersion],@"systemversion",[QQLeakDeviceInfo platform],@"Device",@"chunk_malloc",@"type",nil];
                    [[QQLeakFileUploadCenter defaultCenter] fileData:data extra:extra type:QQStackReportTypeChunkMemory completionHandler:^(BOOL completed) {
                        
                    }];
                }
            });
        }
        if(chunkMallocCallback)
        {
            chunkMallocCallback(size,stackInfo);
        }
    }
}

void COOMDetector::recordVMStack(vm_address_t address,uint32_t size,const char*type,size_t stack_num_to_skip)
{
    base_stack_t base_stack;
    base_ptr_log base_ptr;
    unsigned char md5[16];
    vm_address_t  *stack[max_stack_depth];
    if(needStackWithoutAppStack){
        base_stack.depth = stackHelper->recordBacktrace(needSysStack,0,stack_num_to_skip, stack,md5,max_stack_depth);
    }
    else {
        base_stack.depth = stackHelper->recordBacktrace(needSysStack,1,stack_num_to_skip, stack,md5,max_stack_depth);
    }
    if(base_stack.depth > 0){
        base_stack.stack = stack;
        base_stack.extra.size = size;
        base_stack.extra.name = type;
        base_ptr.md5 = md5;
        base_ptr.size = size;
        OSSpinLockLock(&vm_hashmap_spinlock);
        if(vm_ptrs_hashmap && vm_stacks_hashmap){
            if(vm_ptrs_hashmap->insertPtr(address, &base_ptr)){
                vm_stacks_hashmap->insertStackAndIncreaseCountIfExist(md5, &base_stack);
            }
        }
        OSSpinLockUnlock(&vm_hashmap_spinlock);
    }
}


void COOMDetector::removeVMStack(vm_address_t address)
{
    OSSpinLockLock(&vm_hashmap_spinlock);
    if(vm_ptrs_hashmap && vm_stacks_hashmap){
        ptr_log_t *ptr_log = vm_ptrs_hashmap->lookupPtr(address);
        if(ptr_log != NULL)
        {
            unsigned char md5[16];
            strncpy((char *)md5, (const char *)ptr_log->md5, 16);
            size_t size = (size_t)ptr_log->size;
            if(vm_ptrs_hashmap->removePtr(address)){
                vm_stacks_hashmap->removeIfCountIsZero(md5,size);
            }
        }
    }
    OSSpinLockUnlock(&vm_hashmap_spinlock);
}

void COOMDetector::recordMallocStack(vm_address_t address,uint32_t size,const char*name,size_t stack_num_to_skip)
{
    base_stack_t base_stack;
    base_ptr_log base_ptr;
    unsigned char md5[16];
    vm_address_t  *stack[max_stack_depth];
    if(needStackWithoutAppStack){
        base_stack.depth = stackHelper->recordBacktrace(needSysStack,0,stack_num_to_skip, stack,md5,max_stack_depth);
    }
    else {
        base_stack.depth = stackHelper->recordBacktrace(needSysStack,1,stack_num_to_skip, stack,md5,max_stack_depth);
    }
    
    if(base_stack.depth > 0){
        base_stack.stack = stack;
        base_stack.extra.size = size;
        base_ptr.md5 = md5;
        base_ptr.size = size;
        OSSpinLockLock(&hashmap_spinlock);
        if(oom_ptrs_hashmap && oom_stacks_hashmap){
            if(oom_ptrs_hashmap->insertPtr(address, &base_ptr)){
                oom_stacks_hashmap->insertStackAndIncreaseCountIfExist(md5, &base_stack);
            }
        }
        OSSpinLockUnlock(&hashmap_spinlock);
    }
}

void COOMDetector::removeMallocStack(vm_address_t address,monitor_mode mode)
{
    OSSpinLockLock(&hashmap_spinlock);
    if(oom_ptrs_hashmap && oom_stacks_hashmap){
        ptr_log_t *ptr_log = oom_ptrs_hashmap->lookupPtr(address);
        if(ptr_log != NULL)
        {
            unsigned char md5[16];
            strncpy((char *)md5, (const char *)ptr_log->md5, 16);
            size_t size = (size_t)ptr_log->size;
            if(oom_ptrs_hashmap->removePtr(address)){
                oom_stacks_hashmap->removeIfCountIsZero(md5, size);
            }
        }
    }
    OSSpinLockUnlock(&hashmap_spinlock);
}

void COOMDetector::flush_allocation_stack()
{
    normal_stack_logger->current_len = 0;
    NSDateFormatter* df = [[NSDateFormatter new] autorelease];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    int exceedNum = 0;
    //flush malloc stack
    if(enableOOMMonitor){
        OSSpinLockLock(&hashmap_spinlock);
        malloc_logger = NULL;
        normal_stack_logger->sprintfLogger(grained_size,"%s normal_malloc_num:%ld stack_num:%ld\n",[dateStr UTF8String],oom_ptrs_hashmap->getRecordNum(),oom_stacks_hashmap->getRecordNum());
        for(size_t i = 0; i < oom_stacks_hashmap->getEntryNum(); i++){
            base_entry_t *entry = oom_stacks_hashmap->getHashmapEntry() + i;
            merge_stack_t *current = (merge_stack_t *)entry->root;
            while(current != NULL){
                if(current->extra.size > oom_threshold){
                    exceedNum++;
                    normal_stack_logger->sprintfLogger(grained_size,"Malloc_size:%lfmb num:%u stack:\n",(double)(current->extra.size)/(1024*1024), current->count);
                    for(size_t j = 0; j < current ->depth; j++){
                        vm_address_t addr = (vm_address_t)current->stack[j];
                        segImageInfo segImage;
                        if(stackHelper->getImageByAddr(addr, &segImage)){
                            normal_stack_logger->sprintfLogger(grained_size,"\"%lu %s 0x%lx 0x%lx\" ",j,(segImage.name != NULL) ? segImage.name : "unknown",segImage.loadAddr,(long)addr);
                        }
                    }
                    normal_stack_logger->sprintfLogger(grained_size,"\n");
                }
                current = current->next;
            }
        }
        malloc_logger = (malloc_logger_t *)common_stack_logger;//oom_malloc_logger;
        OSSpinLockUnlock(&hashmap_spinlock);
    }
    normal_stack_logger->sprintfLogger(grained_size,"\n");
    //flush vm
    if(enableVMMonitor){
        OSSpinLockLock(&vm_hashmap_spinlock);
        *vm_sys_logger = NULL;
        normal_stack_logger->sprintfLogger(grained_size,"%s vm_allocate_num:%ld stack_num:%ld\n",[dateStr UTF8String],vm_ptrs_hashmap->getRecordNum(),vm_stacks_hashmap->getRecordNum());
        for(size_t i = 0; i < vm_stacks_hashmap->getEntryNum(); i++){
            base_entry_t *entry = vm_stacks_hashmap->getHashmapEntry() + i;
            merge_stack_t *current = (merge_stack_t *)entry->root;
            while(current != NULL){
                if(current->extra.size > vm_threshold){
                    exceedNum++;
                    normal_stack_logger->sprintfLogger(grained_size,"vm_allocate_size:%.2fmb num:%u type:%s stack:\n",(double)(current->extra.size)/(1024*1024), current->count,current->extra.name);
                    for(size_t j = 0; j < current ->depth; j++){
                        vm_address_t addr = (vm_address_t)current->stack[j];
                        segImageInfo segImage;
                        if(stackHelper->getImageByAddr(addr, &segImage)){
                            normal_stack_logger->sprintfLogger(grained_size,"\"%lu %s 0x%lx 0x%lx\" ",j,(segImage.name != NULL) ? segImage.name : "unknown",segImage.loadAddr,(long)addr);
                        }
                    }
                    normal_stack_logger->sprintfLogger(grained_size,"\n");
                }
                current = current->next;
            }
        }
    }
    if(exceedNum == 0){
        normal_stack_logger->cleanLogger();
    }
    if(enableVMMonitor){
        *vm_sys_logger = oom_vm_logger;
    }
    OSSpinLockUnlock(&vm_hashmap_spinlock);
    normal_stack_logger->syncLogger();
}


void COOMDetector::initLogger(malloc_zone_t *zone, NSString *path, size_t mmap_size,LogPrinter printer)
{
    normal_stack_logger = new HighSpeedLogger(zone, path, mmap_size);
    if(normal_stack_logger != NULL && normal_stack_logger->isValid()){
        normal_stack_logger->logPrinterCallBack = printer;
    }
}

BOOL COOMDetector::startMallocStackMonitor(size_t threshholdInBytes)
{
    if(normal_stack_logger != NULL && normal_stack_logger->isValid()){
        oom_stacks_hashmap = new CStacksHashmap(50000,global_memory_zone,OOMDetectorMode);
        oom_stacks_hashmap->oom_threshold = threshholdInBytes;
        oom_ptrs_hashmap = new CPtrsHashmap(250000,global_memory_zone);
        enableOOMMonitor = YES;
        oom_threshold = threshholdInBytes;
        return YES;
    }
    else {
        enableOOMMonitor = NO;
        return NO;
    }
}

void COOMDetector::stopMallocStackMonitor()
{
    OSSpinLockLock(&hashmap_spinlock);
    CPtrsHashmap *tmp_ptr = oom_ptrs_hashmap;
    CStacksHashmap *tmp_stack = oom_stacks_hashmap;
    oom_stacks_hashmap = NULL;
    oom_ptrs_hashmap = NULL;
    OSSpinLockUnlock(&hashmap_spinlock);
    delete tmp_ptr;
    delete tmp_stack;
}

BOOL COOMDetector::startVMStackMonitor(size_t threshholdInBytes)
{
    if(normal_stack_logger != NULL && normal_stack_logger->isValid()){
        vm_stacks_hashmap = new CStacksHashmap(1000,global_memory_zone,OOMDetectorMode);
        vm_ptrs_hashmap = new CPtrsHashmap(2000,global_memory_zone);
        enableVMMonitor = YES;
        vm_threshold = threshholdInBytes;
        return YES;
    }
    else {
        enableVMMonitor = NO;
        return NO;
    }
}

void COOMDetector::stopVMStackMonitor()
{
    if(normal_stack_logger != NULL){
        OSSpinLockLock(&vm_hashmap_spinlock);
        CPtrsHashmap *tmp_ptr = vm_ptrs_hashmap;
        CStacksHashmap *tmp_stack = vm_stacks_hashmap;
        vm_ptrs_hashmap = NULL;
        vm_stacks_hashmap = NULL;
        OSSpinLockUnlock(&vm_hashmap_spinlock);
        delete tmp_ptr;
        delete tmp_stack;
        enableVMMonitor = NO;
    }
}

void COOMDetector::startSingleChunkMallocDetector(size_t threshholdInBytes,ChunkMallocBlock mallocBlock)
{
    chunk_threshold = threshholdInBytes;
    enableChunkMonitor = YES;
    if(chunkMallocCallback != NULL){
        Block_release(chunkMallocCallback);
    }
    chunkMallocCallback = Block_copy(mallocBlock);
}

void COOMDetector::stopSingleChunkMallocDetector()
{
    enableChunkMonitor = NO;
}

HighSpeedLogger *COOMDetector::getStackLogger()
{
    return normal_stack_logger;
}

void COOMDetector::lockMallocSpinLock()
{
    OSSpinLockLock(&hashmap_spinlock);
}
void COOMDetector::unlockMallocSpinLock()
{
    OSSpinLockUnlock(&hashmap_spinlock);
}
void COOMDetector::lockVMSpinLock()
{
    OSSpinLockLock(&vm_hashmap_spinlock);
}
void COOMDetector::unlockVMSpinLock()
{
    OSSpinLockUnlock(&vm_hashmap_spinlock);
}

