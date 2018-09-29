//
//  OOMDetectorLogger.h
//  OOMDetector
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

#ifndef OOMDetectorLogger_h
#define OOMDetectorLogger_h

#import <Foundation/Foundation.h>
#import "OOMDetector.h"

extern logCallback oom_logger;

#define OOM_Log(format, ...) \
do{ \
    char *str = NULL; \
    char *formatStr = NULL; \
    if(oom_logger != NULL){ \
        int ret = asprintf(&str, format, ##__VA_ARGS__);\
        if(ret > 0){ \
            asprintf(&formatStr,"[OOMDetector Log] %s",str); \
            oom_logger(formatStr); \
            free(formatStr); \
            free(str);\
        }\
    }\
}while(0)


#endif /* ScrollPerformanceLogger_h */
