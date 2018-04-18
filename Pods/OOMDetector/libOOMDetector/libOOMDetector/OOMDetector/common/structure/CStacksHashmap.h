//
//  CStacksHashmap.h
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

#ifndef CStacksHashmap_h
#define CStacksHashmap_h

#import "CBaseHashmap.h"

typedef struct extra_t{
    const char      *name;
    uint32_t        size;
}extra_t;

typedef struct base_stack_t{
    uint16_t            depth;
    vm_address_t        **stack;
    extra_t             extra;
}base_stack_t;

typedef struct merge_stack_t{
    unsigned char       md5[16];
    uint32_t            depth;
    uint32_t            count;
    vm_address_t        **stack;
    merge_stack_t       *next;
    extra_t             extra;
} merge_stack_t;

typedef enum
{
    QQLeakMode = 1,
    OOMDetectorMode
}monitor_mode;


class CStacksHashmap : public CBaseHashmap
{
public:
    CStacksHashmap(size_t entrys,malloc_zone_t *memory_zone,monitor_mode mode);
    void insertStackAndIncreaseCountIfExist(unsigned char *md5,base_stack_t *stack);
    void removeIfCountIsZero(unsigned char *md5, size_t size);
    merge_stack_t *lookupStack(unsigned char *md5);
    monitor_mode mode;
    ~CStacksHashmap();
public:
    size_t oom_threshold;
protected:
    merge_stack_t *create_hashmap_data(unsigned char *md5,base_stack_t *stack);
    int compare(merge_stack_t *stack,unsigned char *md5);
    size_t hash_code(void *key);
};

#endif /* CMergestackHashmap_h */
