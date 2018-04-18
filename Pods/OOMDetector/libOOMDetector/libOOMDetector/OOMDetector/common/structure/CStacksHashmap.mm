//
//  CStacksHashmap.m
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

#import "CStacksHashmap.h"
#import "QQLeakMallocStackTracker.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

CStacksHashmap::CStacksHashmap(size_t entrys,malloc_zone_t *zone,monitor_mode monitorMode):CBaseHashmap(entrys,zone)
{
    mode = monitorMode;
}

CStacksHashmap::~CStacksHashmap()
{
    for(size_t i = 0; i < entry_num; i++){
        base_entry_t *entry = hashmap_entry + i;
        merge_stack_t *current = (merge_stack_t *)entry->root;
        entry->root = NULL;
        while(current != NULL){
            merge_stack_t *next = current->next;
            if(current->stack != NULL){
                hashmap_free(current->stack);
            }
            hashmap_free(current);
            current = next;
        }
    }
}

void CStacksHashmap::insertStackAndIncreaseCountIfExist(unsigned char *md5,base_stack_t *stack)
{
    size_t offset = hash_code(md5);
    base_entry_t *entry = hashmap_entry + offset;
    merge_stack_t *parent = (merge_stack_t *)entry->root;
    access_num++;
    collision_num++;
    if(parent == NULL){
        merge_stack_t *insert_data = create_hashmap_data(md5,stack);
        entry->root = insert_data;
        record_num++;
        return ;
    }
    else{
        if(compare(parent,md5) == 0){
            parent->count++;
            if(mode == QQLeakMode){
                parent->extra.name = stack->extra.name;
            }
            else {
                parent->extra.name = stack->extra.name;
                parent->extra.size += stack->extra.size;
                if(parent->extra.size > oom_threshold && parent->stack == NULL)
                {
                    parent->stack = (vm_address_t **)hashmap_malloc(stack->depth*sizeof(vm_address_t*));
                    memcpy(parent->stack, stack->stack, stack->depth * sizeof(vm_address_t *));
                    parent->depth = stack->depth;
                }
            }
            return;
        }
        merge_stack_t *current = parent->next;
        while(current != NULL){
            collision_num++;
            if(compare(current,md5) == 0){
                current->count++;
                if(mode == QQLeakMode){
                    current->extra.name = stack->extra.name;
                }
                else {
                    current->extra.name = stack->extra.name;
                    current->extra.size += stack->extra.size;
                    if(current->extra.size > oom_threshold && current->stack == NULL)
                    {
                        current->stack = (vm_address_t **)hashmap_malloc(stack->depth*sizeof(vm_address_t*));
                        memcpy(current->stack, stack->stack, stack->depth * sizeof(vm_address_t *));
                        current->depth = stack->depth;
                    }
                }
                return ;
            }
            parent = current;
            current = current->next;
        }
        merge_stack_t *insert_data = create_hashmap_data(md5,stack);
        parent->next = insert_data;
        record_num++;
        return ;
    }
}

void CStacksHashmap::removeIfCountIsZero(unsigned char *md5,size_t size)
{
    size_t offset = hash_code(md5);
    base_entry_t *entry = hashmap_entry + offset;
    merge_stack_t *parent = (merge_stack_t *)entry->root;
    if(parent == NULL){
        return ;
    }
    else{
        if(compare(parent,md5) == 0){
            if(mode == OOMDetectorMode){
                if(parent->extra.size < size) parent->extra.size = 0;
                else parent->extra.size -= size;
            }
            if(--(parent->count) <= 0 || (mode == OOMDetectorMode && parent->extra.size == 0))
            {
                entry->root = parent->next;
                if(parent->stack != NULL){
                    hashmap_free(parent->stack);
                }
                hashmap_free(parent);
                record_num--;
            }
            return ;
        }
        merge_stack_t *current = parent->next;
        while(current != NULL){
            if(compare(current,md5) == 0){
                if(mode == OOMDetectorMode){
                    if(current->extra.size < size) current->extra.size = 0;
                    else current->extra.size -= size;
                }
                if(--(current->count) <= 0 || (mode == OOMDetectorMode && current->extra.size == 0))
                {
                    parent->next = current->next;
                    if(current->stack != NULL){
                        hashmap_free(current->stack);
                    }
                    hashmap_free(current);
                    record_num--;
                }
                return ;
            }
            parent = current;
            current = current->next;
        }
    }
}

merge_stack_t *CStacksHashmap::lookupStack(unsigned char *md5)
{
    size_t offset = hash_code(md5);
    base_entry_t *entry = hashmap_entry + offset;
    merge_stack_t *parent = (merge_stack_t *)entry->root;
    if(parent == NULL){
        return NULL;
    }
    else{
        if(compare(parent,md5) == 0){
            return parent;
        }
        merge_stack_t *current = parent->next;
        while(current != NULL){
            if(compare(current,md5) == 0){
                return current;
            }
            parent = current;
            current = current->next;
        }
    }
    return NULL;
}

merge_stack_t *CStacksHashmap::create_hashmap_data(unsigned char *md5,base_stack_t *base_stack)
{
    merge_stack_t *merge_data = (merge_stack_t *)hashmap_malloc(sizeof(merge_stack_t));
    memcpy(merge_data->md5,md5,16*sizeof(char));
    merge_data->count = 1;
    BOOL needStack = NO;
    if(mode == QQLeakMode){
        merge_data->extra.name = base_stack->extra.name;
        needStack = YES;
    }
    else {
        merge_data->extra.name = base_stack->extra.name;
        merge_data->extra.size = base_stack->extra.size;
    }
    if(base_stack->extra.size > oom_threshold || mode == QQLeakMode){
        merge_data->stack = (vm_address_t **)hashmap_malloc(base_stack->depth*sizeof(vm_address_t*));
        memcpy(merge_data->stack, base_stack->stack, base_stack->depth * sizeof(vm_address_t *));
        merge_data->depth = base_stack->depth;
    }
    else {
        merge_data->stack = NULL;
        merge_data->depth = 0;
    }
    merge_data->next = NULL;
    return merge_data;
}

int CStacksHashmap::compare(merge_stack_t *stack,unsigned char *md5)
{
    unsigned char *md5_1 = stack->md5;
    if(strncmp((char *)md5_1,(char *)md5,16) == 0) return 0;
    return -1;
}

size_t CStacksHashmap::hash_code(void *key)
{
    uint64_t *value_1 = (uint64_t *)key;
    uint64_t *value_2 = value_1 + 1;
    size_t offset = (size_t)(*value_1 + *value_2)%(entry_num - 1);
    return offset;
}
