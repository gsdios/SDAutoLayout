//
//  CStackChecker.mm
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

#import "CStackChecker.h"
#import <dlfcn.h>
#import <malloc/malloc.h>
#import <mach/mach_init.h>
#import <mach/thread_act.h>
#import <mach/mach_port.h>
#import <mach/vm_map.h>

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

void CStackChecker::startPtrCheck(size_t bt){
    thread_act_array_t thread_list;
    mach_msg_type_number_t thread_count;
    kern_return_t ret = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (ret != KERN_SUCCESS) {
        return;
    }
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        thread_t thread = thread_list[i];
        
        pthread_t pthread = pthread_from_mach_thread_np(thread);
        vm_size_t stacksize = pthread_get_stacksize_np(pthread);
        if(stacksize > 0){
            void *stack = pthread_get_stackaddr_np(pthread);
            if(stack != NULL){
                vm_address_t stack_ptr;
                if(thread == mach_thread_self()){
                    find_thread_fp(thread, &stack_ptr, bt);
                }
                else{
                    find_thread_sp(thread, &stack_ptr);
                }
                vm_size_t depth = (vm_address_t)stack - stack_ptr + 1;
                if(depth > 0 && depth <= stacksize){
                    vm_range_t range = {stack_ptr,depth};
                    check_ptr_in_vmrange(range, STACK_TYPE);
                }
            }
        }
    }
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        mach_port_deallocate(mach_task_self(), thread_list[i]);
    }
    vm_deallocate(mach_task_self(), (vm_address_t)thread_list, thread_count * sizeof(thread_t));
}

bool CStackChecker::find_thread_sp(thread_t thread,vm_address_t *sp)
{
#if !TARGET_IPHONE_SIMULATOR
    mach_msg_type_number_t stateCount = MY_THREAD_STATE_COUTE;
    _STRUCT_MCONTEXT _mcontext;
    kern_return_t ret = thread_get_state(thread, MY_THREAD_STATE, (thread_state_t)&_mcontext.__ss, &stateCount);
    
    if (ret != KERN_SUCCESS) {
        return false;
    }
    stateCount = MY_EXCEPTION_STATE_COUNT;
    ret = thread_get_state(thread, MY_EXCEPITON_STATE, (thread_state_t)&_mcontext.__es, &stateCount);
    
    if (ret != KERN_SUCCESS) {
        return false;
    }
    
    if (_mcontext.__es.__exception != 0) {
        return false;
    }
    *sp = (vm_address_t)_mcontext.__ss.__sp;
    return true;
#else
    return false;
#endif
}

bool CStackChecker::find_thread_fp(thread_t thread,vm_address_t *fp,size_t bt_count)
{
#if !TARGET_IPHONE_SIMULATOR
    mach_msg_type_number_t stateCount = MY_THREAD_STATE_COUTE;
    _STRUCT_MCONTEXT _mcontext;
    kern_return_t ret = thread_get_state(thread, MY_THREAD_STATE, (thread_state_t)&_mcontext.__ss, &stateCount);
    
    if (ret != KERN_SUCCESS) {
        return false;
    }
    stateCount = MY_EXCEPTION_STATE_COUNT;
    ret = thread_get_state(thread, MY_EXCEPITON_STATE, (thread_state_t)&_mcontext.__es, &stateCount);
    
    if (ret != KERN_SUCCESS) {
        return false;
    }
    
    if (_mcontext.__es.__exception != 0) {
        return false;
    }
    vm_size_t len = sizeof(fp);
#ifdef __LP64__
    ret = vm_read_overwrite(mach_task_self(), (vm_address_t)(_mcontext.__ss.__fp),len, (vm_address_t)fp, &len);

#else
    ret = vm_read_overwrite(mach_task_self(), (vm_address_t)(_mcontext.__ss.__r[7]),len, (vm_address_t)fp, &len);
#endif
    if (ret != KERN_SUCCESS) {
        return false;
    }
    ret = vm_read_overwrite(mach_task_self(), *fp,len, (vm_address_t)fp, &len);
    if (ret != KERN_SUCCESS) {
        return false;
    }
    for(size_t i=0;i < bt_count;i++){
        ret = vm_read_overwrite(mach_task_self(), *fp,len, (vm_address_t)fp, &len);
    }
    if (ret != KERN_SUCCESS) {
        return false;
    }
    return true;
#else
    return false;
#endif
}

BOOL CStackChecker::suspendAllChildThreads(){
    kern_return_t ret = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (ret != KERN_SUCCESS) {
        return false;
    }
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        thread_t thread = thread_list[i];
        if (thread == mach_thread_self()) {
            continue;
        }
        if (KERN_SUCCESS != thread_suspend(thread)) {
            for (mach_msg_type_number_t j = 0; j < i; j++){
                thread_t pre_thread = thread_list[j];
                if (pre_thread == mach_thread_self()) {
                    continue;
                }
                thread_resume(pre_thread);
            }
            for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
                mach_port_deallocate(mach_task_self(), thread_list[i]);
            }
            vm_deallocate(mach_task_self(), (vm_address_t)thread_list, thread_count * sizeof(thread_t));
            return false;
        }
    }
    return YES;
}

void CStackChecker::resumeAllChildThreads(){
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        thread_t thread = thread_list[i];
        if (thread == mach_thread_self()) {
            continue;
        }
        if(thread_resume(thread) != KERN_SUCCESS)
        {
            malloc_printf("Can't resume thread:%lu\n",thread);
        }
    }
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        mach_port_deallocate(mach_task_self(), thread_list[i]);
    }
    vm_deallocate(mach_task_self(), (vm_address_t)thread_list, thread_count * sizeof(thread_t));
    thread_list = NULL;
    thread_count = 0;
}
