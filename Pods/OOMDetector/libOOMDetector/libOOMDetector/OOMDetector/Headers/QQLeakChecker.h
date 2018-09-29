//
//  QQLeakChecker.h
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
//  version:1.0


#import <Foundation/Foundation.h>

typedef void (^QQLeakCheckCallback)(NSString *leakData,size_t leak_num);

@interface QQLeakChecker : NSObject

+(QQLeakChecker *)getInstance;

/*! @brief 开始记录内存分配堆栈
 *
 */
-(void)startStackLogging;

/*! @brief 停止记录内存分配堆栈
 *
 */
-(void)stopStackLogging;

- (BOOL)isStackLogging;


/*! @brief 设置记录堆栈的最大长度
 *
 * @param depth 堆栈最大长度，建议不要将该值设置过高，否则会占用过多内存,默认为10
 */
-(void)setMaxStackDepth:(size_t)depth;

/*! @brief 设置在堆栈中是否需要显示系统函数，建议打开
 *
 * @param isNeedSys YES表示需要系统方法堆栈
 */
-(void)setNeedSystemStack:(BOOL)isNeedSys;

/*! @brief 执行一次泄露检测，建议在主线程调用，该操作会挂起所有子线程进行泄露检测（该操作较耗时，平均耗时在1s以上，请限制调用频率）
 *
 * @param callback 泄露检测完毕后的回调，leakData为泄露堆栈数据，leak_num为泄露个数
 */
-(void)executeLeakCheck:(QQLeakCheckCallback)callback;

/*! @brief 获取当前记录的对象个数
 *
 */
-(size_t)getRecordObjNumber;

/*! @brief 获取当前记录的内存分配堆栈个数
 *
 */
-(size_t)getRecordStackNumber;

@end
