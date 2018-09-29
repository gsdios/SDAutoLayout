//
//  HighSpeedLogger.h
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

#ifndef HighSpeedLogger_h
#define HighSpeedLogger_h

#import <Foundation/Foundation.h>
#import <malloc/malloc.h>

typedef void (*LogPrinter)(char *log);

class HighSpeedLogger
{
public:
    ~HighSpeedLogger();
    HighSpeedLogger(malloc_zone_t *zone, NSString *path, size_t mmap_size);
    BOOL sprintfLogger(size_t grain_size,const char *format, ...);
    void cleanLogger();
    void syncLogger();
    bool isValid();
    LogPrinter logPrinterCallBack;
public:
    char *mmap_ptr;
    size_t mmap_size;
    size_t current_len;
    malloc_zone_t *memory_zone;
    FILE *mmap_fp;
    bool isFailed;
};

#endif /* HighSpeedLogger_h */
