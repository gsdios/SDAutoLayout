//
//  QQLeakDataUploadCenter.h
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

#import <Foundation/Foundation.h>

@protocol QQOOMPerformanceDataDelegate <NSObject>

/*! @brief 在调用startMaxMemoryStatistic:开启内存触顶监控后会触发此回调，返回前一次app运行时单次生命周期内的最大物理内存数据
 *  @param data 性能数据
 */
-(void)performanceData:(NSDictionary *)data completionHandler:(void (^)(BOOL))completionHandler;

@end

@interface QQLeakDataUploadCenter : NSObject

+(QQLeakDataUploadCenter *)defaultCenter;

@property (nonatomic, weak) id<QQOOMPerformanceDataDelegate> performanceDataDelegate;

/*! @brief 在调用startMaxMemoryStatistic:开启内存触顶监控后会触发此回调，返回前一次app运行时单次生命周期内的最大物理内存数据
 *  @param data 性能数据
 */
-(void)performanceData:(NSDictionary *)data completionHandler:(void (^)(BOOL))completionHandler;

@end
