//
//  CBaseHashmap.m
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

#import "CBaseHashmap.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

CBaseHashmap::CBaseHashmap(size_t entrys,malloc_zone_t *zone)
{
    malloc_zone = zone;
    entry_num = entrys;
    hashmap_entry = (base_entry_t *)hashmap_malloc((entry_num)*sizeof(base_entry_t));
    for(size_t i = 0; i < entry_num;i++){
        base_entry_t *entry_tmp = hashmap_entry + i;
        entry_tmp->root = NULL;
    }
    record_num = 0;
    access_num = 0;
    collision_num = 0;
}

CBaseHashmap::~CBaseHashmap(){
    hashmap_free(hashmap_entry);
}

void *CBaseHashmap::hashmap_malloc(size_t size){
    return malloc_zone->malloc(malloc_zone,size);
}

void CBaseHashmap::hashmap_free(void *ptr){
    malloc_zone->free(malloc_zone,ptr);
}

base_entry_t *CBaseHashmap::getHashmapEntry()
{
    return hashmap_entry;
}

size_t CBaseHashmap::getEntryNum()
{
    return entry_num;
}

size_t CBaseHashmap::getRecordNum()
{
    return record_num;
}
size_t CBaseHashmap::getAccessNum()
{
    return access_num;
}
size_t CBaseHashmap::getCollisionNum()
{
    return collision_num;
}
