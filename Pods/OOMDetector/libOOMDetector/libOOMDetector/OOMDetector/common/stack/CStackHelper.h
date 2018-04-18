//
//  CStackHelper.h
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


#ifndef CStackHelper_h
#define CStackHelper_h

#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <vector>
#import <mach/mach.h>
#import <malloc/malloc.h>
#import "QQLeakPredefines.h"
#import <mach/vm_types.h>
#import "execinfo.h"
#import <CommonCrypto/CommonDigest.h>
#import "CBaseHashmap.h"
#import "CStacksHashmap.h"
#import "CPtrsHashmap.h"

typedef struct
{
    const char* name;
    long loadAddr;
    long beginAddr;
    long endAddr;
}segImageInfo;

typedef struct AppImages
{
    size_t size;
    segImageInfo **imageInfos;
}AppImages;

class CStackHelper
{
public:
    CStackHelper();
    ~CStackHelper();
    bool isInAppAddress(vm_address_t addr);
    bool getImageByAddr(vm_address_t addr,segImageInfo *image);
    size_t recordBacktrace(BOOL needSystemStack,size_t needAppStackCount,size_t backtrace_to_skip, vm_address_t **app_stack,unsigned char *md5,size_t max_stack_depth);
private:
    AppImages allImages;
};

#endif /* CMachOHelpler_h */
