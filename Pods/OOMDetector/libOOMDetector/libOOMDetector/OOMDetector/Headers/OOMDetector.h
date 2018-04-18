//
//  OOMDetector.h
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
//  version:1.4
//  增加log回调，修复vmlogger为空时的crash
//  屏蔽私有API
//

#ifndef OOMDetector_h
#define OOMDetector_h

#import "OOMStatisticsInfoCenter.h"

#import <Foundation/Foundation.h>

#import "QQLeakDataUploadCenter.h"
#import "QQLeakFileUploadCenter.h"
#import "QQLeakChecker.h"

/*! @brief 单次堆内存分配超过限制后的回调
 *
 * @param bytes 分配的内存值（bytes）
 * @param stack 分配堆栈信息
 */
typedef void (*ChunkMallocCallback)(size_t bytes, NSString *stack);

/** 用于输出SDK内存调试log的回调 */
typedef void (*logCallback)(char *info);

typedef void (^LogPrintBlock)(NSString *log);
typedef void (^ChunkMallocBlock)(size_t bytes, NSString *stack);


@interface OOMDetector : NSObject

+(OOMDetector *)getInstance;

/** 初始化，6s以下机型内存触顶阈值默认设置为300M，6s及以上机型内存触顶阈值默认设置为800M。 */
- (void)setupWithDefaultConfig;

#pragma mark -- OOM监控

/*! @brief 开始app最大内存统计，你可以你通过setPerformanceDataDelegate:方法设置代理来获取app最大内存统计相关数据（前一次app运行时单次生命周期内的最大物理内存数据）
 *
 * @param overFlowLimit 为当前机型设置触定的阈值（Mb）
 */
-(void)startMaxMemoryStatistic:(double)overFlowLimit;

/** 在调用startMaxMemoryStatistic:开启内存触顶监控后会触发此回调，返回前一次app运行时单次生命周期内的最大物理内存数据 */
-(void)setPerformanceDataDelegate:(id<QQOOMPerformanceDataDelegate>)delegate;

#pragma mark -- 单次大内存分配监控

/*! @brief 开始单次超大堆内存分配监控，成功则返回YES
 1.阀值设置较大时，性能开销几乎影响不计，手Q在灰度和CI全量开启该开关，阀值设置为50M
 2.区别于startMallocStackMonitor:needAutoDumpWhenOverflow:dumpLimit:sampleInterval:方法,该方法只监控单次内存大于threshHoldInbytes的堆栈
 
 * @param threshholdInBytes 单次超大堆内存监控阈值（bytes）
 * @param callback 传入单次堆内存分配超过限制时的回调block
 *
 */
-(BOOL)startSingleChunkMallocDetector:(size_t)threshholdInBytes callback:(ChunkMallocBlock)callback;

/*! @brief 关闭单次超大堆内存分配监控
 *
 */
-(void)stopSingleChunkMallocDetector;

#pragma mark -- 代理设置

/** 在出现单次大块内存分配、检查到内存泄漏且时、调用uploadAllStack方法时触发此回调 */
-(void)setFileDataDelegate:(id<QQOOMFileDataDelegate>)delegate;

#pragma mark -- 内存泄漏监控

/** 开启内存泄漏监控。目前只可检测真机运行时的内存泄漏，模拟器暂不支持。 */
- (void)setupLeakChecker;

/*! @brief 执行一次泄露检测，建议在主线程调用，该操作会挂起所有子线程进行泄露检测（该操作较耗时，平均耗时在1s以上，请限制调用频率）
 *
 * @param callback 泄露检测完毕后的回调，leakData为泄露堆栈数据，leak_num为泄露个数
 */
-(void)executeLeakCheck:(QQLeakCheckCallback)callback;

/** 开启内存泄漏监控之后可通过此方法获取当前的LeakChecker */
- (QQLeakChecker *)currentLeakChecker;

#pragma mark -- 其它功能

/** 显示或者隐藏实时内存监控悬浮球。单击悬浮球可设置内存触顶阈值，长按悬浮球可调节悬浮球大小。 */
- (void)showMemoryIndicatorView:(BOOL)yn;

/** 监听实时内存回调block */
- (void)setStatisticsInfoBlock:(StatisticsInfoBlock)block;

/** 日志打印回调block */
@property (nonatomic, copy) LogPrintBlock logPrintBlock;

/*! @brief 开始堆内存堆栈监控，成功则返回YES
        1.有一定性能开销，建议增加控制策略选择性打开
        2.该功能开启后会实时记录所有的内存分配堆栈，并将多次重复调用的相同堆栈合并，如果合并后的size大于threshHoldInbytes，该分配堆栈将被输出到log用于分析，log路径Library/OOMDetector
 
 * @param threshholdInBytes 堆内存阈值（bytes）
 * @param needAutoDump 如果设置为YES，当app占用的内存超过dumpLimit时，自动执行dump堆栈操作
 * @param dumpLimit 只有needAutoDump设置为YES，app占用的内存超过dumpLimit（Mb）时，自动执行dump堆栈操作
 * @param sampleInterval 检测内存的间隔（单位s），一般情况下此值设为0.1即可
 */
-(BOOL)startMallocStackMonitor:(size_t)threshholdInBytes needAutoDumpWhenOverflow:(BOOL)needAutoDump dumpLimit:(double)dumpLimit sampleInterval:(NSTimeInterval)sampleInterval;

/*! @brief 关闭堆内存堆栈监控
 *
 */
-(void)stopMallocStackMonitor;

/*! @brief 开始VM内存堆栈监控，成功则返回YES(有一定性能开销，建议增加控制策略选择性打开）。
 *  因为startVMStackMonitor:方法用到了私有API __syscall_logger会带来app store审核不通过的风险，此方法默认只在DEBUG模式下生效，如果
 *  需要在RELEASE模式下也可用，请打开USE_VM_LOGGER_FORCEDLY宏，但是切记在提交appstore前将此宏关闭，否则可能会审核不通过
 *
 * @param threshHoldInbytes VM内存监控阈值（bytes），大于该阈值的堆栈将被输出到log（多次重复调用相同堆栈将被合并，并累加size）
 */

//#define USE_VM_LOGGER_FORCEDLY
-(BOOL)startVMStackMonitor:(size_t)threshHoldInbytes;

/*! @brief 关闭堆内存监控
 *
 */
-(void)stopVMStackMonitor;

/*! @brief 立即将内存中纪录的分配堆栈信息写入磁盘，当前log路径可通过currentStackLogDir获取
 * 说明:当需要立即纪录当前内存中的分配信息时候调用
 */
-(void)flush_allocation_stack;

/*! @brief 调用该接口上报所有缓存的OOM相关log给通过setFileDataDelegate:方法设置的代理，建议在启动的时候调用
 *  说明：dump数据存储在Library/OOMDetector目录中，上报成功后自动删除
 */
-(void)uploadAllStack;

/*! @brief 设置输出的log中的最大堆栈深度
 *
 */
-(void)setMaxStackDepth:(size_t)depth;

/*! @brief 设置在堆栈中是否需要显示系统函数，建议打开
 *
 * @param isNeedSys YES表示需要系统方法堆栈
 */
-(void)setNeedSystemStack:(BOOL)isNeedSys;

/*! @brief 设置是否需要纪录只有纯系统函数的堆栈，按需打开
 *
 * @param isNeedStackWithoutAppStack YES表示需要纪录只有纯系统函数的堆栈
 */
-(void)setNeedStacksWithoutAppStack:(BOOL)isNeedStackWithoutAppStack;

/*! @brief 当前log路径
 *
 */
-(NSString *)currentStackLogDir;

@property (nonatomic, copy) ChunkMallocBlock chunkMallocBlock;

@end

#endif /* OOMDetector_h */
