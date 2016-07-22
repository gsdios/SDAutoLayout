//
//  UITableView+SDAutoTableViewCellHeight.h
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




/*
 PS:cell高度自适应前提>>应该调用cell的“- (void)setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin”方法进行cell的自动高度设置
 */

#import <UIKit/UIKit.h>

#import "UIView+SDAutoLayout.h"

@class SDCellAutoHeightManager;

typedef void (^AutoCellHeightDataSettingBlock)(UITableViewCell *cell);

#define kSDModelCellTag 199206



#pragma mark - UITableView 方法，返回自动计算出的cell高度

@interface UITableView (SDAutoTableViewCellHeight)

@property (nonatomic, strong) SDCellAutoHeightManager *cellAutoHeightManager;


/**
 * 返回计算出的cell高度（普通简化版方法，同样只需一步设置即可完成）(用法：单cell详见demo5，多cell详见demo7)
 * model              : cell的数据模型实例
 * keyPath            : cell的数据模型属性的属性名字符串（即kvc原理中的key）
 * cellClass          : 当前的indexPath对应的cell的class
 * contentViewWidth   : cell的contentView的宽度
 */
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass contentViewWidth:(CGFloat)contentViewWidth;

/**
 * 返回计算出的cell高度（普通简化版方法，同样只需一步设置即可完成）(用法：见DemoVC14)
 * cellClass          : 当前的indexPath对应的cell的class
 * contentViewWidth   : cell的contentView的宽度
 * cellDataSetting    : 设置cell数据的block
 */
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellClass:(Class)cellClass cellContentViewWidth:(CGFloat)width cellDataSetting:(AutoCellHeightDataSettingBlock)cellDataSetting;

/** 刷新tableView但不清空之前已经计算好的高度缓存，用于直接将新数据拼接在旧数据之后的tableView刷新 */
- (void)reloadDataWithExistedHeightCache;

/** 刷新tableView同时调整已经计算好的高度缓存，用于直接将新数据插在旧数据前面的tableView的刷新 */
- (void)reloadDataWithInsertingDataAtTheBeginingOfSection:(NSInteger)section newDataCount:(NSInteger)count;

/** 
 * 刷新tableView同时调整已经计算好的高度缓存，用于直接将新数据插在旧数据前面的tableView的刷新(用于刷新多个section)
 * sectionNumsArray : 要刷新的所有section序号组成的数组, 例@[@(0), @(1)]
 * dataCountsArray  : 每个section的数据条数组成的数组, 例@[@(20), @(10)]
 */
- (void)reloadDataWithInsertingDataAtTheBeginingOfSections:(NSArray *)sectionNumsArray newDataCounts:(NSArray *)dataCountsArray;

/** 返回所有cell的高度总和  */
- (CGFloat)cellsTotalHeight;

@property (nonatomic, copy) AutoCellHeightDataSettingBlock cellDataSetting;

@end




#pragma mark - UITableViewController 方法，返回自动计算出的cell高度

@interface UITableViewController (SDTableViewControllerAutoCellHeight)

/** (UITableViewController方法)升级版！一行代码（一步设置）搞定tableview的cell高度自适应,同时适用于单cell和多cell,性能比普通版稍微差一些,不建议在数据量大的tableview中使用  */
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width;

@end



#pragma mark - NSObject 方法，返回自动计算出的cell高度

@interface NSObject (SDAnyObjectAutoCellHeight)

/** (NSObject方法)升级版！一行代码（一步设置）搞定tableview的cell高度自适应,同时适用于单cell和多cell,性能比普通版稍微差一些,不建议在数据量大的tableview中使用  */
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width tableView:(UITableView *)tableView;

@end

















// ------------------------------- 以下为库内部使用无须了解 --------------------

@interface SDCellAutoHeightManager : NSObject

@property (nonatomic, assign) BOOL shouldKeepHeightCacheWhenReloadingData;

@property (nonatomic, assign) CGFloat contentViewWidth;

@property (nonatomic, assign) Class cellClass;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) UITableViewCell *modelCell;

@property (nonatomic, strong) NSMutableDictionary *subviewFrameCacheDict;

@property (nonatomic, strong, readonly) NSDictionary *heightCacheDict;

@property (nonatomic, copy) AutoCellHeightDataSettingBlock cellDataSetting;

- (void)clearHeightCache;

- (void)clearHeightCacheOfIndexPaths:(NSArray *)indexPaths;

- (void)deleteThenResetHeightCache:(NSIndexPath *)indexPathToDelete;

- (void)insertNewDataAtTheBeginingOfSection:(NSInteger)section newDataCount:(NSInteger)count;

- (NSNumber *)heightCacheForIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass;


- (NSMutableArray *)subviewFrameCachesWithIndexPath:(NSIndexPath *)indexPath;;
- (void)setSubviewFrameCache:(CGRect)rect WithIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithCellClass:(Class)cellClass tableView:(UITableView *)tableView;
+ (instancetype)managerWithCellClass:(Class)cellClass tableView:(UITableView *)tableView;
@end

