
//
//  CMemoryChecker.m
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

#import "CMemoryChecker.h"
#import <libkern/OSAtomic.h>
#import <malloc/malloc.h>
#import "CObjcFilter.h"
#import "QQLeakMallocStackTracker.h"
#import "CLeakChecker.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

kern_return_t memory_reader (task_t task, vm_address_t remote_address, vm_size_t size, void **local_memory)
{
    *local_memory = (void*) remote_address;
    return KERN_SUCCESS;
}

void CMemoryChecker::check_ptr_in_vmrange(vm_range_t range,memory_type type)
{
    const uint32_t align_size = sizeof(void *);
    vm_address_t vm_addr = range.address;
    vm_size_t vm_size = range.size;
    vm_size_t end_addr = vm_addr + vm_size;
    if (align_size <= vm_size)
    {
        uint8_t *ptr_addr = (uint8_t *)vm_addr;
        for (uint64_t addr = vm_addr;
             addr < end_addr && ((end_addr - addr) >= align_size);
             addr += align_size, ptr_addr += align_size)
        {
            vm_address_t *dest_ptr = (vm_address_t *)ptr_addr;
            leakChecker->findPtrInMemoryRegion(*dest_ptr);
        }
    }
}
