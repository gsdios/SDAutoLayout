//
//  APMFileUploadCenter.m
//  lianxi
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
#import "QQLeakFileUploadCenter.h"
#import "QQLeakDeviceInfo.h"
#import <CommonCrypto/CommonDigest.h>
#import "QQLeakDeviceInfo.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

static QQLeakFileUploadCenter *center;

@implementation QQLeakFileUploadCenter

+(QQLeakFileUploadCenter *)defaultCenter{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        center = [[QQLeakFileUploadCenter alloc] init];
    });
    return center;
}

-(void)fileData:(NSData *)data extra:(NSDictionary<NSString*,NSString*> *)extra type:(QQStackReportType)type completionHandler:(void (^)(BOOL))completionHandler
{
    if(data){
        if (self.fileDataDelegate && [self.fileDataDelegate respondsToSelector:@selector(fileData:extra:type:completionHandler:)]) {
            [self.fileDataDelegate fileData:data extra:extra type:type completionHandler:completionHandler];
        }
    }
}

@end
