//
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


typedef enum : NSUInteger {
    QQStackReportTypeChunkMemory,   // 单次大块内存分配
    QQStackReportTypeLeak,          // 内存泄漏
    QQStackReportTypeOOMLog,        // OOM日志
} QQStackReportType;

@protocol QQOOMFileDataDelegate <NSObject>

/** 在出现单次大块内存分配、检查到内存泄漏且时、调用uploadAllStack方法时触发回调 */
-(void)fileData:(NSData *)data extra:(NSDictionary<NSString*,NSString*> *)extra type:(QQStackReportType)type completionHandler:(void (^)(BOOL))completionHandler;

@end

@interface QQLeakFileUploadCenter : NSObject

+(QQLeakFileUploadCenter *)defaultCenter;

@property (nonatomic, assign) id<QQOOMFileDataDelegate> fileDataDelegate;

-(void)fileData:(NSData *)data extra:(NSDictionary<NSString*,NSString*> *)extra type:(QQStackReportType)type completionHandler:(void(^)(BOOL completed))completionHandler;

@end
