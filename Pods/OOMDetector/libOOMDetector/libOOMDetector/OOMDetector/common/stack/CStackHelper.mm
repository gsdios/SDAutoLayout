//
//  CMachOHelper.m
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

#import "CStackHelper.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

CStackHelper::~CStackHelper()
{
    for (size_t i = 0; i < allImages.size; i++)
    {
        free(allImages.imageInfos[i]);
    }
    free(allImages.imageInfos);
    allImages.imageInfos = NULL;
    allImages.size = 0;
}

CStackHelper::CStackHelper()
{
    uint32_t count = _dyld_image_count();
    allImages.imageInfos =(segImageInfo **)malloc(count*sizeof(segImageInfo*));
    allImages.size = 0;
    for (uint32_t i = 0; i < count; i++) {
        const mach_header_t* header = (const mach_header_t*)_dyld_get_image_header(i);
        const char* name = _dyld_get_image_name(i);
        const char* tmp = strrchr(name, '/');
        long slide = _dyld_get_image_vmaddr_slide(i);
        if (tmp) {
            name = tmp + 1;
        }
        long offset = (long)header + sizeof(mach_header_t);
        for (unsigned int i = 0; i < header->ncmds; i++) {
            const segment_command_t* segment = (const segment_command_t*)offset;
            if (segment->cmd == MY_SEGMENT_CMD_TYPE && strcmp(segment->segname, SEG_TEXT) == 0) {
                long begin = (long)segment->vmaddr + slide;
                long end = (long)(begin + segment->vmsize);
                segImageInfo *image = (segImageInfo *)malloc(sizeof(segImageInfo));
                image->loadAddr = (long)header;
                image->beginAddr = begin;
                image->endAddr = end;
                image->name = name;
                allImages.imageInfos[allImages.size++] = image;
                break;
            }
            offset += segment->cmdsize;
        }
    }
}

bool CStackHelper::isInAppAddress(vm_address_t addr){
    if(addr > allImages.imageInfos[0]->beginAddr && addr < allImages.imageInfos[0]->endAddr) return true;
    return false;
}

bool CStackHelper::getImageByAddr(vm_address_t addr,segImageInfo *image){
    for (size_t i = 0; i < allImages.size; i++)
    {
        if (addr > allImages.imageInfos[i]->beginAddr && addr < allImages.imageInfos[i]->endAddr) {
            image->name = allImages.imageInfos[i]->name;
            image->loadAddr = allImages.imageInfos[i]->loadAddr;
            image->beginAddr = allImages.imageInfos[i]->beginAddr;
            image->endAddr = allImages.imageInfos[i]->endAddr;
            return true;
        }
    }
    return false;
}

size_t CStackHelper::recordBacktrace(BOOL needSystemStack,size_t needAppStackCount,size_t backtrace_to_skip, vm_address_t **app_stack,unsigned char *md5,size_t max_stack_depth)
{
    CC_MD5_CTX mc;
    CC_MD5_Init(&mc);
    vm_address_t *orig_stack[max_stack_depth_sys];
    size_t depth = backtrace((void**)orig_stack, max_stack_depth_sys);
    size_t appstack_count = 0;
    size_t offset = 0;
    vm_address_t *last_stack = NULL;
    for(size_t i = backtrace_to_skip;i < depth;i++){
        if(appstack_count == 0){
            if(isInAppAddress((vm_address_t)orig_stack[i])){
                if(i < depth - 2) {
                    appstack_count++;
                }
                if(last_stack != NULL){
                    app_stack[offset++] = last_stack;
                }
                app_stack[offset++] = orig_stack[i];
            }
            else {
                if(needSystemStack){
                    app_stack[offset++] = orig_stack[i];
                }
                else {
                    last_stack = orig_stack[i];
                }
            }
            if(offset >= max_stack_depth) break;
        }
        else{
            if(isInAppAddress((vm_address_t)orig_stack[i]) || i == depth -1 || needSystemStack)
            {
                if(i != depth - 2) appstack_count++;
                app_stack[offset++] = orig_stack[i];
            }
            if(offset >= max_stack_depth) break;
        }
        CC_MD5_Update(&mc, &orig_stack[i], sizeof(void*));
    }
    CC_MD5_Final(md5, &mc);
    if(appstack_count >= needAppStackCount) return offset;
    return 0;
}
