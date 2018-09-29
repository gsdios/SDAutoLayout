
//
//  QQLeakPredefines.h
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

#import <Foundation/Foundation.h>

#ifndef QQLeakPredefines_h
#define QQLeakPredefines_h


#ifdef __LP64__
typedef struct mach_header_64 mach_header_t;
typedef struct segment_command_64 segment_command_t;
typedef struct section_64 section_t;
#else
typedef struct mach_header mach_header_t;
typedef struct segment_command segment_command_t;
typedef struct section section_t;
#endif

#if defined(__i386__)

#define MY_THREAD_STATE_COUTE x86_THREAD_STATE32_COUNT
#define MY_THREAD_STATE x86_THREAD_STATE32
#define MY_EXCEPTION_STATE_COUNT x86_EXCEPTION_STATE64_COUNT
#define MY_EXCEPITON_STATE ARM_EXCEPTION_STATE32
#define MY_SEGMENT_CMD_TYPE LC_SEGMENT

#elif defined(__x86_64__)

#define MY_THREAD_STATE_COUTE x86_THREAD_STATE64_COUNT
#define MY_THREAD_STATE x86_THREAD_STATE64
#define MY_EXCEPTION_STATE_COUNT x86_EXCEPTION_STATE64_COUNT
#define MY_EXCEPITON_STATE x86_EXCEPTION_STATE64
#define MY_SEGMENT_CMD_TYPE LC_SEGMENT_64

#elif defined(__arm64__)

#define MY_THREAD_STATE_COUTE ARM_THREAD_STATE64_COUNT
#define MY_THREAD_STATE ARM_THREAD_STATE64
#define MY_EXCEPTION_STATE_COUNT ARM_EXCEPTION_STATE64_COUNT
#define MY_EXCEPITON_STATE ARM_EXCEPTION_STATE64
#define MY_SEGMENT_CMD_TYPE LC_SEGMENT_64

#elif defined(__arm__)

#define MY_THREAD_STATE_COUTE ARM_THREAD_STATE_COUNT
#define MY_THREAD_STATE ARM_THREAD_STATE
#define MY_EXCEPITON_STATE ARM_EXCEPTION_STATE
#define MY_EXCEPTION_STATE_COUNT ARM_EXCEPTION_STATE_COUNT
#define MY_SEGMENT_CMD_TYPE LC_SEGMENT

#else
#error Unsupported host cpu.
#endif

#define stack_logging_type_alloc	2	/* malloc, realloc, etc... */
#define stack_logging_type_dealloc	4	/* free, realloc, etc... */
#define stack_logging_type_vm_allocate  16      /* vm_allocate or mmap */
#define stack_logging_type_vm_deallocate  32	/* vm_deallocate or munmap */
#define	stack_logging_flag_zone		8	/* NSZoneMalloc, etc... */
#define stack_logging_flag_cleared	64	/* for NewEmptyHandle */
#define stack_logging_type_mapped_file_or_shared_mem 128

#define max_stack_depth_sys 100

#endif /* QQLeakpredefines_h */
