//
//  CLeakedHashmap.h
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

#ifndef CMergedHashmap_h
#define CMergedHashmap_h

#import "CBaseHashmap.h"
#import "CPtrsHashmap.h"

typedef struct leaked_ptr_t{
    unsigned char md5[16];
    uint32_t leak_count;
    vm_address_t address;
    leaked_ptr_t *next;
} leaked_ptr_t;

class CLeakedHashmap : public CBaseHashmap
{
public:
    CLeakedHashmap(size_t entrys,malloc_zone_t *memory_zone):CBaseHashmap(entrys,memory_zone){};
    void insertLeakPtrAndIncreaseCountIfExist(unsigned char *md5,ptr_log_t *ptr_log);
    ~CLeakedHashmap();
protected:
    leaked_ptr_t *create_hashmap_data(unsigned char *md5,ptr_log_t *ptr_log);
    int compare(leaked_ptr_t *leak_ptr,unsigned char *md5);
    size_t hash_code(void *key);
};

#endif /* CMergedHashmap_h */
