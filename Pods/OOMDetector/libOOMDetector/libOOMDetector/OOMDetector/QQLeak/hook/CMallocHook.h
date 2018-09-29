//
//  CMallocHook.h
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

#ifndef CMallocHook_h
#define CMallocHook_h

#import <stdlib.h>
#import <stdio.h>
#import <assert.h>
#import <malloc/malloc.h>
#import "QQLeakPredefines.h"
#import "fishhook.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    void hookMalloc();
    void unHookMalloc();
    void pausedMallocTracking();
    void resumeMallocTracking();
    const char *getImagename();
    
#ifdef __cplusplus
}
#endif

#endif /* CMallocHook_h */
