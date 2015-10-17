//
//  UIView+SDAutoLayout.h
//
//  Created by gsd on 15/10/6.
//  Copyright (c) 2015年 gsd. All rights reserved.
//

/*
*************************************************************************

                    --------- INTRODUCTION ---------
 
 
                                ********
                                *      *
                                *  v1  *
                                ********
                                    |
 
                              topSpaceToView
 
                                    |
 ********                       ********                        ********
 *      *                       *      *                        *      *
 *  v0  * —— leftSpaceToView —— * Demo *  —— rightSpaceToView ——*  v2  *
 ********                       ********                        ********
                                    |
 
                            bottomSpaceToView
 
                                    |
                                ********
                                *      *
                                *  v3  *
                                ********
 
 HOW TO USE ?
 
 
MODE 1. >>>>>>>>>>>>>>> You can use it in this way:
 
    Demo.sd_layout
    .topSpaceToView(v1, 100)
    .bottomSpaceToView(v3, 100)
    .leftSpaceToView(v0, 150)
    .rightSpaceToView(v2, 150);
 
 

MODE 2. >>>>>>>>>>>>>>> You can also use it in this way that is more brevity:
 
    Demo.sd_layout.topSpaceToView(v1, 100).bottomSpaceToView(v3, 100).leftSpaceToView(v0, 150).rightSpaceToView(v2, 150);
 
 
 

*************************************************************************
*/


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
 * 如果您需要布局错误LOG信息提示请打开此宏
 */

//#define SDAutoLayoutIssueLog

#import <UIKit/UIKit.h>

@class SDAutoLayoutModel;

typedef SDAutoLayoutModel *(^MarginToView)(UIView *toView, CGFloat value);
typedef SDAutoLayoutModel *(^Margin)(CGFloat value);
typedef SDAutoLayoutModel *(^MarginEqualToView)(UIView *toView);
typedef SDAutoLayoutModel *(^WidthHeight)(CGFloat value);
typedef SDAutoLayoutModel *(^WidthHeightEqualToView)(UIView *toView, CGFloat ratioValue);

@interface SDAutoLayoutModel : NSObject

/*
 *************************说明************************
 
 方法名中带有“SpaceToView”的需要传递2个参数：（UIView）参照view 和 （CGFloat）间距数值
 方法名中带有“RatioToView”的需要传递2个参数：（UIView）参照view 和 （CGFloat）倍数
 方法名中带有“EqualToView”的需要传递1个参数：（UIView）参照view
 方法名中带有“Is”的需要传递1个参数：（CGFloat）数值
 
 *****************************************************
 */

/*
 *  设置距离其它view的间距
 */

@property (nonatomic, copy, readonly) MarginToView leftSpaceToView;
@property (nonatomic, copy, readonly) MarginToView rightSpaceToView;
@property (nonatomic, copy, readonly) MarginToView topSpaceToView;
@property (nonatomic, copy, readonly) MarginToView bottomSpaceToView;

/*
 *  设置x、y、width、height、centerX、centerY 值
 */

@property (nonatomic, copy, readonly) Margin xIs;
@property (nonatomic, copy, readonly) Margin yIs;
@property (nonatomic, copy, readonly) Margin centerXIs;
@property (nonatomic, copy, readonly) Margin centerYIs;
@property (nonatomic, copy, readonly) WidthHeight widthIs;
@property (nonatomic, copy, readonly) WidthHeight heightIs;

/*
 *  设置和哪一个参照view的边距相同
 */

@property (nonatomic, copy, readonly) MarginEqualToView leftEqualToView;
@property (nonatomic, copy, readonly) MarginEqualToView rightEqualToView;
@property (nonatomic, copy, readonly) MarginEqualToView topEqualToView;
@property (nonatomic, copy, readonly) MarginEqualToView bottomEqualToView;
@property (nonatomic, copy, readonly) MarginEqualToView centerXEqualToView;
@property (nonatomic, copy, readonly) MarginEqualToView centerYEqualToView;

/*
 *  设置宽度或者高度等于参照view的多少倍
 */

@property (nonatomic, copy, readonly) WidthHeightEqualToView widthRatioToView;
@property (nonatomic, copy, readonly) WidthHeightEqualToView heightRatioToView;


@property (nonatomic, weak) UIView *referencedView;
@property (nonatomic, weak) UIView *needsAutoResizeView;

@end

@interface UIView (SDAutoLayout)

- (NSMutableArray *)autoLayoutModelsArray;

- (SDAutoLayoutModel *)sd_layout;

- (void)addAutoLayoutModel:(SDAutoLayoutModel *)model;

- (void)addLayoutModelWithAttributeHeightOrWidth:(SDAutoLayoutModel *)model;

@property (nonatomic, strong) NSNumber *fixedWith;
@property (nonatomic, strong) NSNumber *fixedHeight;

#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒

- (void)addOwnAutoLayoutModel:(SDAutoLayoutModel *)model withKey:(NSString *)key;

- (void)checkAutoLayoutIntegrality;

#endif

@end


@interface UIView (SDChangeFrame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;


@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@end
