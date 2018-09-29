//
//  CommonMallocLogger.m
//  QQLeakDemo
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

#import "CommonMallocLogger.h"
#import "QQLeakMallocStackTracker.h"
#import "OOMMemoryStackTracker.h"
#import "CLeakChecker.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

malloc_zone_t *global_memory_zone;

void common_stack_logger(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t backtrace_to_skip)
{
    //QQLeak
    malloc_stack_logger(type,arg1,arg2,arg3,result,backtrace_to_skip);
    //OOMDetector
    oom_malloc_logger(type,arg1,arg2,arg3,result,backtrace_to_skip);
}
