//
//  APMDeviceInfo.m
//  QQMSFContact
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

#import "QQLeakDeviceInfo.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <mach/mach_init.h>
#import <mach/machine.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#ifdef __LP64__
typedef struct mach_header_64 mach_header_t;
#else
typedef struct mach_header mach_header_t;
#endif

@implementation QQLeakDeviceInfo

#pragma mark sysctlbyname utils
+ (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    
    if (nil == results || 0 == results.length) {
        results = @"iPhoneUnknown";
    }
    return results;
}

+ (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

#pragma mark -public
+ (NSString *) platform
{
    static NSString* pl = nil;
    if (!pl) {
        pl = [[self getSysInfoByName:"hw.machine"] retain];
    }
    return pl;
}

+ (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

+ (double)freeMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    vm_size_t pageSize;
    mach_port_t selfhost = mach_host_self();
    host_page_size(selfhost, &pageSize);
    kern_return_t kernReturn = host_statistics(selfhost,
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    mach_port_deallocate(mach_task_self(), selfhost);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

+ (double)appUsedMemory
{
    mach_task_basic_info_data_t taskInfo;
    unsigned infoCount = sizeof(taskInfo);
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         MACH_TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+(NSString *)deviceID{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+(NSString*) cpuType{
    const mach_header_t* header = (const mach_header_t*)_dyld_get_image_header(0);
    int cputype = header->cputype;
    int subtype = header->cpusubtype;
    if (cputype == CPU_TYPE_X86) return @"x86";
    else if (cputype == CPU_TYPE_X86_64) return @"x86_64";
#ifdef __LP64__
    else if (cputype == CPU_TYPE_ARM64)
    {
        if (subtype == CPU_SUBTYPE_ARM64_ALL) return @"arm64";
        else return [NSString stringWithFormat:@"arm64_%d_%d",cputype&0xff, subtype&0xff];
    }
#else
    else if (cputype == CPU_TYPE_ARM)
    {
        if (subtype == CPU_SUBTYPE_ARM_V6) return @"armv6";
        else if (subtype == CPU_SUBTYPE_ARM_V7) return @"armv7";
        else if (subtype == CPU_SUBTYPE_ARM_V7S) return @"armv7s";
        else return [NSString stringWithFormat:@"arm_%d_%d",cputype&0xff, subtype&0xff];
    }
#endif
    else
    {
        return [NSString stringWithFormat:@"cpu_%d.%d", cputype&0xff, subtype&0xff];
    }
}

@end
