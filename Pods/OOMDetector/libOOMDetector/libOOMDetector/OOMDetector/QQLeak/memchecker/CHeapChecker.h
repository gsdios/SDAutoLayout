//
//  CHeapChecker.h
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

#ifndef C_HEAP_CHECKER
#define C_HEAP_CHECKER

#import <stdio.h>
#import <Foundation/Foundation.h>
#import <pthread.h>
#import <mach/mach.h>
#import <malloc/malloc.h>
#import "CMemoryChecker.h"

class CHeapChecker : public CMemoryChecker
{
public:
    CHeapChecker(CLeakChecker *checker):CMemoryChecker(checker){};
    void startPtrCheck();
private:
    static void check_ptr_in_heap(task_t task, void *baton, unsigned type, vm_range_t *ptrs, unsigned count);
    static void find_ptr_in_heap(task_t task, void *baton, unsigned type, vm_range_t *ptrs, unsigned count);
    void enumerate_ptr_in_zone (void *baton, const malloc_zone_t *zone,vm_range_recorder_t recorder);
};

#endif
