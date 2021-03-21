//
//  UIView+SDAutoLayout.h
//
//  Created by gsd on 15/10/6.
//  Copyright (c) 2015年 gsd. All rights reserved.
//

/*
 *************************************************************************
 
 --------- INTRODUCTION ---------
 
 USAGE:
 
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
 *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * QQ    : 2689718696(gsdios)
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 * 新浪微博:GSD_iOS
 *
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 
 SDAutoLayout
 版本：2.1.7
 发布：2016.08.12
 
 */


// 如果需要用“断言”调试程序请打开此宏

//#define SDDebugWithAssert

#import <UIKit/UIKit.h>

@class SDAutoLayoutModel, SDUIViewCategoryManager;

typedef SDAutoLayoutModel * _Nonnull (^MarginToView)(id _Nonnull viewOrViewsArray, CGFloat value);
typedef SDAutoLayoutModel * _Nonnull (^Margin)(CGFloat value);
typedef SDAutoLayoutModel * _Nonnull (^MarginEqualToView)(UIView * _Nonnull toView);
typedef SDAutoLayoutModel * _Nonnull (^WidthHeight)(CGFloat value);
typedef SDAutoLayoutModel * _Nonnull (^WidthHeightEqualToView)(UIView * _Nonnull toView, CGFloat ratioValue);
typedef SDAutoLayoutModel * _Nonnull (^AutoHeightWidth)(CGFloat ratioValue);
typedef SDAutoLayoutModel * _Nonnull (^SameWidthHeight)(void);
typedef SDAutoLayoutModel * _Nonnull (^Offset)(CGFloat value);
typedef void (^SpaceToSuperView)(UIEdgeInsets insets);

@interface SDAutoLayoutModel : NSObject

/*
 *************************说明************************
 
 方法名中带有“SpaceToView”的需要传递2个参数：（UIView）参照view 和 （CGFloat）间距数值
 方法名中带有“RatioToView”的需要传递2个参数：（UIView）参照view 和 （CGFloat）倍数
 方法名中带有“EqualToView”的需要传递1个参数：（UIView）参照view
 方法名中带有“Is”的需要传递1个参数：（CGFloat）数值
 
 *****************************************************
 */


/* 设置距离其它view的间距 */

/** 左边到其参照view之间的间距，参数为“(View 或者 view数组, CGFloat)”  */
@property (nonatomic, copy, readonly) MarginToView _Nonnull leftSpaceToView;
/** 右边到其参照view之间的间距，参数为“(View, CGFloat)”  */
@property (nonatomic, copy, readonly) MarginToView _Nonnull rightSpaceToView;
/** 顶部到其参照view之间的间距，参数为“(View 或者 view数组, CGFloat)”  */
@property (nonatomic, copy, readonly) MarginToView _Nonnull topSpaceToView;
/** 底部到其参照view之间的间距，参数为“(View, CGFloat)”  */
@property (nonatomic, copy, readonly) MarginToView _Nonnull bottomSpaceToView;



/* 设置x、y、width、height、centerX、centerY 值 */

/** x值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) Margin _Nonnull xIs;
/** y值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) Margin _Nonnull yIs;
/** centerX值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) Margin _Nonnull centerXIs;
/** centerY值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) Margin _Nonnull centerYIs;
/** 宽度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight _Nonnull widthIs;
/** 高度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight _Nonnull heightIs;



/* 设置最大宽度和高度、最小宽度和高度 */

/** 最大宽度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight _Nonnull maxWidthIs;
/** 最大高度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight _Nonnull maxHeightIs;
/** 最小宽度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight _Nonnull minWidthIs;
/** 最小高度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight _Nonnull minHeightIs;



/* 设置和某个参照view的边距相同 */

/** 左间距与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView _Nonnull leftEqualToView;
/** 右间距与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView _Nonnull rightEqualToView;
/** 顶部间距与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView _Nonnull topEqualToView;
/** 底部间距与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView _Nonnull bottomEqualToView;
/** centerX与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView _Nonnull centerXEqualToView;
/** centerY与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView _Nonnull centerYEqualToView;



/*  设置宽度或者高度等于参照view的多少倍 */

/** 宽度是参照view宽度的多少倍，参数为“(View, CGFloat)” */
@property (nonatomic, copy, readonly) WidthHeightEqualToView _Nonnull widthRatioToView;
/** 高度是参照view高度的多少倍，参数为“(View, CGFloat)” */
@property (nonatomic, copy, readonly) WidthHeightEqualToView _Nonnull heightRatioToView;
/** 设置一个view的宽度和它的高度相同，参数为空“()” */
@property (nonatomic, copy, readonly) SameWidthHeight _Nonnull widthEqualToHeight;
/** 设置一个view的高度和它的宽度相同，参数为空“()” */
@property (nonatomic, copy, readonly) SameWidthHeight _Nonnull heightEqualToWidth;
/** 自适应高度，传入高宽比值，label可以传0实现文字高度自适应 */
@property (nonatomic, copy, readonly) AutoHeightWidth _Nonnull autoHeightRatio;

/** 自适应宽度，参数为宽高比值 */
@property (nonatomic, copy, readonly) AutoHeightWidth _Nonnull autoWidthRatio;



/* 填充父view(快捷方法) */

/** 传入UIEdgeInsetsMake(top, left, bottom, right)，可以快捷设置view到其父view上左下右的间距  */
@property (nonatomic, copy, readonly) SpaceToSuperView _Nonnull spaceToSuperView;

/** 设置偏移量，参数为“(CGFloat value)，目前只有带有equalToView的方法可以设置offset” */
@property (nonatomic, copy, readonly) Offset _Nonnull offset;

@property (nonatomic, weak) UIView * _Nullable needsAutoResizeView;

@end



#pragma mark - UIView 高度、宽度自适应相关方法

@interface UIView (SDAutoHeightWidth)

/** 设置Cell的高度自适应，也可用于设置普通view内容高度自适应 */
- (void)setupAutoHeightWithBottomView:(UIView *_Nonnull)bottomView bottomMargin:(CGFloat)bottomMargin;

/** 用于设置普通view内容宽度自适应 */
- (void)setupAutoWidthWithRightView:(UIView *_Nonnull)rightView rightMargin:(CGFloat)rightMargin;

/** 设置Cell的高度自适应，也可用于设置普通view内容自适应（应用于当你不确定哪个view在自动布局之后会排布在最下方最为bottomView的时候可以调用次方法将所有可能在最下方的view都传过去） */
- (void)setupAutoHeightWithBottomViewsArray:(NSArray *_Nonnull)bottomViewsArray bottomMargin:(CGFloat)bottomMargin;

/** 更新布局（主动刷新布局，如果你需要设置完布局代码就获得view的frame请调用此方法） */
- (void)updateLayout;

/** 更新cell内部的控件的布局（cell内部控件专属的更新约束方法,如果启用了cell frame缓存则会自动清除缓存再更新约束） */
- (void)updateLayoutWithCellContentView:(UIView *_Nonnull)cellContentView;

/** 清空高度自适应设置  */
- (void)clearAutoHeigtSettings;

/** 清空宽度自适应设置  */
- (void)clearAutoWidthSettings;

@property (nonatomic) CGFloat autoHeight;

@property (nonatomic, readonly) SDUIViewCategoryManager * _Nullable sd_categoryManager;

@property (nonatomic, readonly) NSMutableArray * _Nullable sd_bottomViewsArray;
@property (nonatomic) CGFloat sd_bottomViewBottomMargin;

@property (nonatomic) NSArray * _Nullable sd_rightViewsArray;
@property (nonatomic) CGFloat sd_rightViewRightMargin;

@end



#pragma mark - UIView 设置圆角半径、自动布局回调block等相关方法

@interface UIView (SDLayoutExtention)

/** 自动布局完成后的回调block，可以在这里获取到view的真实frame  */
@property (nonatomic) void (^ _Nullable didFinishAutoLayoutBlock)(CGRect frame);

/** 添加一组子view  */
- (void)sd_addSubviews:(NSArray *_Nullable)subviews;

/* 设置圆角 */

/** 设置圆角半径值  */
@property (nonatomic, strong) NSNumber * _Nullable sd_cornerRadius;
/** 设置圆角半径值为view宽度的多少倍  */
@property (nonatomic, strong) NSNumber * _Nullable sd_cornerRadiusFromWidthRatio;
/** 设置圆角半径值为view高度的多少倍  */
@property (nonatomic, strong) NSNumber * _Nullable sd_cornerRadiusFromHeightRatio;

/** 设置等宽子view（子view需要在同一水平方向） */
@property (nonatomic, strong) NSArray * _Nullable sd_equalWidthSubviews;

@end



#pragma mark - UIView 九宫格浮动布局效果

@interface UIView (SDAutoFlowItems)

/** 
 * 设置类似collectionView效果的固定间距自动宽度浮动子view 
 * viewsArray       : 需要浮动布局的所有视图
 * perRowItemsCount : 每行显示的视图个数
 * verticalMargin   : 视图之间的垂直间距
 * horizontalMargin : 视图之间的水平间距
 * vInset           : 上下缩进值
 * hInset           : 左右缩进值
 */
- (void)setupAutoWidthFlowItems:(NSArray *_Nullable)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMagin verticalEdgeInset:(CGFloat)vInset horizontalEdgeInset:(CGFloat)hInset;

/** 清除固定间距自动宽度浮动子view设置 */
- (void)clearAutoWidthFlowItemsSettings;

/** 
 * 设置类似collectionView效果的固定宽带自动间距浮动子view 
 * viewsArray       : 需要浮动布局的所有视图
 * perRowItemsCount : 每行显示的视图个数
 * verticalMargin   : 视图之间的垂直间距
 * vInset           : 上下缩进值
 * hInset           : 左右缩进值
 */
- (void)setupAutoMarginFlowItems:(NSArray *_Nullable)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount itemWidth:(CGFloat)itemWidth verticalMargin:(CGFloat)verticalMargin verticalEdgeInset:(CGFloat)vInset horizontalEdgeInset:(CGFloat)hInset;

/** 清除固定宽带自动间距浮动子view设置 */
- (void)clearAutoMarginFlowItemsSettings;

@end



#pragma mark - UIView 设置约束、更新约束、清空约束、从父view移除并清空约束、开启cell的frame缓存等相关方法

@interface UIView (SDAutoLayout)

- (void)sd_makeLayout:(void(^)(SDAutoLayoutModel *layout))config;

/** 开始自动布局  */
- (nonnull SDAutoLayoutModel *)sd_layout;

/** 清空之前的自动布局设置，重新开始自动布局(重新生成布局约束并使其在父view的布局序列数组中位置保持不变)  */
- (nonnull SDAutoLayoutModel *)sd_resetLayout;

/** 清空之前的自动布局设置，重新开始自动布局(重新生成布局约束并添加到父view布局序列数组中的最后一个位置)  */
- (nonnull SDAutoLayoutModel *)sd_resetNewLayout;

/** 是否关闭自动布局  */
@property (nonatomic, getter = sd_isClosingAutoLayout) BOOL sd_closeAutoLayout;

/** 从父view移除并清空约束  */
- (void)removeFromSuperviewAndClearAutoLayoutSettings;

/** 清空之前的自动布局设置  */
- (void)sd_clearAutoLayoutSettings;

/** 将自身frame清零（一般在cell内部控件重用前调用）  */
- (void)sd_clearViewFrameCache;

/** 将自己的需要自动布局的subviews的frame(或者frame缓存)清零  */
- (void)sd_clearSubviewsAutoLayoutFrameCaches;

/** 设置固定宽度保证宽度不在自动布局过程再做中调整  */
@property (nonatomic, strong) NSNumber * _Nullable fixedWidth;

/** 设置固定高度保证高度不在自动布局过程中再做调整  */
@property (nonatomic, strong) NSNumber * _Nullable fixedHeight;

/** 启用cell frame缓存（可以提高cell滚动的流畅度, 目前为cell专用方法，后期会扩展到其他view） */
- (void)useCellFrameCacheWithIndexPath:(NSIndexPath *_Nonnull)indexPath tableView:(UITableView *_Nonnull)tableview;

/** 所属tableview（目前为cell专用属性，后期会扩展到其他view） */
@property (nonatomic) UITableView * _Nullable sd_tableView;

/** cell的indexPath（目前为cell专用属性，后期会扩展到cell的其他子view） */
@property (nonatomic) NSIndexPath * _Nullable sd_indexPath;

- (NSMutableArray *_Nullable)autoLayoutModelsArray;
- (void)addAutoLayoutModel:(SDAutoLayoutModel *_Nullable)model;
@property (nonatomic) SDAutoLayoutModel * _Nullable ownLayoutModel;
@property (nonatomic, strong) NSNumber * _Nullable sd_maxWidth;
@property (nonatomic, strong) NSNumber * _Nullable autoHeightRatioValue;
@property (nonatomic, strong) NSNumber * _Nullable autoWidthRatioValue;

@end



#pragma mark - UIScrollView 内容竖向自适应、内容横向自适应方法

@interface UIScrollView (SDAutoContentSize)

/** 设置scrollview内容竖向自适应 */
- (void)setupAutoContentSizeWithBottomView:(UIView *_Nonnull)bottomView bottomMargin:(CGFloat)bottomMargin;

/** 设置scrollview内容横向自适应 */
- (void)setupAutoContentSizeWithRightView:(UIView *_Nonnull)rightView rightMargin:(CGFloat)rightMargin;

@end



#pragma mark - UILabel 开启富文本布局、设置单行文本label宽度自适应、 设置label最多可以显示的行数

@interface UILabel (SDLabelAutoResize)

/** 是否是attributedString */
@property (nonatomic) BOOL isAttributedContent;

/** 设置单行文本label宽度自适应 */
- (void)setSingleLineAutoResizeWithMaxWidth:(CGFloat)maxWidth;

/** 设置label最多可以显示多少行，如果传0则显示所有行文字 */
- (void)setMaxNumberOfLinesToShow:(NSInteger)lineCount;

@end



#pragma mark - UIButton 设置button根据单行文字自适应

@interface UIButton (SDExtention)

/*
 * 设置button根据单行文字自适应
 * hPadding：左右边距
 */
- (void)setupAutoSizeWithHorizontalPadding:(CGFloat)hPadding buttonHeight:(CGFloat)buttonHeight;

@end




























#pragma mark - 其他方法（如果有需要可以自己利用以下接口拓展更多功能）

@interface SDAutoLayoutModelItem : NSObject

@property (nonatomic, strong) NSNumber * _Nullable value;
@property (nonatomic, weak) UIView * _Nullable refView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) NSArray * _Nullable refViewsArray;

@end


@interface UIView (SDChangeFrame)

@property (nonatomic) BOOL shouldReadjustFrameBeforeStoreCache;

@property (nonatomic) CGFloat left_sd;
@property (nonatomic) CGFloat top_sd;
@property (nonatomic) CGFloat right_sd;
@property (nonatomic) CGFloat bottom_sd;
@property (nonatomic) CGFloat centerX_sd;
@property (nonatomic) CGFloat centerY_sd;

@property (nonatomic) CGFloat width_sd;
@property (nonatomic) CGFloat height_sd;


@property (nonatomic) CGPoint origin_sd;
@property (nonatomic) CGSize size_sd;


// 兼容旧版本
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


@interface SDUIViewCategoryManager : NSObject

@property (nonatomic, strong) NSArray * _Nullable rightViewsArray;
@property (nonatomic, assign) CGFloat rightViewRightMargin;

@property (nonatomic, weak) UITableView * _Nullable sd_tableView;
@property (nonatomic, strong) NSIndexPath * _Nullable sd_indexPath;

@property (nonatomic, assign) BOOL hasSetFrameWithCache;

@property (nonatomic) BOOL shouldReadjustFrameBeforeStoreCache;

@property (nonatomic, assign, getter = sd_isClosingAutoLayout) BOOL sd_closeAutoLayout;


/** 设置类似collectionView效果的固定间距自动宽度浮动子view */

@property (nonatomic, strong) NSArray * _Nullable flowItems;
@property (nonatomic, assign) CGFloat verticalMargin;
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign) NSInteger perRowItemsCount;
@property (nonatomic, assign) CGFloat lastWidth;


/** 设置类似collectionView效果的固定宽带自动间距浮动子view */

@property (nonatomic, assign) CGFloat flowItemWidth;
@property (nonatomic, assign) BOOL shouldShowAsAutoMarginViews;


@property (nonatomic) CGFloat horizontalEdgeInset;
@property (nonatomic) CGFloat verticalEdgeInset;

@end

