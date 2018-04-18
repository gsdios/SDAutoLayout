//
//  AllocationTracker.mm
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
#import <objc/runtime.h>
#import "AllocationTracker.h"
#import <string>
#import <map>
#import <set>
#import <vector>
#import <utility>
#import <string.h>
#import <execinfo.h>
#import <pthread.h>
#import "QQLeakChecker.h"
#import "QQLeakMallocStackTracker.h"
#import "CObjcFilter.h"
#import "CLeakChecker.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

extern CLeakChecker* global_leakChecker;

static AllocationTracker *tracker;

@interface NSObject(MethodSwizzling)
+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;

@end


@implementation NSObject (MethodSwizzling)

+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel
{
    Method originMethod = class_getInstanceMethod(self, origSel);
    Method newMethod = class_getInstanceMethod(self, altSel);
    if (originMethod && newMethod) {
        //2012年5月更新
        if (class_addMethod(self, origSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(self, altSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, newMethod);
        }
        return YES;
    }
    return NO;
}

+ (BOOL)swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel
{
    Class c = object_getClass((id)self);
    return [c swizzleMethod:origSel withMethod:altSel];
}

@end

@interface NSObject(AllocationTracker)

+ (id)Tracker_Alloc;

@end

@implementation NSObject(AllocationTracker)

+ (id)Tracker_Alloc{
    if(global_leakChecker->isNeedTrackClass(self)){
        global_leakChecker->markedThreadToTrackingNextMalloc(NULL);
    }
    id obj = [self Tracker_Alloc];
#ifdef __enable_malloc_logger__
    malloc_printf("alloc ptr:%p size:%lu name:%s thread:%lu\n",obj, (uint32_t)class_getInstanceSize([obj class]),class_getName([obj class]),mach_thread_self());
#endif
    return obj;
}

@end

@interface AllocationTracker()
{
    BOOL _isTracking;
}
@end

@implementation AllocationTracker

+(AllocationTracker *)getInstance{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tracker = [AllocationTracker new];
    });
    return tracker;
}

-(id)init{
    if(self = [super init]){
        [QQLeakChecker getInstance];
    }
    return self;
}

-(void)swizzleAllocationFunction{
    [NSObject swizzleClassMethod:@selector(alloc) withClassMethod:@selector(Tracker_Alloc)];
}

-(void)beginRecord{
    if(!_isTracking){
        _isTracking = YES;
       [self swizzleAllocationFunction];
    }
}

-(void)stopRecord
{
    if(_isTracking){
        _isTracking = NO;
        [self swizzleAllocationFunction];
    }
}

@end
