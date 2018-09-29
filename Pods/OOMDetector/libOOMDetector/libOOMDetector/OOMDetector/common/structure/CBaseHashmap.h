//
//  CBaseHashmap.h
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

#ifndef CBaseHashmap_h
#define CBaseHashmap_h

#import <stdlib.h>
#import <stdio.h>
#import <assert.h>
#import <malloc/malloc.h>
#import <CommonCrypto/CommonDigest.h>
#import "QQLeakPredefines.h"

typedef struct base_entry_t
{
    void *root;
}base_entry_t;

class CBaseHashmap
{
public:
    CBaseHashmap(size_t entrys,malloc_zone_t *zone);
    virtual ~CBaseHashmap();
    base_entry_t *getHashmapEntry();
    size_t getEntryNum();
    size_t getRecordNum();
    size_t getAccessNum();
    size_t getCollisionNum();
protected:
    void *hashmap_malloc(size_t size);
    void hashmap_free(void *ptr);
protected:
    base_entry_t *hashmap_entry;
    size_t  entry_num;
    size_t	record_num;
    size_t  access_num;
    size_t  collision_num;
    malloc_zone_t *malloc_zone;
};

#endif /* CBaseHashmap_h */
