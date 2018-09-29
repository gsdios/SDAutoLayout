//
//  CHeapChecker.mm
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


#import "CHeapChecker.h"
#import <vector>
#import "CLeakChecker.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

extern kern_return_t memory_reader (task_t task, vm_address_t remote_address, vm_size_t size, void **local_memory);

void CHeapChecker::check_ptr_in_heap(task_t task, void *baton, unsigned type, vm_range_t *ptrs, unsigned count)
{
    CHeapChecker *heapChecker = (CHeapChecker *)baton;
    while(count--) {
        vm_range_t range = {ptrs->address,ptrs->size};
        heapChecker->check_ptr_in_vmrange(range,HEAP_TYPE);
        ptrs++;
    }

}

void CHeapChecker::startPtrCheck(){
    vm_address_t *zones = NULL;
    unsigned int zone_num;
    kern_return_t err = malloc_get_all_zones (mach_task_self(), memory_reader, &zones, &zone_num);
    if (KERN_SUCCESS == err)
    {
        for (int i = 0; i < zone_num; ++i)
        {
            if(zones[i] == (vm_address_t)(leakChecker->getMemoryZone())){
                continue;
            }
            enumerate_ptr_in_zone(this,(const malloc_zone_t *)zones[i],CHeapChecker::check_ptr_in_heap);
        }
    }
}

void CHeapChecker::enumerate_ptr_in_zone (void *baton, const malloc_zone_t *zone,vm_range_recorder_t recorder)
{
    if (zone && zone->introspect && zone->introspect->enumerator)
        zone->introspect->enumerator (mach_task_self(),
                                      this,
                                      MALLOC_PTR_IN_USE_RANGE_TYPE,
                                      (vm_address_t)zone,
                                      memory_reader,
                                      recorder);
}
