//
//  QQLeakMallocStackTracker.m
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


#import "QQLeakMallocStackTracker.h"
#import "CLeakChecker.h"
#import "QQLeakChecker.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

extern CLeakChecker* global_leakChecker;

void malloc_stack_logger(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t backtrace_to_skip)
{
    if(global_leakChecker == NULL || !global_leakChecker->enableStackTracking){
        return;
    }
    if(arg1 == (uintptr_t)global_leakChecker->getMemoryZone()){
        global_leakChecker->isThreadNeedTracking(NULL);
        return ;
    }
    if (type & stack_logging_flag_zone) {
        type &= ~stack_logging_flag_zone;
    }
    if (type == (stack_logging_type_dealloc|stack_logging_type_alloc)) {
        if (arg2 == result) {
            return;
        }
        if (!arg2) {
            if(!global_leakChecker->isLeakChecking){
                const char *name = NULL;
                if(!global_leakChecker->isThreadNeedTracking(&name)) return;
                global_leakChecker->recordMallocStack(result, (uint32_t)arg3,name,4);
            }
            return;
        } else {
            global_leakChecker->removeMallocStack((vm_address_t)arg2);
            if(!global_leakChecker->isLeakChecking){
                const char *name = NULL;
                if(!global_leakChecker->isThreadNeedTracking(&name)) return;
                global_leakChecker->recordMallocStack(result, (uint32_t)arg3,name,4);
            }
            return;
        }
    }
    if (type == stack_logging_type_dealloc) {
        if (!arg2) return;
        global_leakChecker->removeMallocStack((vm_address_t)arg2);
    }
    else if((type & stack_logging_type_alloc) != 0){
        if(!global_leakChecker->isLeakChecking){
            const char *name = NULL;
            if(!global_leakChecker->isThreadNeedTracking(&name)) return;
            global_leakChecker->recordMallocStack(result, (uint32_t)arg2,name,4);
        }
    }
}

