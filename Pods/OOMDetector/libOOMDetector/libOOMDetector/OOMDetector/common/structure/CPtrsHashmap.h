//
//  CPtrsHashmap.h
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

#ifndef CPtrHashmap_h
#define CPtrHashmap_h

#import "CBaseHashmap.h"

typedef struct base_ptr_log{
    unsigned char *md5;
    uint32_t size;
} base_ptr_log;

typedef struct ptr_log_t{
    unsigned char  md5[16];
    size_t size;
    size_t refer;
    vm_address_t address;
    ptr_log_t *next;
} ptr_log_t;

class CPtrsHashmap : public CBaseHashmap
{
public:
    CPtrsHashmap(size_t entrys,malloc_zone_t *memory_zone):CBaseHashmap(entrys,memory_zone){};
    BOOL insertPtr(vm_address_t addr,base_ptr_log *ptr_log);
    BOOL removePtr(vm_address_t addr);
    ptr_log_t *lookupPtr(vm_address_t addr);
    ~CPtrsHashmap();
protected:
    ptr_log_t *create_hashmap_data(vm_address_t addr,base_ptr_log *base_ptr);
    int compare(ptr_log_t *ptr_log,vm_address_t addr);
    size_t hash_code(vm_address_t addr);
};

#endif /* CPtrHashmap_h */
