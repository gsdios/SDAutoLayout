
//
//  CThreadTrackingHashmap.m
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

#import "CThreadTrackingHashmap.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

CThreadTrackingHashmap::~CThreadTrackingHashmap()
{
    for(size_t i = 0; i < entry_num; i++){
        base_entry_t *entry = hashmap_entry + i;
        thread_data_t *current = (thread_data_t *)entry->root;
        entry->root = NULL;
        while(current != NULL){
            thread_data_t *next = current->next;
            hashmap_free(current);
            current = next;
        }
    }
}

void CThreadTrackingHashmap::insertThreadAndUpdateIfExist(thread_t thread,const char *name)
{
    size_t offset = hash_code(thread);
    base_entry_t *entry = hashmap_entry + offset;
    thread_data_t *parent = (thread_data_t *)entry->root;
    access_num++;
    collision_num++;
    if(parent == NULL){
        thread_data_t *insert_data = create_hashmap_data(thread,name);
        entry->root = insert_data;
        record_num++;
    }
    else{
        if(compare(parent,thread) == 0){
            parent->needTrack = true;
            parent->name = name;
            return ;
        }
        thread_data_t *current = parent->next;
        while(current != NULL){
            collision_num++;
            if(compare(current,thread) == 0){
                current->needTrack = true;
                current->name = name;
                return ;
            }
            parent = current;
            current = current->next;
        }
        thread_data_t *insert_data = create_hashmap_data(thread,name);
        parent->next = insert_data;
        record_num++;
    }
}

thread_data_t *CThreadTrackingHashmap::lookupThread(thread_t thread)
{
    size_t offset = hash_code(thread);
    base_entry_t *entry = hashmap_entry + offset;
    thread_data_t *parent = (thread_data_t *)entry->root;
    if(parent != NULL){
        if(compare(parent,thread) == 0){
            return parent;
        }
        thread_data_t *current = parent->next;
        while(current != NULL){
            if(compare(current,thread) == 0){
                return current;
            }
            parent = current;
            current = current->next;
        }
    }
    return NULL;
}


thread_data_t *CThreadTrackingHashmap::create_hashmap_data(thread_t thread,const char *name)
{
    thread_data_t *thread_data = (thread_data_t *)hashmap_malloc(sizeof(thread_data_t));
    thread_data->needTrack = true;
    thread_data->name = name;
    thread_data->thread = thread;
    thread_data->next = NULL;
    return thread_data;
}

int CThreadTrackingHashmap::compare(thread_data_t *thread_data,thread_t thread)
{
    if(thread_data->thread == thread) return 0;
    return -1;
}

size_t CThreadTrackingHashmap::hash_code(thread_t thread)
{
    size_t offset = (size_t)(thread) % (entry_num - 1);
    return offset;
}
