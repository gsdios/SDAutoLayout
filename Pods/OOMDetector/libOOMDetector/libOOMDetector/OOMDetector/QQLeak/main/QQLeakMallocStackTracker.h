//
//  QQLeakMallocStackTracker.h
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

#ifndef CMallocStackLogging_h
#define CMallocStackLogging_h

#import <UIKit/UIKit.h>
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <malloc/malloc.h>
#import <stdarg.h>
#import <mach/mach_init.h>
#import <libkern/OSAtomic.h>
#import <sys/mman.h>
#import <mach/vm_statistics.h>
#import <malloc/malloc.h>
#import "QQLeakPredefines.h"
#import "CommonMallocLogger.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    void malloc_stack_logger(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t backtrace_to_skip);

#ifdef __cplusplus
}
#endif

#endif /* CMallocStackLogging_h */

