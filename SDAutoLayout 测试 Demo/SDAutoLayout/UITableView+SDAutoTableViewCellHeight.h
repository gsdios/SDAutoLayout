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

#import <UIKit/UIKit.h>

@class SDCellAutoHeightManager;

#define kSDModelCellTag 199206

@interface UITableView (SDAutoTableViewCellHeight)

// ------------------ 单个cell情景下调用以下方法 ------------------

/*
 *  开启高度自适应，建议在tableview的数据源方法“- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section”中调用此方法，详细用法见demo5
 */
- (void)startAutoCellHeightWithCellClass:(Class)cellClass contentViewWidth:(CGFloat)contentViewWidth;

/*
 *  返回计算出的cell高度
 *  model:cell的数据模型实例
 *  keyPath:cell的数据模型属性的属性名字符串（即kvc原理中的key）
 */
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath;



// ------------------ 多cell情景下调用以下方法 ------------------

/*
 * cellClassArray 为所有cell的类组成的数组，详细用法见demo7
 */
- (void)startAutoCellHeightWithCellClasses:(NSArray<Class> *)cellClassArray contentViewWidth:(CGFloat)contentViewWidth;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass;

@property (nonatomic, strong) SDCellAutoHeightManager *cellAutoHeightManager;

@end































// ------------------------------- 以下为库内部使用无须了解 --------------------

@interface SDCellAutoHeightManager : NSObject

@property (nonatomic, assign) CGFloat contentViewWidth;

@property (nonatomic, assign) Class cellClass;

@property (nonatomic, assign) CGFloat cellHeight;

- (void)clearHeightCache;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass;

- (instancetype)initWithCellClass:(Class)cellClass;
+ (instancetype)managerWithCellClass:(Class)cellClass;
@end

