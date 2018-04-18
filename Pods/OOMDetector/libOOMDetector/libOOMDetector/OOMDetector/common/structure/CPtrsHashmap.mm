//
//  CPtrsHashmap.m
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

#import "CPtrsHashmap.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

CPtrsHashmap::~CPtrsHashmap()
{
    for(size_t i = 0; i < entry_num; i++){
        base_entry_t *entry = hashmap_entry + i;
        ptr_log_t *current = (ptr_log_t *)entry->root;
        entry->root = NULL;
        while(current != NULL){
            ptr_log_t *next = current->next;
            hashmap_free(current);
            current = next;
        }
    }
}

BOOL CPtrsHashmap::insertPtr(vm_address_t addr,base_ptr_log *ptr_log)
{
    size_t offset = hash_code(addr);
    base_entry_t *entry = hashmap_entry + offset;
    ptr_log_t *parent = (ptr_log_t *)entry->root;
    access_num++;
    collision_num++;
    if(parent == NULL){
        ptr_log_t *insert_data = create_hashmap_data(addr,ptr_log);
        entry->root = insert_data;
        record_num++;
        return YES;
    }
    else{
        if(compare(parent,addr) == 0){
            return NO;
        }
        ptr_log_t *current = parent->next;
        while(current != NULL){
            collision_num++;
            if(compare(current,addr) == 0){
                return NO;
            }
            parent = current;
            current = current->next;
        }
        ptr_log_t *insert_data = create_hashmap_data(addr,ptr_log);
        parent->next = insert_data;
        record_num++;
        return YES;
    }
}

BOOL CPtrsHashmap::removePtr(vm_address_t addr)
{
    size_t offset = hash_code(addr);
    base_entry_t *entry = hashmap_entry + offset;
    ptr_log_t *parent = (ptr_log_t *)entry->root;
    if(parent == NULL){
        return NO;
    }
    else{
        if(compare(parent,addr) == 0){
            entry->root = parent->next;
            hashmap_free(parent);
            record_num--;
            return YES;
        }
        ptr_log_t *current = parent->next;
        while(current != NULL){
            if(compare(current,addr) == 0){
                parent->next = current->next;
                hashmap_free(current);
                record_num--;
                return YES;
            }
            parent = current;
            current = current->next;
        }
        return NO;
    }
}

ptr_log_t *CPtrsHashmap::lookupPtr(vm_address_t addr)
{
    size_t offset = hash_code(addr);
    base_entry_t *entry = hashmap_entry + offset;
    ptr_log_t *parent = (ptr_log_t *)entry->root;
    if(parent != NULL){
        if(compare(parent,addr) == 0){
            return parent;
        }
        ptr_log_t *current = parent->next;
        while(current != NULL){
            if(compare(current,addr) == 0){
                return current;
            }
            parent = current;
            current = current->next;
        }
    }
    return NULL;
}

ptr_log_t *CPtrsHashmap::create_hashmap_data(vm_address_t addr,base_ptr_log *base_ptr)
{
    ptr_log_t *ptr_log = (ptr_log_t *)hashmap_malloc(sizeof(ptr_log_t));
    memcpy(ptr_log->md5,base_ptr->md5,16*sizeof(char));
    ptr_log->refer = 0;
    ptr_log->size = (size_t)base_ptr->size;
    ptr_log->address = addr;
    ptr_log->next = NULL;
    return ptr_log;
}

int CPtrsHashmap::compare(ptr_log_t *ptr_log,vm_address_t addr)
{
    vm_address_t addr1 = ptr_log->address;
    if(addr1 == addr) return 0;
    return -1;
}

size_t CPtrsHashmap::hash_code(vm_address_t addr)
{
    size_t offset = addr%(entry_num - 1);
    return offset;
}
