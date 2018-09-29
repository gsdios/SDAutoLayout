//
//  CObjcFilter.h
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

#ifndef CObjcManager_h
#define CObjcManager_h

#import <Foundation/Foundation.h>
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <malloc/malloc.h>
#import "QQLeakPredefines.h"
#import <unordered_set>
#import <objc/runtime.h>

class CObjcFilter
{
public:
    ~CObjcFilter();
    void initBlackClass();
    void updateCurrentClass();
    void clearCurrentClass();
    bool isClassInBlackList(Class cl);
    const char *getObjectNameExceptBlack(void *obj);
    const char *getObjectName(void *obj);
private:
    std::unordered_set<vm_address_t> *black_class_set = NULL;
    std::unordered_set<vm_address_t> *current_class_set = NULL;
};

#endif /* CObjcManager_h */
