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

#define kSDModelCellTag 199206


@interface UITableViewCell (SDAutoHeight)

@property (nonatomic) CGFloat autoHeight;

@property (nonatomic) UIView *sd_bottomView;
@property (nonatomic) CGFloat sd_bottomViewBottomMargin;

- (void)setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin;

@end


@interface SDCellAutoHeightManager : NSObject

@property (nonatomic, assign) CGFloat contentViewWidth;

@property (nonatomic, assign) Class cellClass;

@property (nonatomic, assign) CGFloat cellHeight;

- (void)clearHeightCache;

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath;

- (instancetype)initWithCellClass:(Class)cellClass;
+ (instancetype)managerWithCellClass:(Class)cellClass;
@end

@interface UITableView (SDAutoTableViewCellHeight)

- (void)startAutoCellHeightWithCellClass:(Class)cellClass contentViewWidth:(CGFloat)contentViewWidth;
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath;
@property (nonatomic, strong) SDCellAutoHeightManager *cellAutoHeightManager;

@end

