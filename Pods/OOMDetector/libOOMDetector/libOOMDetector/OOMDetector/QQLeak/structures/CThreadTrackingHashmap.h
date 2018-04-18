//
//   CThreadTrackingHashmap.h
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

#ifndef CThreadTrackingHashmap_h
#define CThreadTrackingHashmap_h

#import <mach/thread_act.h>
#import <mach/mach_port.h>
#import <mach/mach_init.h>
#import <pthread.h>
#import "CBaseHashmap.h"

typedef struct thread_data_t{
    bool needTrack;
    const char *name;
    thread_t thread;
    thread_data_t *next;
}thread_data_t;

class CThreadTrackingHashmap : public CBaseHashmap
{
public:
    CThreadTrackingHashmap(size_t entrys,malloc_zone_t *memory_zone):CBaseHashmap(entrys,memory_zone){};
    void insertThreadAndUpdateIfExist(thread_t thread,const char *name);
    thread_data_t *lookupThread(thread_t thread);
    ~CThreadTrackingHashmap();
protected:
    thread_data_t *create_hashmap_data(thread_t thread,const char *name);
    int compare(thread_data_t *thread_data,thread_t thread);
    size_t hash_code(thread_t thread);
};

#endif /* CThreadHashmap_h */
