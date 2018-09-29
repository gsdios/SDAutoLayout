//
//  CSegmentChecker.mm
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

#import "CSegmentChecker.h"
#import <mach-o/dyld.h>
#import <mach/mach.h>

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

void CSegmentChecker::initAllSegments()
{
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const mach_header_t* header = (const mach_header_t*)_dyld_get_image_header(i);
        const char* image_name = _dyld_get_image_name(i);
        const char* tmp = strrchr(image_name, '/');
        vm_address_t slide = _dyld_get_image_vmaddr_slide(i);
        if (tmp) {
            image_name = tmp + 1;
        }
        long offset = (long)header + sizeof(mach_header_t);
        for (unsigned int i = 0; i < header->ncmds; i++)
        {
            const segment_command_t* segment = (const segment_command_t*)offset;
            if (segment->cmd == MY_SEGMENT_CMD_TYPE && strncmp(segment->segname,"__DATA",6) == 0) {
                section_t *section = (section_t *)((char*)segment + sizeof(segment_command_t));
                for(uint32_t j = 0; j < segment->nsects;j++){
                    if((strncmp(section->sectname,"__data",6) == 0) || (strncmp(section->sectname,"__common",8) == 0) || (strncmp(section->sectname,"__bss",5) == 0)){
                        vm_address_t begin = (vm_address_t)section->addr + slide;
                        vm_size_t size = (vm_size_t)section->size;
                        dataSegment seg = {image_name,section->sectname,begin,size};
                        segments.push_back(seg);
                    }
                    section = (section_t *)((char *)section + sizeof(section_t));
                }
            }
            offset += segment->cmdsize;
        }
    }
}

void CSegmentChecker::removeAllSegments(){
    segments.clear();
}

void CSegmentChecker::startPtrcheck()
{
    for(auto it = segments.begin();it != segments.end();it++){
        dataSegment seg = *it;
        vm_range_t range = {seg.beginAddr,seg.size};
        check_ptr_in_vmrange(range,SEGMENT_TYPE);
    }
}
