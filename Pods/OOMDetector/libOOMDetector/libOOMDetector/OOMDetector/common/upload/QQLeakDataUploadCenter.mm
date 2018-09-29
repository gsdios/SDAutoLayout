//
//  QQLeakDataUploadCenter.m
//
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

#import "QQLeakDataUploadCenter.h"
#import "QQLeakDeviceInfo.h"

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

static QQLeakDataUploadCenter *center;

@implementation QQLeakDataUploadCenter

+(QQLeakDataUploadCenter *)defaultCenter{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        center = [[QQLeakDataUploadCenter alloc] init];
    });
    return center;
}

-(void)performanceData:(NSDictionary *)data completionHandler:(void (^)(BOOL))completionHandler
{
    if ([self.performanceDataDelegate respondsToSelector:@selector(performanceData:completionHandler:)]) {
        [self.performanceDataDelegate performanceData:data completionHandler:completionHandler];
    }
}


@end

