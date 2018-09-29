//
//  COOMDetector.h
//  libOOMDetector
//
//  Created by rosen on 2017/12/26.
//

#import <Foundation/Foundation.h>
#import <libkern/OSAtomic.h>
#import <sys/mman.h>
#import <mach/mach_init.h>
#import <mach/vm_statistics.h>
#import "zlib.h"
#import "stdio.h"
#import "OOMMemoryStackTracker.h"
#import "QQLeakPredefines.h"
#import "HighSpeedLogger.h"
#import "CStackHelper.h"
#import "OOMDetector.h"
#import "CStacksHashmap.h"
#import "QQLeakMallocStackTracker.h"
#import "OOMDetectorLogger.h"
#import "QQLeakFileUploadCenter.h"
#import "QQLeakDeviceInfo.h"
#import "CStackHelper.h"
#import "CommonMallocLogger.h"

class COOMDetector
{
public:
    COOMDetector();
    ~COOMDetector();
    void recordVMStack(vm_address_t address,uint32_t size,const char*type,size_t stack_num_to_skip);
    void removeVMStack(vm_address_t address);
    void recordMallocStack(vm_address_t address,uint32_t size,const char*name,size_t stack_num_to_skip);
    void removeMallocStack(vm_address_t address,monitor_mode mode);
    void flush_allocation_stack();
    void initLogger(malloc_zone_t *zone, NSString *path, size_t mmap_size,LogPrinter printer);
    BOOL startMallocStackMonitor(size_t threshholdInBytes);
    void stopMallocStackMonitor();
    BOOL startVMStackMonitor(size_t threshholdInBytes);
    void stopVMStackMonitor();
    void startSingleChunkMallocDetector(size_t threshholdInBytes,ChunkMallocBlock mallocBlock);
    void stopSingleChunkMallocDetector();
    void get_chunk_stack(size_t size);
    void lockMallocSpinLock();
    void unlockMallocSpinLock();
    void lockVMSpinLock();
    void unlockVMSpinLock();
public:
    malloc_zone_t *getMemoryZone();
    CPtrsHashmap *getPtrHashmap();
    CStacksHashmap *getStackHashmap();
    HighSpeedLogger *getStackLogger();
public:
    size_t max_stack_depth;
    BOOL needSysStack = YES;
    BOOL enableOOMMonitor = NO;
    BOOL enableChunkMonitor = NO;
    BOOL enableVMMonitor = NO;
    BOOL needStackWithoutAppStack = NO;
    size_t oom_threshold;
    size_t chunk_threshold;
    size_t vm_threshold;
public:
    malloc_logger_t** vm_sys_logger = NULL;
private:
    NSString* chunkDataZipPath();
private:
    CPtrsHashmap *vm_ptrs_hashmap;
    CStacksHashmap *vm_stacks_hashmap;
    CPtrsHashmap *oom_ptrs_hashmap;
    CStacksHashmap *oom_stacks_hashmap;
    HighSpeedLogger *normal_stack_logger = NULL;
    ChunkMallocBlock chunkMallocCallback = NULL;
    CStackHelper *stackHelper = NULL;
    OSSpinLock hashmap_spinlock = OS_SPINLOCK_INIT;
    OSSpinLock vm_hashmap_spinlock = OS_SPINLOCK_INIT;
};
