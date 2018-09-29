//
//  CLeakedHashmap.m
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

#import "CLeakedHashmap.h"
#import "CPtrsHashmap.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

CLeakedHashmap::~CLeakedHashmap()
{
    for(size_t i = 0; i < entry_num; i++){
        base_entry_t *entry = hashmap_entry + i;
        leaked_ptr_t *current = (leaked_ptr_t *)entry->root;
        entry->root = NULL;
        while(current != NULL){
            leaked_ptr_t *next = current->next;
            hashmap_free(current);
            current = next;
        }
    }
}

void CLeakedHashmap::insertLeakPtrAndIncreaseCountIfExist(unsigned char *md5,ptr_log_t *ptr_log)
{
    size_t offset = hash_code(md5);
    base_entry_t *entry = hashmap_entry + offset;
    leaked_ptr_t *parent = (leaked_ptr_t *)entry->root;
    access_num++;
    collision_num++;
    if(parent == NULL){
        leaked_ptr_t *insert_data = create_hashmap_data(md5,ptr_log);
        entry->root = insert_data;
        record_num++;
        return ;
    }
    else{
        if(compare(parent,md5) == 0){
            parent->leak_count++;
            parent->address = ptr_log->address;
            return;
        }
        leaked_ptr_t *current = parent->next;
        while(current != NULL){
            collision_num++;
            if(compare(current,md5) == 0){
                current->leak_count++;
                current->address = ptr_log->address;
                return ;
            }
            parent = current;
            current = current->next;
        }
        leaked_ptr_t *insert_data = create_hashmap_data(md5,ptr_log);
        parent->next = insert_data;
        record_num++;
        return;
    }
}

leaked_ptr_t *CLeakedHashmap::create_hashmap_data(unsigned char *md5,ptr_log_t *ptr_log)
{
    leaked_ptr_t *leak_ptr = (leaked_ptr_t *)hashmap_malloc(sizeof(leaked_ptr_t));
    memcpy(leak_ptr->md5,md5,16*sizeof(char));
    leak_ptr->address = ptr_log->address;
    leak_ptr->leak_count = 1;
    leak_ptr->next = NULL;
    return leak_ptr;
}

int CLeakedHashmap::compare(leaked_ptr_t *leak_ptr,unsigned char *md5)
{
    unsigned char *md5_1 = leak_ptr->md5;
    if(strncmp((char *)md5_1,(char *)md5,16)== 0) return 0;
    return -1;
}

size_t CLeakedHashmap::hash_code(void *key)
{
    uint64_t *value_1 = (uint64_t *)key;
    uint64_t *value_2 = value_1 + 1;
    size_t offset = (size_t)(*value_1 + *value_2)%(entry_num - 1);
    return offset;
}
