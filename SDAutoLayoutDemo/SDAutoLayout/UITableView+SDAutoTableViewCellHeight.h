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

@class SDCellAutoHeightManager;

#define kSDModelCellTag 199206


/*  普通版！两行代码（两步设置）搞定tableview的cell高度自适应(单cell详见demo5，多cell详见demo7)  */

@interface UITableView (SDAutoTableViewCellHeight)

@property (nonatomic, strong) SDCellAutoHeightManager *cellAutoHeightManager;


// ☆☆☆☆☆☆☆☆☆☆☆【推荐使用方法（性能高+易用性好），详见demo7和demo9】☆☆☆☆☆☆☆☆☆☆☆

/** 
  * 返回计算出的cell高度（普通简化版方法，同样只需一步设置即可完成）
  * model              : cell的数据模型实例
  * keyPath            : cell的数据模型属性的属性名字符串（即kvc原理中的key）
  * cellClass          : 当前的indexPath对应的cell的class
  * contentViewWidth   : cell的contentView的宽度
 */
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass contentViewWidth:(CGFloat)contentViewWidth;


// ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆




// >>>>>>>>>>>>>> 单个cell情景下调用以下方法 >>>>>>>>>>>>>>

/** (不再推荐使用此方法！)开启高度自适应，建议在tableview的数据源方法“- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section”中调用此方法*/
- (void)startAutoCellHeightWithCellClass:(Class)cellClass contentViewWidth:(CGFloat)contentViewWidth NS_DEPRECATED(10_0, 10_4, 6_0, 6_0);

/** (不再推荐使用此方法！)返回计算出的cell高度;model为cell的数据模型实例;keyPath为cell的数据模型属性的属性名字符串（即kvc原理中的key）*/
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath NS_DEPRECATED(10_0, 10_4, 6_0, 6_0);



// >>>>>>>>>>>>>> 多cell情景下调用以下方法(详细用法见demo7) >>>>>>>>>>>>>>>>>

/** (不再推荐使用此方法！)cellClassArray 为所有cell的类组成的数组，详细用法见demo7 */
- (void)startAutoCellHeightWithCellClasses:(NSArray *)cellClassArray contentViewWidth:(CGFloat)contentViewWidth NS_DEPRECATED(10_0, 10_4, 6_0, 6_0);

/** (不再推荐使用此方法！)返回计算出的cell高度;model为cell的数据模型实例;keyPath为cell的数据模型属性的属性名字符串（即kvc原理中的key） */
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass NS_DEPRECATED(10_0, 10_4, 6_0, 6_0);

@end





/* 升级版！一行代码（一步设置）搞定tableview的cell高度自适应,同时适用于单cell和多cell（详见demo8） */

@interface UITableViewController (SDTableViewControllerAutoCellHeight)

/** (UITableViewController方法)升级版！一行代码（一步设置）搞定tableview的cell高度自适应,同时适用于单cell和多cell,性能比普通版稍微差一些,不建议在数据量大的tableview中使用  */
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width;

@end



@interface NSObject (SDAnyObjectAutoCellHeight)

/** (NSObject方法)升级版！一行代码（一步设置）搞定tableview的cell高度自适应,同时适用于单cell和多cell,性能比普通版稍微差一些,不建议在数据量大的tableview中使用  */
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width tableView:(UITableView *)tableView;

@end

















// ------------------------------- 以下为库内部使用无须了解 --------------------

@interface SDCellAutoHeightManager : NSObject

@property (nonatomic, assign) CGFloat contentViewWidth;

@property (nonatomic, assign) Class cellClass;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) UITableViewCell *modelCell;

- (void)clearHeightCache;

- (void)clearHeightCacheOfIndexPaths:(NSArray *)indexPaths;

- (NSNumber *)heightCacheForIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass;

- (instancetype)initWithCellClass:(Class)cellClass;
+ (instancetype)managerWithCellClass:(Class)cellClass;
@end

