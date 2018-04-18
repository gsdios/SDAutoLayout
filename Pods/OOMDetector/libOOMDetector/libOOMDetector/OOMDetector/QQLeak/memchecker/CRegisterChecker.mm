//
//  CRegisterChecker.m
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

#import "CRegisterChecker.h"
#import "CLeakChecker.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

bool CRegisterChecker::startPtrCheck(){
#if !TARGET_IPHONE_SIMULATOR
    thread_act_array_t thread_list;
    mach_msg_type_number_t thread_count;
    kern_return_t ret = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (ret != KERN_SUCCESS) {
        return false;
    }
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        thread_t thread = thread_list[i];
        if(thread != mach_thread_self()){
            _STRUCT_MCONTEXT _mcontext;
            mach_msg_type_number_t stateCount = MY_EXCEPTION_STATE_COUNT;
            kern_return_t ret = thread_get_state(thread, MY_EXCEPITON_STATE, (thread_state_t)&_mcontext.__es, &stateCount);
            if (ret != KERN_SUCCESS) {
                return false;
            }
            if (_mcontext.__es.__exception != 0) {
                return false;
            }
            stateCount = MY_THREAD_STATE_COUTE;
            ret = thread_get_state(thread, MY_THREAD_STATE, (thread_state_t)&_mcontext.__ss, &stateCount);
            if (ret != KERN_SUCCESS) {
                return false;
            }
#ifdef __LP64__
            vm_address_t x_regs[29];
            vm_size_t len = sizeof(x_regs);
            ret = vm_read_overwrite(mach_task_self(), (vm_address_t)(_mcontext.__ss.__x),len, (vm_address_t)x_regs, &len);
            for(int i = 0;i < 29;i++){
               leakChecker->findPtrInMemoryRegion((vm_address_t)x_regs[i]);
            }
#else
            vm_address_t r_regs[13];
            vm_size_t len = sizeof(r_regs);
            ret = vm_read_overwrite(mach_task_self(), (vm_address_t)(_mcontext.__ss.__r),len, (vm_address_t)r_regs, &len);
            for(int i = 0;i < 13;i++){
                leakChecker->findPtrInMemoryRegion((vm_address_t)r_regs[i]);
            }
#endif
        }
    }
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        mach_port_deallocate(mach_task_self(), thread_list[i]);
    }
    vm_deallocate(mach_task_self(), (vm_address_t)thread_list, thread_count * sizeof(thread_t));
    return true;
#else
    return true;
#endif
}
