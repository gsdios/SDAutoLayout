//
//  CLeakChecker.h
//  libOOMDetector
//
//  Created by rosen on 2017/12/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <malloc/malloc.h>
#import <stdarg.h>
#import <mach/mach_init.h>
#import <libkern/OSAtomic.h>
#import <sys/mman.h>
#import <mach/vm_statistics.h>
#import <malloc/malloc.h>
#import "QQLeakPredefines.h"
#import "CommonMallocLogger.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>
#import <execinfo.h>
#import <mach/vm_map.h>
#import <mach/thread_act.h>
#import <mach/mach_port.h>
#import <mach/mach_init.h>
#import <pthread.h>
#import "CStackHelper.h"
#import "QQLeakMallocStackTracker.h"
#import "CMallocHook.h"
#import "CObjcFilter.h"
#import "CThreadTrackingHashmap.h"
#import "CHeapChecker.h"
#import "CLeakedHashmap.h"
#import "CStackHelper.h"
#import "OOMMemoryStackTracker.h"
#import "QQLeakFileUploadCenter.h"
#import "QQLeakDeviceInfo.h"
#import "AllocationTracker.h"

class CMemoryChecker;
@class QQLeakChecker;

class CLeakChecker
{
public:
    CLeakChecker();
    ~CLeakChecker();
    void initLeakChecker();
    //begin tracking malloc logging
    void beginLeakChecker();
    //clear tracking
    void clearLeakChecker();
    //called before leak checking
    void leakCheckingWillStart();
    //called after leak checking
    void leakCheckingWillFinish();
    //find ptr of address in memory
    bool findPtrInMemoryRegion(vm_address_t address);
    //marked the current thread need tracking the next malloc
    void markedThreadToTrackingNextMalloc(const char* name);
    //get the result of leak checking
    NSString* get_all_leak_stack(size_t *total_count);
    bool isThreadNeedTracking(const char **name);
    void recordMallocStack(vm_address_t address,uint32_t size,const char*name,size_t stack_num_to_skip);
    void removeMallocStack(vm_address_t address);
    bool isNeedTrackClass(Class cl);
    void lockSpinLock();
    void unlockSpinLock();
public:
    malloc_zone_t *getMemoryZone();
    CPtrsHashmap *getPtrHashmap();
    CStacksHashmap *getStackHashmap();
    void setMaxStackDepth(size_t depth);
    void setNeedSysStack(BOOL need);
    size_t getMaxStackDepth();
    BOOL isNeedSysStack();
public:
    bool enableStackTracking = false;
    bool isLeakChecking = false;
private:
    void get_all_leak_ptrs();
    void uploadLeakData(NSString *leakStr);
private:
    CLeakedHashmap *leaked_hashmap = NULL;
    CThreadTrackingHashmap *threadTracking_hashmap = NULL;
    CPtrsHashmap *qleak_ptrs_hashmap = NULL;
    CStacksHashmap *qleak_stacks_hashmap = NULL;
    CObjcFilter *objcFilter = NULL;
    malloc_zone_t *malloc_zone = NULL;
    CStackHelper *stackHelper = NULL;
    size_t max_stack_depth = 10;
    BOOL needSysStack = YES;
    OSSpinLock threadTracking_spinlock = OS_SPINLOCK_INIT;
    OSSpinLock hashmap_spinlock = OS_SPINLOCK_INIT;
};
