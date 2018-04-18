
## 简介
OOMDetector是一个iOS内存监控组件，应用此组件可以帮助你轻松实现OOM监控、大内存分配监控、内存泄漏检测等功能。

#### 技术交流QQ群：565644607

## 特性

- 1.OOM监控：监控OOM，Dump引起爆内存的堆栈
- 2.大内存分配监控：监控单次大块内存分配，提供分配堆栈信息
- 3.内存泄漏检测：可检测OC对象、Malloc堆内存泄漏，提供泄漏堆栈信息

## 演示
![demo_gif](assets/oomgif.gif)

## 使用方法
### 初始化
// 初始化，6s以下机型内存触顶阈值默认设置为300M，6s及以上机型内存触顶阈值默认设置为800M。

\- (void)setupWithDefaultConfig;
### OOM监控
// 开启OOM监控，默认在setupWithDefaultConfig方法中已经开启  

\-(void)startMaxMemoryStatistic:(double)overFlowLimit;
### 大内存分配监控
// 开启单次大内存分配监控

\-(BOOL)startSingleChunkMallocDetector:(size_t)threshholdInBytes callback:(ChunkMallocBlock)callback;
### 内存泄漏检测

// 初始化内存泄漏监控器，记录所有堆对象

\- (void)setupLeakChecker;
    
// 执行一次泄露检测，建议在主线程调用，该操作会挂起所有子线程进行泄露检测（该操作较耗时，平均耗时在1s以上，请限制调用频率）

\-(void)executeLeakCheck:(QQLeakCheckCallback)callback;
    
### 其它功能

// 开启堆内存堆栈监控，开启后会实时记录所有的内存分配堆栈，并将多次重复调用的相同堆栈合并，如果合并后的size大于threshHoldInbytes，该分配堆栈将被输出到log用于分析，log路径Library/OOMDetector

\-(BOOL)startMallocStackMonitor:(size_t)threshholdInBytes needAutoDumpWhenOverflow:(BOOL)needAutoDump dumpLimit:(double)dumpLimit sampleInterval:(NSTimeInterval)sampleInterval;
    
// 开启VMStackMonitor用以监控非直接通过malloc方式分配的内存因为startVMStackMonitor:方法用到了私有API __syscall_logger会带来app store审核不通过的风险，此方法默认只在DEBUG模式下生效，如果需要在RELEASE模式下也可用，请打开USE_VM_LOGGER_FORCEDLY宏，但是切记在提交appstore前将此宏关闭，否则可能会审核不通过

\-(BOOL)startVMStackMonitor:(size_t)threshHoldInbytes;
    
### 设置代理

@protocol QQOOMPerformanceDataDelegate <NSObject>
// 在调用startMaxMemoryStatistic:开启内存触顶监控后会触发此回调，返回前一次app运行时单次生命周期内的最大物理内存数据
    
\-(void)performanceData:(NSDictionary *)data completionHandler:(void (^)(BOOL))completionHandler;
@end
    
@protocol QQOOMFileDataDelegate <NSObject>
// 在出现单次大块内存分配、检查到内存泄漏且时、调用uploadAllStack方法时触发此回调
    
\-(void)fileData:(NSData *)data extra:(NSDictionary<NSString *,NSString *> *)extra type:(QQStackReportType)type completionHandler:(void (^)(BOOL))completionHandler;
@end

## PS
如果你遇到类似"Undefined symbols for architecture arm64:
  "std::__1::__next_prime(unsigned long)""的链接问题, 你可以做如下设置:
  
Build Settings -> Linking -> Other Linker Flags -> -lc++

## 变更记录
暂无
## 帮助
暂无
## 许可证
OOMDetector适用MIT协议，详见[LICENSE](/LICENSE)。



****

## Introduction

OOMDetector is a memory monitoring component for iOS which provides you with OOM monitoring, memory allocation monitoring, memory leak detection and other functions.

## Features
- OOM Monitoring  : Monitoring OOM then dump stacks which cause OOM problems.
- Large Memory Allocation Monitoring  : Monitoring large memory allocation then provides memory allocation stacks for you.
- Memory Leak Detecting  : Detecting memory leak for both OC objects and c heap memory then provides memory allocation stacks for you.


## Demo
![demo_gif](assets/oomgif.gif)

## Usage
### Initialization
// 初始化，6s以下机型内存触顶阈值默认设置为300M，6s及以上机型内存触顶阈值默认设置为800M。

\- (void)setupWithDefaultConfig;
### OOM Monitoring
// 开启OOM监控，默认在setupWithDefaultConfig方法中已经开启

\-(void)startMaxMemoryStatistic:(double)overFlowLimit;
### Large Memory Allocation Monitoring
// 开启单次大内存分配监控

\-(BOOL)startSingleChunkMallocDetector:(size_t)threshholdInBytes callback:(ChunkMallocBlock)callback;
### Memory Leak Detecting

// 初始化内存泄漏监控器，记录所有堆对象

\- (void)setupLeakChecker;
    
// 执行一次泄露检测，建议在主线程调用，该操作会挂起所有子线程进行泄露检测（该操作较耗时，平均耗时在1s以上，请限制调用频率）

\-(void)executeLeakCheck:(QQLeakCheckCallback)callback;

### Other Functions

// 开启堆内存堆栈监控，开启后会实时记录所有的内存分配堆栈，并将多次重复调用的相同堆栈合并，如果合并后的size大于threshHoldInbytes，该分配堆栈将被输出到log用于分析，log路径Library/OOMDetector

\-(BOOL)startMallocStackMonitor:(size_t)threshholdInBytes needAutoDumpWhenOverflow:(BOOL)needAutoDump dumpLimit:(double)dumpLimit sampleInterval:(NSTimeInterval)sampleInterval;
    
// 开启VMStackMonitor用以监控非直接通过malloc方式分配的内存因为startVMStackMonitor:方法用到了私有API __syscall_logger会带来app store审核不通过的风险，此方法默认只在DEBUG模式下生效，如果需要在RELEASE模式下也可用，请打开USE_VM_LOGGER_FORCEDLY宏，但是切记在提交appstore前将此宏关闭，否则可能会审核不通过

\-(BOOL)startVMStackMonitor:(size_t)threshHoldInbytes;
    
### Delegate

@protocol QQOOMPerformanceDataDelegate <NSObject>
// 在调用startMaxMemoryStatistic:开启内存触顶监控后会触发此回调，返回前一次app运行时单次生命周期内的最大物理内存数据
    
\-(void)performanceData:(NSDictionary *)data completionHandler:(void (^)(BOOL))completionHandler;
@end
    
@protocol QQOOMFileDataDelegate <NSObject>
// 在出现单次大块内存分配、检查到内存泄漏且时、调用uploadAllStack方法时触发此回调
    
\-(void)fileData:(NSData *)data extra:(NSDictionary<NSString *,NSString *> *)extra type:(QQStackReportType)type completionHandler:(void (^)(BOOL))completionHandler;
@end

## PS
If you come across link errors like "Undefined symbols for architecture arm64:
  "std::__1::__next_prime(unsigned long)"", do as follows:
  
Build Settings -> Linking -> Other Linker Flags -> -lc++


## Changes Log

## Help

## License
OOMDetector is under the MIT license. See the [LICENSE](/LICENSE) file for details.
