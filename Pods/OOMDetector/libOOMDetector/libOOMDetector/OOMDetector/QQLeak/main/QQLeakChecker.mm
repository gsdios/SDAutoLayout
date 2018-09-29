//
//  QQLeakChecker.mm
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

#import <objc/runtime.h>
#import <libkern/OSAtomic.h>
#import "QQLeakChecker.h"
#import "AllocationTracker.h"
#import "QQLeakMallocStackTracker.h"
#import "CStackChecker.h"
#import "CRegisterChecker.h"
#import "CSegmentChecker.h"
#import "CHeapChecker.h"
#import "QQLeakPredefines.h"
#import "CMallocHook.h"
#import "CThreadTrackingHashmap.h"
#import "CStacksHashmap.h"
#import "CPtrsHashmap.h"
#import "CLeakedHashmap.h"
#import "CObjcFilter.h"
#import <malloc/malloc.h>
#import "CLeakChecker.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

static QQLeakChecker* qqleak;
CLeakChecker* global_leakChecker;

@interface QQLeakChecker()
{
    CStackChecker *_stackChecker;
    CSegmentChecker *_segmentChecker;
    CHeapChecker *_heapChecker;
    CRegisterChecker *_registerChecker;
    bool _isChecking;
    bool _isStackLogging;
    size_t _max_stack_depth;
    BOOL _needSysStack;
}

@end

@implementation QQLeakChecker

+(QQLeakChecker *)getInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        global_leakChecker = new CLeakChecker();
        qqleak = [[QQLeakChecker alloc] init];
    });
    return qqleak;
}

-(id)init{
    if(self = [super init]){
        _stackChecker = new CStackChecker(global_leakChecker);
        _segmentChecker = new CSegmentChecker(global_leakChecker);
        _heapChecker = new CHeapChecker(global_leakChecker);
        _registerChecker = new CRegisterChecker(global_leakChecker);
        _max_stack_depth = 10;
        _needSysStack = YES;
    }
    return self;
}

-(void)executeLeakCheck:(QQLeakCheckCallback)callback{
    if(!_isChecking && _isStackLogging){
        _segmentChecker->initAllSegments();
        global_leakChecker->leakCheckingWillStart();
        if(_stackChecker->suspendAllChildThreads()){
            global_leakChecker->unlockSpinLock();
            _registerChecker->startPtrCheck();
            _stackChecker->startPtrCheck(2);
            _segmentChecker->startPtrcheck();
            _heapChecker->startPtrCheck();
            size_t total_size = 0;
            NSString *stackData = global_leakChecker->get_all_leak_stack(&total_size);
            _stackChecker->resumeAllChildThreads();
            _segmentChecker->removeAllSegments();
            global_leakChecker->leakCheckingWillFinish();
            callback(stackData,total_size);
        }
    }
}

-(void)startStackLogging{
    if(!_isStackLogging){
        global_leakChecker->setNeedSysStack(_needSysStack);
        global_leakChecker->setMaxStackDepth(_max_stack_depth);
        global_leakChecker->initLeakChecker();
        global_leakChecker->beginLeakChecker();
        _isStackLogging = true;
    }
}

-(void)stopStackLogging{
    if(_isStackLogging){
        global_leakChecker->clearLeakChecker();
        _isStackLogging = false;
    }
}

- (BOOL)isStackLogging
{
    return _isStackLogging;
}

-(void)setMaxStackDepth:(size_t)depth
{
    if(depth > 0) _max_stack_depth = depth;
}

-(void)setNeedSystemStack:(BOOL)isNeedSys
{
    _needSysStack = isNeedSys;
}

#pragma -mark getter
-(size_t)getRecordObjNumber
{
    return global_leakChecker->getPtrHashmap()->getRecordNum();
}

-(size_t)getRecordStackNumber
{
    return global_leakChecker->getPtrHashmap()->getRecordNum();
}

@end
