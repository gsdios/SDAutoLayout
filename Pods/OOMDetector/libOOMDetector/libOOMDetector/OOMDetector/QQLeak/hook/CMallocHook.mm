//
//  CMallocHook.m
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

#import "CMallocHook.h"
#import "QQLeakChecker.h"
#import "QQLeakMallocStackTracker.h"
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <stdlib.h>
#import <string.h>
#import <sys/types.h>
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <mach-o/nlist.h>
#import <objc/runtime.h>
#import <vector>
#import "CBaseHashmap.h"
#import "CStackHelper.h"
#import "OOMMemoryStackTracker.h"
#import "CLeakChecker.h"

extern CLeakChecker* global_leakChecker;

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

static bool isPaused;
static void* (*orig_malloc)(size_t);
static void* (*orig_calloc)(size_t, size_t);
static void* (*orig_valloc)(size_t);
static void* (*orig_block_copy)(const void *aBlock);


static void rebind_symbols_for_imagename(struct rebinding rebindings[],
                                  size_t rebindings_nel,
                                  const char *imagename);

void rebind_symbols_for_imagename(struct rebinding rebindings[],
                                  size_t rebindings_nel,
                                  const char *imagename)
{
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const mach_header_t* header = (const mach_header_t*)_dyld_get_image_header(i);
        const char* name = _dyld_get_image_name(i);
        const char* tmp = strrchr(name, '/');
        long slide = _dyld_get_image_vmaddr_slide(i);
        if (tmp) {
            name = tmp + 1;
        }
        if(strcmp(name,imagename) == 0){
            rebind_symbols_image((void *)header,
                                 slide,
                                 rebindings,
                                 rebindings_nel);
            break;
        }
    }
}


void *new_malloc(size_t size)
{
    void *ptr = orig_malloc(size);
    if(!isPaused){
        global_leakChecker->recordMallocStack((vm_address_t)ptr, (uint32_t)size,"malloc",2);
    }
#ifdef __enable_malloc_logger__
    malloc_printf("malloc ptr:%p size:%lu thread:%lu\n",ptr, size,mach_thread_self());
#endif
    return ptr;
}

void *new_calloc(size_t n,size_t size)
{
    void *ptr = orig_calloc(n,size);
    if(!isPaused){
        global_leakChecker->recordMallocStack((vm_address_t)ptr, (uint32_t)(n*size),"malloc",2);
    }
#ifdef __enable_malloc_logger__
    malloc_printf("calloc ptr:%p size:%lu thread:%lu\n",ptr, size*n,mach_thread_self());
#endif
    return ptr;
}

void *new_valloc(size_t size)
{
    void *ptr = orig_valloc(size);
    if(!isPaused){
        global_leakChecker->recordMallocStack((vm_address_t)ptr, (uint32_t)size,"malloc",2);
    }
#ifdef __enable_malloc_logger__
    malloc_printf("valloc ptr:%p size:%lu thread:%lu\n",ptr, size,mach_thread_self());
#endif
    return ptr;
}

void *new_block_copy(const void *aBlock){
    void *block = orig_block_copy(aBlock);
    if(!isPaused){
        global_leakChecker->recordMallocStack((vm_address_t)block, 0,"__NSMallocBlock__",2);
    }
#ifdef __enable_malloc_logger__
    malloc_printf("block_copy ptr:%p thread:%lu\n",block,mach_thread_self());
#endif
    return block;
}

void hookMalloc()
{
    if(!isPaused){
        orig_malloc = malloc;
        orig_calloc = calloc;
        orig_valloc = valloc;
        orig_block_copy = _Block_copy;
        rebind_symbols_for_imagename((struct rebinding[4]){{"malloc", (void*)new_malloc, (void **)&orig_malloc},{"valloc",(void*)valloc,(void**)&orig_valloc},{"calloc",(void*)new_calloc,(void**)&orig_calloc},{"_Block_copy",(void*)new_block_copy,(void**)&orig_block_copy}},4,getImagename());
    }
    else{
        isPaused = false;
    }

}

const char *getImagename()
{
    const char* name = _dyld_get_image_name(0);
    const char* tmp = strrchr(name, '/');
    if (tmp) {
        name = tmp + 1;
    }
    return name;
}


void unHookMalloc(){
    isPaused = true;
}

void pausedMallocTracking(){
    isPaused = true;
}

void resumeMallocTracking(){
    isPaused = false;
}
