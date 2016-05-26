//
//  UITableView+SDAutoTableViewCellHeight.m
//  SDAutoLayout 测试 Demo
//
//  Created by aier on 15/11/1.
//  Copyright © 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * QQ    : 2689718696(gsdios)                                                      *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import "UITableView+SDAutoTableViewCellHeight.h"
#import <objc/runtime.h>

@interface SDCellAutoHeightManager ()

@property (nonatomic, weak) UITableView *modelTableview;

@end

@implementation SDCellAutoHeightManager
{
    NSMutableDictionary *_cacheDictionary;
    NSMutableDictionary *_modelCellsDict;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCellClass:(Class)cellClass tableView:(UITableView *)tableView
{
    if (self = [super init]) {
        [self setup];
        self.modelTableview = tableView;
        [self registerCellWithCellClass:cellClass];
    }
    return self;
}

- (instancetype)initWithCellClasses:(NSArray *)cellClassArray tableView:(UITableView *)tableView
{
    if (self = [super init]) {
        [self setup];
        self.modelTableview = tableView;
        [cellClassArray enumerateObjectsUsingBlock:^(Class obj, NSUInteger idx, BOOL *stop) {
            [self registerCellWithCellClass:obj];
        }];
    }
    return self;
}

- (void)setup
{
    _cacheDictionary = [NSMutableDictionary new];
    _modelCellsDict = [NSMutableDictionary new];
}

- (void)registerCellWithCellClass:(Class)cellClass
{
    [_modelTableview registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    self.modelCell = [_modelTableview dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    
    if (!self.modelCell.contentView.subviews.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.nib", NSStringFromClass(cellClass)] ofType:nil];
        if (path) {
            self.modelCell = nil;
            [_modelTableview registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
            self.modelCell = [_modelTableview dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
        }
    }
    if (self.modelCell) {
        [_modelCellsDict setObject:self.modelCell forKey:NSStringFromClass(cellClass)];
    }
}

+ (instancetype)managerWithCellClass:(Class)cellClass tableView:(UITableView *)tableView
{
    SDCellAutoHeightManager *manager = [[self alloc] initWithCellClass:cellClass tableView:tableView];
    return manager;
}

- (UITableViewCell *)modelCell
{
    if (_modelCell.contentView.tag != kSDModelCellTag) {
        _modelCell.contentView.tag = kSDModelCellTag;
    }
    return _modelCell;
}

- (NSDictionary *)heightCacheDict
{
    return _cacheDictionary;
}

- (void)clearHeightCache
{
    [_cacheDictionary removeAllObjects];
    [_subviewFrameCacheDict removeAllObjects];
}

- (void)clearHeightCacheOfIndexPaths:(NSArray *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSString *cacheKey = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
        [_cacheDictionary removeObjectForKey:cacheKey];
        [_subviewFrameCacheDict removeObjectForKey:cacheKey];
    }];
}

- (NSNumber *)heightCacheForIndexPath:(NSIndexPath *)indexPath
{
    /*
     如果程序卡在了这里很可能是由于你用了“dequeueReusableCellWithIdentifier:forIndexPath:”方法来重用cell，换成““dequeueReusableCellWithIdentifier:”（不带IndexPath）方法即可解决
     */
    NSString *cacheKey = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    return (NSNumber *)[_cacheDictionary objectForKey:cacheKey];
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath
{
    
    NSNumber *cacheHeight = [self heightCacheForIndexPath:indexPath];
    if (cacheHeight) {
        return [cacheHeight floatValue];
    } else {
        if (!self.modelCell) {
            return 0;
        }
        
        if (self.modelTableview && self.modelTableview != self.modelCell.sd_tableView) {
            self.modelCell.sd_tableView = self.modelTableview;
        }
        self.modelCell.sd_indexPath = indexPath;
        
        if (model && keyPath) {
            [self.modelCell setValue:model forKey:keyPath];
        }
        
        
#ifdef SDDebugWithAssert
        /*
         如果程序卡在了这里说明你的cell还没有调用“setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin”方法或者你传递的bottomView为nil，请检查并修改。例：
         
         //注意：bottomView不能为nil
         [cell setupAutoHeightWithBottomView:bottomView bottomMargin:bottomMargin];
         */
        NSAssert(self.modelCell.sd_bottomViewsArray.count, @">>>>>> 你的cell还没有调用“setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin”方法或者你传递的bottomView为nil，请检查并修改");
        
#endif
        
        [self.modelCell.contentView layoutSubviews];
        NSString *cacheKey = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
        [_cacheDictionary setObject:@(self.modelCell.autoHeight) forKey:cacheKey];
        
        
        if (self.modelCell.sd_indexPath && self.modelCell.sd_tableView) {
            if (self.modelCell.contentView.shouldReadjustFrameBeforeStoreCache) {
                self.modelCell.contentView.height_sd = self.modelCell.autoHeight;
                [self.modelCell.contentView layoutSubviews];
            }
            [self.modelCell.contentView.autoLayoutModelsArray enumerateObjectsUsingBlock:^(SDAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
                [self.modelTableview.cellAutoHeightManager setSubviewFrameCache:model.needsAutoResizeView.frame WithIndexPath:self.modelCell.sd_indexPath];
            }];
        }
        
        
        return self.modelCell.autoHeight;
    }
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass
{
    if (![self.modelCell isKindOfClass:cellClass]) {
        self.modelCell = nil;
        self.modelCell = [_modelCellsDict objectForKey:NSStringFromClass(cellClass)];
        if (!self.modelCell) {
            [self registerCellWithCellClass:cellClass];
        }
        _modelCell.contentView.tag = kSDModelCellTag;
    }
    if (self.modelCell.contentView.width_sd != self.contentViewWidth) {
        _modelCell.contentView.width_sd = self.contentViewWidth;
    }
    return [self cellHeightForIndexPath:indexPath model:model keyPath:keyPath];
}

- (void)setContentViewWidth:(CGFloat)contentViewWidth
{
    if (_contentViewWidth == contentViewWidth) return;
    
    _contentViewWidth = contentViewWidth;
    
    self.modelCell.contentView.width_sd = self.contentViewWidth;
    
    
    [_subviewFrameCacheDict removeAllObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self clearHeightCache];
        [self.modelTableview reloadData];
    });
}


- (void)setSubviewFrameCache:(CGRect)rect WithIndexPath:(NSIndexPath *)indexPath
{
    if (!self.subviewFrameCacheDict) {
        self.subviewFrameCacheDict = [NSMutableDictionary new];
    }
    NSString *cacheKey = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    NSMutableArray *caches = [self.subviewFrameCacheDict objectForKey:cacheKey];
    if (!caches) {
        caches = [NSMutableArray new];
        [self.subviewFrameCacheDict setValue:caches forKey:cacheKey];
    }
    [caches addObject:[NSValue valueWithCGRect:rect]];
}

- (NSMutableArray *)subviewFrameCachesWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    return [self.subviewFrameCacheDict valueForKey:cacheKey];
}

@end


@implementation UITableView (SDAutoTableViewCellHeight)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"reloadData", @"reloadRowsAtIndexPaths:withRowAnimation:"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *mySelString = [@"sd_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
            method_exchangeImplementations(originalMethod, myMethod);
        }];
    });
}

- (void)sd_reloadData
{
    if (!self.cellAutoHeightManager.shouldKeepHeightCacheWhenReloadingData) {
        [self.cellAutoHeightManager clearHeightCache];
    }
    [self sd_reloadData];
    self.cellAutoHeightManager.shouldKeepHeightCacheWhenReloadingData = NO;
}

- (void)sd_reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.cellAutoHeightManager clearHeightCacheOfIndexPaths:indexPaths];
    [self sd_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

/*
 * 下一步即将实现的功能
 
 - (void)sd_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
 {
 [self sd_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
 }
 
 - (void)sd_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
 {
 [self sd_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
 }
 
 - (void)sd_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
 {
 [self sd_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
 }
 
 */

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass contentViewWidth:(CGFloat)contentViewWidth
{
    if (!self.cellAutoHeightManager) {
        self.cellAutoHeightManager = [[SDCellAutoHeightManager alloc] init];
        self.cellAutoHeightManager.modelTableview = self;
    }
    
    self.cellAutoHeightManager.contentViewWidth = contentViewWidth;
    
    return [self.cellAutoHeightManager cellHeightForIndexPath:indexPath model:model keyPath:keyPath cellClass:cellClass];
}

- (void)reloadDataWithExistedHeightCache
{
    self.cellAutoHeightManager.shouldKeepHeightCacheWhenReloadingData = YES;
    [self reloadData];
}

- (CGFloat)cellsTotalHeight
{
    CGFloat h = 0;
    if (!self.cellAutoHeightManager.heightCacheDict.count) {
        [self reloadData];
    }
    NSArray *values = [self.cellAutoHeightManager.heightCacheDict allValues];
    for (NSNumber *number in values) {
        h += [number floatValue];
    }
    return h;
}

- (SDCellAutoHeightManager *)cellAutoHeightManager
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCellAutoHeightManager:(SDCellAutoHeightManager *)cellAutoHeightManager
{
    objc_setAssociatedObject(self, @selector(cellAutoHeightManager), cellAutoHeightManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UITableViewController (SDTableViewControllerAutoCellHeight)

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:width tableView:self.tableView];
}

@end

@implementation NSObject (SDAnyObjectAutoCellHeight)

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width tableView:(UITableView *)tableView
{
    if (!tableView.cellAutoHeightManager) {
        tableView.cellAutoHeightManager = [[SDCellAutoHeightManager alloc] init];
        tableView.cellAutoHeightManager.modelTableview = tableView;
    }
    if (tableView.cellAutoHeightManager.contentViewWidth != width) {
        tableView.cellAutoHeightManager.contentViewWidth = width;
    }
    if ([tableView.cellAutoHeightManager heightCacheForIndexPath:indexPath]) {
        return [[tableView.cellAutoHeightManager heightCacheForIndexPath:indexPath] floatValue];
    }
    UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    tableView.cellAutoHeightManager.modelCell = cell;
    if (cell.contentView.width_sd != width) {
        cell.contentView.width_sd = width;
    }
    return [[tableView cellAutoHeightManager] cellHeightForIndexPath:indexPath model:nil keyPath:nil];
}

@end

