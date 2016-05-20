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
 
 cell高度自适应有“普通版”和“升级版”两个版本：
 
 1.普通版：两行代码（两步设置）搞定tableview的cell高度自适应(单cell详见demo5，多cell详见demo7)
 
 2.升级版：只需一步设置即可实现，见下方category“UITableViewController (SDTableViewControllerAutoCellHeight)”)
 
 PS:cell高度自适应前提>>应该调用cell的“- (void)setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin”方法进行cell的自动高度设置
 */

#import <UIKit/UIKit.h>

#import "UIView+SDAutoLayout.h"

@class SDCellAutoHeightManager;

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

/** 刷新tableView但不清空之前已经计算好的高度缓存，用于直接将新数据拼接在旧数据之后的tableView刷新 */
- (void)reloadDataWithExistedHeightCache;

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

- (void)clearHeightCache;

- (void)clearHeightCacheOfIndexPaths:(NSArray *)indexPaths;

- (NSNumber *)heightCacheForIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass;


- (NSMutableArray *)subviewFrameCachesWithIndexPath:(NSIndexPath *)indexPath;;
- (void)setSubviewFrameCache:(CGRect)rect WithIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithCellClass:(Class)cellClass tableView:(UITableView *)tableView;
+ (instancetype)managerWithCellClass:(Class)cellClass tableView:(UITableView *)tableView;
@end

