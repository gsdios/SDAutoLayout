//
//  CStackChecker.h
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

#ifndef C_STACK_CHECKER
#define C_STACK_CHECKER

#import <Foundation/Foundation.h>
#import <stdio.h>
#import <pthread.h>
#import <mach/mach.h>
#import "CMemoryChecker.h"

class CStackChecker : public CMemoryChecker
{
public:
    CStackChecker(CLeakChecker *checker):CMemoryChecker(checker){};
    BOOL suspendAllChildThreads();
    void resumeAllChildThreads();
    void startPtrCheck(size_t bt);
private:
    bool find_thread_sp(thread_t thread,vm_address_t *sp);
    bool find_thread_fp(thread_t thread,vm_address_t *fp,size_t bt_count);
private:
    thread_act_array_t thread_list;
    mach_msg_type_number_t thread_count;
};

#endif
