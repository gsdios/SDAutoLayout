//
//  OOMMemoryStackTracker.mm
//  QQMSFContact
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

#import "execinfo.h"
#import "CStackHelper.h"
#import "HighSpeedLogger.h"
#import "OOMDetector.h"
#import "QQLeakMallocStackTracker.h"
#import "OOMMemoryStackTracker.h"
#import "QQLeakFileUploadCenter.h"
#import "QQLeakDeviceInfo.h"
#import "CommonMallocLogger.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif


//extern
extern COOMDetector* global_oomdetector;

static const char *vm_flags[] = {
    "0","MALLOC","MALLOC_SMALL","MALLOC_LARGE","MALLOC_HUGE","SBRK",
    "REALLOC","TINY","ALLOC_LARGE_REUSABLE","MALLOC_LARGE_REUSED",
    "ANALYSIS_TOOL","MALLOC_NANO","12","13","14",
    "15","16","17","18","19",
    "MACH_MSG","IOKIT","22","23","24",
    "25","26","27","28","29",
    "STACK","GUARD","SHARED_PMAP","DYLIB","OBJC_DISPATCHERS",
    "UNSHARED_PMAP","36","37","38","39",
    "APPKIT","FOUNDATION","COREGRAPHICS","CARBON_OR_CORESERVICES_OR_MISC","JAVA",
    "COREDATA","COREDATA_OBJECTIDS","47","48","49",
    "ATS","LAYERKIT","CGIMAGE","TCMALLOC","COREGRAPHICS_DATA",
    "COREGRAPHICS_SHARED","COREGRAPHICS_FRAMEBUFFERS","COREGRAPHICS_BACKINGSTORES","COREGRAPHICS_XALLOC","59",
    "DYLD","DYLD_MALLOC","SQLITE","JAVASCRIPT_CORE","JAVASCRIPT_JIT_EXECUTABLE_ALLOCATOR",
    "JAVASCRIPT_JIT_REGISTER_FILE","GLSL","OPENCL","COREIMAGE","COREIMAGE",
    "IMAGEIO","COREPROFILE","ASSETSD","OS_ALLOC_ONCE","LIBDISPATCH",
    "ACCELERATE","COREUI","COREUIFILE","GENEALOGY","RAWCAMERA",
    "CORPSEINFO","ASL","SWIFT_RUNTIME","SWIFT_METADATA","DHMM",
    "85","SCENEKIT","SKYWALK","88","89"
};

void oom_malloc_logger(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t backtrace_to_skip)
{
    if (type & stack_logging_flag_zone) {
        type &= ~stack_logging_flag_zone;
    }
    if (type == (stack_logging_type_dealloc|stack_logging_type_alloc)) {
        if(global_oomdetector->enableChunkMonitor && arg3 > global_oomdetector->chunk_threshold){
            global_oomdetector->get_chunk_stack((size_t)arg3);
        }
        if (arg2 == result) {
            if(global_oomdetector->enableOOMMonitor){
                global_oomdetector->removeMallocStack((vm_address_t)arg2,OOMDetectorMode);
                global_oomdetector->recordMallocStack(result, (uint32_t)arg3,NULL,2);
            }
            return;
        }
        if (!arg2) {
            if(global_oomdetector->enableOOMMonitor){
                global_oomdetector->recordMallocStack(result, (uint32_t)arg3,NULL,2);
            }
            return;
        } else {
            if(global_oomdetector->enableOOMMonitor){
                global_oomdetector->removeMallocStack((vm_address_t)arg2,OOMDetectorMode);
                global_oomdetector->recordMallocStack(result, (uint32_t)arg3,NULL,2);
            }
            return;
        }
    }
    else if (type == stack_logging_type_dealloc) {
        if (!arg2) return;
        if(global_oomdetector->enableOOMMonitor){
            global_oomdetector->removeMallocStack((vm_address_t)arg2,OOMDetectorMode);
        }
    }
    else if((type & stack_logging_type_alloc) != 0){
        if(global_oomdetector->enableChunkMonitor && arg2 > global_oomdetector->chunk_threshold){
            global_oomdetector->get_chunk_stack((size_t)arg2);
        }
        if(global_oomdetector->enableOOMMonitor){
            global_oomdetector->recordMallocStack(result, (uint32_t)arg2,NULL,2);
        }
    }
}

void oom_vm_logger(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t backtrace_to_skip)
{
    if(type & stack_logging_type_vm_allocate){   //vm_mmap or vm_allocate
        type = (type & ~stack_logging_type_vm_allocate);
        type = type >> 24;
        if((type >= 1 && type <= 11) || type == 32 || arg2 == 0){
            return;
        }
        const char *flag = "unknown";
        if(type <= 89){
            flag = vm_flags[type];
        }
        global_oomdetector->recordVMStack(vm_address_t(result), uint32_t(arg2), flag, 2);
    }
    else if(type & stack_logging_type_vm_deallocate){  //vm_deallocate or munmap
        if((type >= 1 && type <= 11) || type == 32 || arg2 == 0){
            return;
        }
        global_oomdetector->removeVMStack(vm_address_t(arg2));
    }
}
