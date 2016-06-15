//
//  ThreeBaseCell.h
//  SDAutoLayoutDemo
//
//  Created by lixiya on 16/1/14.
//  Copyright © 2016年 lixiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "ThreeModel.h"
#import "LEETheme.h"

#define DAY @"day"

#define NIGHT @"night"

@interface ThreeBaseCell : UITableViewCell<SDCycleScrollViewDelegate>

/**
 *  图片
 */
@property (strong, nonatomic) UIImageView *imgIcon;


/**
 *  标题
 */
@property (strong, nonatomic) UILabel *lblTitle;


/**
 *  描述
 */
@property (strong, nonatomic) UILabel *lblSubtitle;

/**
 *  第二张图片（如果有的话）
 */
@property (strong, nonatomic) UIImageView *imgOther1;


/**
 *  第三张图片（如果有的话）
 */
@property (strong, nonatomic) UIImageView *imgOther2;

/**
 *  底部分界线
 */
@property (strong, nonatomic) UIView *lineView;

/**
 *  滚动图片区
 */
@property(nonatomic ,strong) SDCycleScrollView * cycleScrollView;

// 数据模型
@property(nonatomic ,strong) ThreeModel * threeModel;

+(NSString *)cellIdentifierForRow:(ThreeModel *)threeModel;

@end
