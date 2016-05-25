//
//  UIView+SDAutoLayout.m
//
//  Created by gsd on 15/10/6.
//  Copyright (c) 2015年 gsd. All rights reserved.
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

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#import <objc/runtime.h>

@interface SDAutoLayoutModel ()

@property (nonatomic, strong) SDAutoLayoutModelItem *width;
@property (nonatomic, strong) SDAutoLayoutModelItem *height;
@property (nonatomic, strong) SDAutoLayoutModelItem *left;
@property (nonatomic, strong) SDAutoLayoutModelItem *top;
@property (nonatomic, strong) SDAutoLayoutModelItem *right;
@property (nonatomic, strong) SDAutoLayoutModelItem *bottom;
@property (nonatomic, strong) NSNumber *centerX;
@property (nonatomic, strong) NSNumber *centerY;

@property (nonatomic, strong) NSNumber *maxWidth;
@property (nonatomic, strong) NSNumber *maxHeight;
@property (nonatomic, strong) NSNumber *minWidth;
@property (nonatomic, strong) NSNumber *minHeight;

@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_width;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_height;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_left;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_top;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_right;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_bottom;

@property (nonatomic, strong) SDAutoLayoutModelItem *equalLeft;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalRight;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalTop;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalBottom;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalCenterX;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalCenterY;

@property (nonatomic, strong) SDAutoLayoutModelItem *widthEqualHeight;
@property (nonatomic, strong) SDAutoLayoutModelItem *heightEqualWidth;

@property (nonatomic, strong) SDAutoLayoutModelItem *lastModelItem;

@end

@implementation SDAutoLayoutModel

@synthesize leftSpaceToView = _leftSpaceToView;
@synthesize rightSpaceToView = _rightSpaceToView;
@synthesize topSpaceToView = _topSpaceToView;
@synthesize bottomSpaceToView = _bottomSpaceToView;
@synthesize widthIs = _widthIs;
@synthesize heightIs = _heightIs;
@synthesize widthRatioToView = _widthRatioToView;
@synthesize heightRatioToView = _heightRatioToView;
@synthesize leftEqualToView = _leftEqualToView;
@synthesize rightEqualToView = _rightEqualToView;
@synthesize topEqualToView = _topEqualToView;
@synthesize bottomEqualToView = _bottomEqualToView;
@synthesize centerXEqualToView = _centerXEqualToView;
@synthesize centerYEqualToView = _centerYEqualToView;
@synthesize xIs = _xIs;
@synthesize yIs = _yIs;
@synthesize centerXIs = _centerXIs;
@synthesize centerYIs = _centerYIs;
@synthesize autoHeightRatio = _autoHeightRatio;
@synthesize spaceToSuperView = _spaceToSuperView;
@synthesize maxWidthIs = _maxWidthIs;
@synthesize maxHeightIs = _maxHeightIs;
@synthesize minWidthIs = _minWidthIs;
@synthesize minHeightIs = _minHeightIs;
@synthesize widthEqualToHeight = _widthEqualToHeight;
@synthesize heightEqualToWidth = _heightEqualToWidth;
@synthesize offset = _offset;


- (MarginToView)leftSpaceToView
{
    if (!_leftSpaceToView) {
        _leftSpaceToView = [self marginToViewblockWithKey:@"left"];
    }
    return _leftSpaceToView;
}

- (MarginToView)rightSpaceToView
{
    if (!_rightSpaceToView) {
        _rightSpaceToView = [self marginToViewblockWithKey:@"right"];
    }
    return _rightSpaceToView;
}

- (MarginToView)topSpaceToView
{
    if (!_topSpaceToView) {
        _topSpaceToView = [self marginToViewblockWithKey:@"top"];
    }
    return _topSpaceToView;
}

- (MarginToView)bottomSpaceToView
{
    if (!_bottomSpaceToView) {
        _bottomSpaceToView = [self marginToViewblockWithKey:@"bottom"];
    }
    return _bottomSpaceToView;
}

- (MarginToView)marginToViewblockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    return ^(UIView *view, CGFloat value) {
        SDAutoLayoutModelItem *item = [SDAutoLayoutModelItem new];
        item.value = @(value);
        item.refView = view;
        [weakSelf setValue:item forKey:key];
        return weakSelf;
    };
}

- (WidthHeight)widthIs
{
    if (!_widthIs) {
        __weak typeof(self) weakSelf = self;
        _widthIs = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.fixedWidth = @(value);
            SDAutoLayoutModelItem *widthItem = [SDAutoLayoutModelItem new];
            widthItem.value = @(value);
            weakSelf.width = widthItem;
            return weakSelf;
        };
    }
    return _widthIs;
}

- (WidthHeight)heightIs
{
    if (!_heightIs) {
        __weak typeof(self) weakSelf = self;
        _heightIs = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.fixedHeight = @(value);
            SDAutoLayoutModelItem *heightItem = [SDAutoLayoutModelItem new];
            heightItem.value = @(value);
            weakSelf.height = heightItem;
            return weakSelf;
        };
    }
    return _heightIs;
}

- (WidthHeightEqualToView)widthRatioToView
{
    if (!_widthRatioToView) {
        __weak typeof(self) weakSelf = self;
        _widthRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_width = [SDAutoLayoutModelItem new];
            weakSelf.ratio_width.value = @(value);
            weakSelf.ratio_width.refView = view;
            return weakSelf;
        };
    }
    return _widthRatioToView;
}

- (WidthHeightEqualToView)heightRatioToView
{
    if (!_heightRatioToView) {
        __weak typeof(self) weakSelf = self;
        _heightRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_height = [SDAutoLayoutModelItem new];
            weakSelf.ratio_height.refView = view;
            weakSelf.ratio_height.value = @(value);
            return weakSelf;
        };
    }
    return _heightRatioToView;
}

- (WidthHeight)maxWidthIs
{
    if (!_maxWidthIs) {
        _maxWidthIs = [self limitingWidthHeightWithKey:@"maxWidth"];
    }
    return _maxWidthIs;
}

- (WidthHeight)maxHeightIs
{
    if (!_maxHeightIs) {
        _maxHeightIs = [self limitingWidthHeightWithKey:@"maxHeight"];
    }
    return _maxHeightIs;
}

- (WidthHeight)minWidthIs
{
    if (!_minWidthIs) {
        _minWidthIs = [self limitingWidthHeightWithKey:@"minWidth"];
    }
    return _minWidthIs;
}

- (WidthHeight)minHeightIs
{
    if (!_minHeightIs) {
        _minHeightIs = [self limitingWidthHeightWithKey:@"minHeight"];
    }
    return _minHeightIs;
}


- (WidthHeight)limitingWidthHeightWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat value) {
        [weakSelf setValue:@(value) forKey:key];
        
        return weakSelf;
    };
}


- (MarginEqualToView)marginEqualToViewBlockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view) {
        SDAutoLayoutModelItem *item = [SDAutoLayoutModelItem new];
        item.refView = view;
        [weakSelf setValue:item forKey:key];
        weakSelf.lastModelItem = item;
        if ([key isEqualToString:@"equalCenterY"] && [view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
            view.shouldReadjustFrameBeforeStoreCache = YES;
        }
        return weakSelf;
    };
}

- (MarginEqualToView)leftEqualToView
{
    if (!_leftEqualToView) {
        _leftEqualToView = [self marginEqualToViewBlockWithKey:@"equalLeft"];
    }
    return _leftEqualToView;
}

- (MarginEqualToView)rightEqualToView
{
    if (!_rightEqualToView) {
        _rightEqualToView = [self marginEqualToViewBlockWithKey:@"equalRight"];
    }
    return _rightEqualToView;
}

- (MarginEqualToView)topEqualToView
{
    if (!_topEqualToView) {
        _topEqualToView = [self marginEqualToViewBlockWithKey:@"equalTop"];
    }
    return _topEqualToView;
}

- (MarginEqualToView)bottomEqualToView
{
    if (!_bottomEqualToView) {
        _bottomEqualToView = [self marginEqualToViewBlockWithKey:@"equalBottom"];
    }
    return _bottomEqualToView;
}

- (MarginEqualToView)centerXEqualToView
{
    if (!_centerXEqualToView) {
        _centerXEqualToView = [self marginEqualToViewBlockWithKey:@"equalCenterX"];
    }
    return _centerXEqualToView;
}

- (MarginEqualToView)centerYEqualToView
{
    if (!_centerYEqualToView) {
        _centerYEqualToView = [self marginEqualToViewBlockWithKey:@"equalCenterY"];
    }
    return _centerYEqualToView;
}


- (Margin)marginBlockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat value) {
        
        if ([key isEqualToString:@"x"]) {
            weakSelf.needsAutoResizeView.left_sd = value;
        } else if ([key isEqualToString:@"y"]) {
            weakSelf.needsAutoResizeView.top_sd = value;
        } else if ([key isEqualToString:@"centerX"]) {
            weakSelf.centerX = @(value);
        } else if ([key isEqualToString:@"centerY"]) {
            weakSelf.centerY = @(value);
        }
        
        return weakSelf;
    };
}

- (Margin)xIs
{
    if (!_xIs) {
        _xIs = [self marginBlockWithKey:@"x"];
    }
    return _xIs;
}

- (Margin)yIs
{
    if (!_yIs) {
        _yIs = [self marginBlockWithKey:@"y"];
    }
    return _yIs;
}

- (Margin)centerXIs
{
    if (!_centerXIs) {
        _centerXIs = [self marginBlockWithKey:@"centerX"];
    }
    return _centerXIs;
}

- (Margin)centerYIs
{
    if (!_centerYIs) {
        _centerYIs = [self marginBlockWithKey:@"centerY"];
    }
    return _centerYIs;
}

- (AutoHeight)autoHeightRatio
{
    __weak typeof(self) weakSelf = self;
    
    if (!_autoHeightRatio) {
        _autoHeightRatio = ^(CGFloat ratioaValue) {
            weakSelf.needsAutoResizeView.autoHeightRatioValue = @(ratioaValue);
            return weakSelf;
        };
    }
    return _autoHeightRatio;
}

- (SpaceToSuperView)spaceToSuperView
{
    __weak typeof(self) weakSelf = self;
    
    if (!_spaceToSuperView) {
        _spaceToSuperView = ^(UIEdgeInsets insets) {
            UIView *superView = weakSelf.needsAutoResizeView.superview;
            if (superView) {
                weakSelf.needsAutoResizeView.sd_layout
                .leftSpaceToView(superView, insets.left)
                .topSpaceToView(superView, insets.top)
                .rightSpaceToView(superView, insets.right)
                .bottomSpaceToView(superView, insets.bottom);
            }
        };
    }
    return _spaceToSuperView;
}

- (SameWidthHeight)widthEqualToHeight
{
    __weak typeof(self) weakSelf = self;
    
    if (!_widthEqualToHeight) {
        _widthEqualToHeight = ^() {
            weakSelf.widthEqualHeight = [SDAutoLayoutModelItem new];
            weakSelf.lastModelItem = weakSelf.widthEqualHeight;
            // 主动触发一次赋值操作
            weakSelf.needsAutoResizeView.height_sd = weakSelf.needsAutoResizeView.height_sd;
            return weakSelf;
        };
    }
    return _widthEqualToHeight;
}

- (SameWidthHeight)heightEqualToWidth
{
    __weak typeof(self) weakSelf = self;
    
    if (!_heightEqualToWidth) {
        _heightEqualToWidth = ^() {
            weakSelf.heightEqualWidth = [SDAutoLayoutModelItem new];
            weakSelf.lastModelItem = weakSelf.heightEqualWidth;
            // 主动触发一次赋值操作
            weakSelf.needsAutoResizeView.width_sd = weakSelf.needsAutoResizeView.width_sd;
            return weakSelf;
        };
    }
    return _heightEqualToWidth;
}

- (SDAutoLayoutModel *(^)(CGFloat))offset
{
    __weak typeof(self) weakSelf = self;
    if (!_offset) {
        _offset = ^(CGFloat offset) {
            weakSelf.lastModelItem.offset = offset;
            return weakSelf;
        };
    }
    return _offset;
}

@end


@implementation UIView (SDAutoHeightWidth)

- (SDUIViewCategoryManager *)sd_categoryManager
{
    SDUIViewCategoryManager *manager = objc_getAssociatedObject(self, _cmd);
    if (!manager) {
        objc_setAssociatedObject(self, _cmd, [SDUIViewCategoryManager new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin
{
    if (!bottomView) return;
    
    [self setupAutoHeightWithBottomViewsArray:@[bottomView] bottomMargin:bottomMargin];
}

- (void)setupAutoWidthWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin
{
    if (!rightView) return;
    
    self.sd_rightViewsArray = @[rightView];
    self.sd_rightViewRightMargin = rightMargin;
}

- (void)setupAutoHeightWithBottomViewsArray:(NSArray *)bottomViewsArray bottomMargin:(CGFloat)bottomMargin
{
    if (!bottomViewsArray) return;
    
    // 清空之前的view
    [self.sd_bottomViewsArray removeAllObjects];
    [self.sd_bottomViewsArray addObjectsFromArray:bottomViewsArray];
    self.sd_bottomViewBottomMargin = bottomMargin;
}

- (void)clearAutoHeigtSettings
{
    [self.sd_bottomViewsArray removeAllObjects];
}

- (void)clearAutoWidthSettings
{
    self.sd_rightViewsArray = nil;
}

- (void)updateLayout
{
    [self.superview layoutSubviews];
}

- (void)updateLayoutWithCellContentView:(UIView *)cellContentView
{
    if (cellContentView.sd_indexPath) {
        [cellContentView sd_clearSubviewsAutoLayoutFrameCaches];
    }
    [self updateLayout];
}

- (CGFloat)autoHeight
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setAutoHeight:(CGFloat)autoHeight
{
    objc_setAssociatedObject(self, @selector(autoHeight), @(autoHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)sd_bottomViewsArray
{
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSArray *)sd_rightViewsArray
{
    return [[self sd_categoryManager] rightViewsArray];
}

- (void)setSd_rightViewsArray:(NSArray *)sd_rightViewsArray
{
    [[self sd_categoryManager] setRightViewsArray:sd_rightViewsArray];
}

- (CGFloat)sd_bottomViewBottomMargin
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSd_bottomViewBottomMargin:(CGFloat)sd_bottomViewBottomMargin
{
    objc_setAssociatedObject(self, @selector(sd_bottomViewBottomMargin), @(sd_bottomViewBottomMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSd_rightViewRightMargin:(CGFloat)sd_rightViewRightMargin
{
    [[self sd_categoryManager] setRightViewRightMargin:sd_rightViewRightMargin];
}

- (CGFloat)sd_rightViewRightMargin
{
    return [[self sd_categoryManager] rightViewRightMargin];
}

@end

@implementation UIView (SDLayoutExtention)

- (void (^)(CGRect))didFinishAutoLayoutBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDidFinishAutoLayoutBlock:(void (^)(CGRect))didFinishAutoLayoutBlock
{
    objc_setAssociatedObject(self, @selector(didFinishAutoLayoutBlock), didFinishAutoLayoutBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)sd_cornerRadius
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadius:(NSNumber *)sd_cornerRadius
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadius), sd_cornerRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)sd_cornerRadiusFromWidthRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadiusFromWidthRatio:(NSNumber *)sd_cornerRadiusFromWidthRatio
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadiusFromWidthRatio), sd_cornerRadiusFromWidthRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)sd_cornerRadiusFromHeightRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadiusFromHeightRatio:(NSNumber *)sd_cornerRadiusFromHeightRatio
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadiusFromHeightRatio), sd_cornerRadiusFromHeightRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)sd_equalWidthSubviews
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_equalWidthSubviews:(NSArray *)sd_equalWidthSubviews
{
    objc_setAssociatedObject(self, @selector(sd_equalWidthSubviews), sd_equalWidthSubviews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setupAutoWidthFlowItems:(NSArray *)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMagin
{
    self.sd_categoryManager.flowItems = viewsArray;
    self.sd_categoryManager.perRowItemsCount = perRowItemsCount;
    self.sd_categoryManager.verticalMargin = verticalMargin;
    self.sd_categoryManager.horizontalMargin = horizontalMagin;
    
    self.sd_categoryManager.lastWidth = 0;
    
    if (viewsArray.count) {
        [self setupAutoHeightWithBottomView:viewsArray.lastObject bottomMargin:verticalMargin];
    } else {
        [self clearAutoHeigtSettings];
    }
}

- (void)clearAutoWidthFlowItemsSettings
{
    [self setupAutoWidthFlowItems:nil withPerRowItemsCount:0 verticalMargin:0 horizontalMargin:0];
}

- (void)setupAutoMarginFlowItems:(NSArray *)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount itemWidth:(CGFloat)itemWidth verticalMargin:(CGFloat)verticalMargin
{
    self.sd_categoryManager.shouldShowAsAutoMarginViews = YES;
    self.sd_categoryManager.flowItemWidth = itemWidth;
    [self setupAutoWidthFlowItems:viewsArray withPerRowItemsCount:perRowItemsCount verticalMargin:verticalMargin horizontalMargin:0];
}

- (void)clearAutoMarginFlowItemsSettings
{
    [self setupAutoMarginFlowItems:nil withPerRowItemsCount:0 itemWidth:0 verticalMargin:0];
}

- (void)sd_addSubviews:(NSArray *)subviews
{
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIView class]]) {
            [self addSubview:view];
        }
    }];
}

@end

@implementation UIScrollView (SDAutoContentSize)

- (void)setupAutoContentSizeWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin
{
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:bottomMargin];
}

- (void)setupAutoContentSizeWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin
{
    if (!rightView) return;
    
    self.sd_rightViewsArray = @[rightView];
    self.sd_rightViewRightMargin = rightMargin;
}

@end

@implementation UILabel (SDLabelAutoResize)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"setText:"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *mySelString = [@"sd_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
            method_exchangeImplementations(originalMethod, myMethod);
        }];
    });
}

- (void)sd_setText:(NSString *)text
{
    // 如果程序崩溃在这行代码说明是你的label在执行“setText”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“setText”方法
    [self sd_setText:text];
    
    
    if (self.sd_maxWidth) {
        [self sizeToFit];
    } else if (self.autoHeightRatioValue) {
        self.size_sd = CGSizeZero;
    }
}

- (BOOL)isAttributedContent
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsAttributedContent:(BOOL)isAttributedContent
{
    objc_setAssociatedObject(self, @selector(isAttributedContent), @(isAttributedContent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSingleLineAutoResizeWithMaxWidth:(CGFloat)maxWidth
{
    self.sd_maxWidth = @(maxWidth);
}

- (void)setMaxNumberOfLinesToShow:(NSInteger)lineCount
{
    NSAssert(self.ownLayoutModel, @"请在布局完成之后再做此步设置！");
    if (lineCount > 0) {
        self.sd_layout.maxHeightIs(self.font.lineHeight * lineCount + 0.1);
    } else {
        self.sd_layout.maxHeightIs(MAXFLOAT);
    }
}

@end

@implementation UIButton (SDExtention)

- (void)setupAutoSizeWithHorizontalPadding:(CGFloat)hPadding buttonHeight:(CGFloat)buttonHeight
{
    self.fixedHeight = @(buttonHeight);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self, hPadding)
    .topEqualToView(self)
    .heightIs(buttonHeight);
    
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
    [self setupAutoWidthWithRightView:self.titleLabel rightMargin:hPadding];
}

@end


@implementation SDAutoLayoutModelItem

- (instancetype)init
{
    if (self = [super init]) {
        _offset = 0;
    }
    return self;
}

@end


@implementation UIView (SDAutoLayout)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"layoutSubviews"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *mySelString = [@"sd_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
            method_exchangeImplementations(originalMethod, myMethod);
        }];
    });
}

#pragma mark - properties

- (NSMutableArray *)autoLayoutModelsArray
{
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSNumber *)fixedWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedWidth:(NSNumber *)fixedWidth
{
    if (fixedWidth) {
        self.width_sd = [fixedWidth floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedWidth), fixedWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)fixedHeight
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedHeight:(NSNumber *)fixedHeight
{
    if (fixedHeight) {
        self.height_sd = [fixedHeight floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedHeight), fixedHeight, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)autoHeightRatioValue
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAutoHeightRatioValue:(NSNumber *)autoHeightRatioValue
{
    objc_setAssociatedObject(self, @selector(autoHeightRatioValue), autoHeightRatioValue, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)sd_maxWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_maxWidth:(NSNumber *)sd_maxWidth
{
    objc_setAssociatedObject(self, @selector(sd_maxWidth), sd_maxWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)useCellFrameCacheWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableview
{
    self.sd_indexPath = indexPath;
    self.sd_tableView = tableview;
}

- (UITableView *)sd_tableView
{
    return self.sd_categoryManager.sd_tableView;
}

- (void)setSd_tableView:(UITableView *)sd_tableView
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        [(UITableViewCell *)self contentView].sd_tableView = sd_tableView;
    }
    self.sd_categoryManager.sd_tableView = sd_tableView;
}

- (NSIndexPath *)sd_indexPath
{
    return self.sd_categoryManager.sd_indexPath;
}

- (void)setSd_indexPath:(NSIndexPath *)sd_indexPath
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        [(UITableViewCell *)self contentView].sd_indexPath = sd_indexPath;
    }
    self.sd_categoryManager.sd_indexPath = sd_indexPath;
}

- (SDAutoLayoutModel *)ownLayoutModel
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOwnLayoutModel:(SDAutoLayoutModel *)ownLayoutModel
{
    objc_setAssociatedObject(self, @selector(ownLayoutModel), ownLayoutModel, OBJC_ASSOCIATION_RETAIN);
}

- (SDAutoLayoutModel *)sd_layout
{
    
#ifdef SDDebugWithAssert
    /*
     卡在这里说明你的要自动布局的view在没有添加到父view的情况下就开始设置布局,你需要这样：
     1.  UIView *view = [UIView new];
     2.  [superView addSubview:view];
     3.  view.sd_layout
     .leftEqualToView()...
     */
    NSAssert(self.superview, @">>>>>>>>>在加入父view之后才可以做自动布局设置");
    
#endif
    
    SDAutoLayoutModel *model = [self ownLayoutModel];
    if (!model) {
        model = [SDAutoLayoutModel new];
        model.needsAutoResizeView = self;
        [self setOwnLayoutModel:model];
        [self.superview.autoLayoutModelsArray addObject:model];
    }
    
    return model;
}

- (SDAutoLayoutModel *)sd_resetLayout
{
    /*
     * 方案待定
     [self sd_clearAutoLayoutSettings];
     return [self sd_layout];
     */
    
    SDAutoLayoutModel *model = [self ownLayoutModel];
    SDAutoLayoutModel *newModel = [SDAutoLayoutModel new];
    newModel.needsAutoResizeView = self;
    [self sd_clearViewFrameCache];
    NSInteger index = 0;
    if (model) {
        index = [self.superview.autoLayoutModelsArray indexOfObject:model];
        [self.superview.autoLayoutModelsArray replaceObjectAtIndex:index withObject:newModel];
    } else {
        [self.superview.autoLayoutModelsArray addObject:newModel];
    }
    [self setOwnLayoutModel:newModel];
    [self sd_clearExtraAutoLayoutItems];
    return newModel;
}

- (SDAutoLayoutModel *)sd_resetNewLayout
{
    [self sd_clearAutoLayoutSettings];
    [self sd_clearExtraAutoLayoutItems];
    return [self sd_layout];
}

- (BOOL)sd_isClosingAotuLayout
{
    return self.sd_categoryManager.sd_isClosingAotuLayout;
}

- (void)setSd_closeAotuLayout:(BOOL)sd_closeAotuLayout
{
    self.sd_categoryManager.sd_closeAotuLayout = sd_closeAotuLayout;
}

- (void)removeFromSuperviewAndClearAutoLayoutSettings
{
    [self sd_clearAutoLayoutSettings];
    [self removeFromSuperview];
}

- (void)sd_clearAutoLayoutSettings
{
    SDAutoLayoutModel *model = [self ownLayoutModel];
    if (model) {
        [self.superview.autoLayoutModelsArray removeObject:model];
        [self setOwnLayoutModel:nil];
    }
    [self sd_clearExtraAutoLayoutItems];
}

- (void)sd_clearExtraAutoLayoutItems
{
    if (self.autoHeightRatioValue) {
        self.autoHeightRatioValue = nil;
    }
    self.fixedHeight = nil;
    self.fixedWidth = nil;
}

- (void)sd_clearViewFrameCache
{
    self.frame = CGRectZero;
}

- (void)sd_clearSubviewsAutoLayoutFrameCaches
{
    if (self.sd_tableView && self.sd_indexPath) {
        [self.sd_tableView.cellAutoHeightManager clearHeightCacheOfIndexPaths:@[self.sd_indexPath]];
        return;
    }
    
    if (self.autoLayoutModelsArray.count == 0) return;
    
    [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(SDAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
        model.needsAutoResizeView.frame = CGRectZero;
    }];
}

- (void)sd_layoutSubviews
{
    // 如果程序崩溃在这行代码说明是你的view在执行“layoutSubvies”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“layoutSubvies”方法
    [self sd_layoutSubviews];
    
    [self sd_layoutSubviewsHandle];
}

- (void)sd_layoutSubviewsHandle{

    if (self.sd_equalWidthSubviews.count) {
        __block CGFloat totalMargin = 0;
        [self.sd_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            SDAutoLayoutModel *model = view.sd_layout;
            CGFloat left = model.left ? [model.left.value floatValue] : model.needsAutoResizeView.left_sd;
            totalMargin += (left + [model.right.value floatValue]);
        }];
        CGFloat averageWidth = (self.width_sd - totalMargin) / self.sd_equalWidthSubviews.count;
        [self.sd_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            view.width_sd = averageWidth;
            view.fixedWidth = @(averageWidth);
        }];
    }
    
    if (self.sd_categoryManager.flowItems.count && (self.sd_categoryManager.lastWidth != self.width_sd)) {
        
        self.sd_categoryManager.lastWidth = self.width_sd;
        
        NSInteger perRowItemsCount = self.sd_categoryManager.perRowItemsCount;
        CGFloat horizontalMargin = 0;
        CGFloat w = 0;
        if (self.sd_categoryManager.shouldShowAsAutoMarginViews) {
            w = self.sd_categoryManager.flowItemWidth;
            long itemsCount = self.sd_categoryManager.perRowItemsCount;
            if (itemsCount > 1) {
                horizontalMargin = (self.width_sd - itemsCount * w) / (itemsCount - 1);
            }
        } else {
            horizontalMargin = self.sd_categoryManager.horizontalMargin;
            w = (self.width_sd - (perRowItemsCount - 1) * horizontalMargin) / perRowItemsCount;
        }
        CGFloat verticalMargin = self.sd_categoryManager.verticalMargin;
        
        __block UIView *referencedView = self;
        [self.sd_categoryManager.flowItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if (idx < perRowItemsCount) {
                if (idx == 0) {
                    /* 保留
                    BOOL shouldShowAsAutoMarginViews = self.sd_categoryManager.shouldShowAsAutoMarginViews;
                     */
                    view.sd_layout
                    .leftSpaceToView(referencedView, 0)
                    .topSpaceToView(referencedView, verticalMargin)
                    .widthIs(w);
                } else {
                    view.sd_layout
                    .leftSpaceToView(referencedView, horizontalMargin)
                    .topEqualToView(referencedView)
                    .widthIs(w);
                }
                referencedView = view;
            } else {
                referencedView = self.sd_categoryManager.flowItems[idx - perRowItemsCount];
                view.sd_layout
                .leftEqualToView(referencedView)
                .widthIs(w)
                .topSpaceToView(referencedView, verticalMargin);
            }
        }];
    }
    
    if (self.autoLayoutModelsArray.count) {
        
        NSMutableArray *caches = nil;
        
        if ([self isKindOfClass:NSClassFromString(@"UITableViewCellContentView")] && self.sd_tableView) {
            caches = [self.sd_tableView.cellAutoHeightManager subviewFrameCachesWithIndexPath:self.sd_indexPath];
        }
        
        [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(SDAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
            if (idx < caches.count) {
                model.needsAutoResizeView.frame = [[caches objectAtIndex:idx] CGRectValue];
                [self setupCornerRadiusWithView:model.needsAutoResizeView model:model];
                model.needsAutoResizeView.sd_categoryManager.hasSetFrameWithCache = YES;
            } else {
                if (model.needsAutoResizeView.sd_categoryManager.hasSetFrameWithCache) {
                    model.needsAutoResizeView.sd_categoryManager.hasSetFrameWithCache = NO;
                }
                [self sd_resizeWithModel:model];
            }
        }];
    }
    
    if (self.tag == kSDModelCellTag && [self isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        UITableViewCell *cell = (UITableViewCell *)(self.superview);
        if ([cell isKindOfClass:NSClassFromString(@"UITableViewCellScrollView")]) {
            cell = (UITableViewCell *)cell.superview;
        }
        if ([cell isKindOfClass:[UITableViewCell class]]) {
            CGFloat height = 0;
            for (UIView *view in cell.sd_bottomViewsArray) {
                height = MAX(height, view.bottom_sd);
            }
            cell.autoHeight = height + cell.sd_bottomViewBottomMargin;
        }
    } else if (![self isKindOfClass:[UITableViewCell class]] && (self.sd_bottomViewsArray.count || self.sd_rightViewsArray.count)) {
        if (self.sd_categoryManager.hasSetFrameWithCache) {
            self.sd_categoryManager.hasSetFrameWithCache = NO;
            return;
        }
        CGFloat contentHeight = 0;
        CGFloat contentWidth = 0;
        if (self.sd_bottomViewsArray) {
            CGFloat height = 0;
            for (UIView *view in self.sd_bottomViewsArray) {
                height = MAX(height, view.bottom_sd);
            }
            contentHeight = height + self.sd_bottomViewBottomMargin;
        }
        if (self.sd_rightViewsArray) {
            CGFloat width = 0;
            for (UIView *view in self.sd_rightViewsArray) {
                width = MAX(width, view.right_sd);
            }
            contentWidth = width + self.sd_rightViewRightMargin;
        }
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self;
            CGSize contentSize = scrollView.contentSize;
            if (contentHeight > 0) {
                contentSize.height = contentHeight;
            }
            if (contentWidth > 0) {
                contentSize.width = contentWidth;
            }
            if (contentSize.width <= 0) {
                contentSize.width = scrollView.width_sd;
            }
            if (!CGSizeEqualToSize(contentSize, scrollView.contentSize)) {
                scrollView.contentSize = contentSize;
            }
        } else {
            // 如果这里出现循环调用情况请把demo发送到gsdios@126.com，谢谢配合。
            if (self.sd_bottomViewsArray.count && (floorf(contentHeight) != floorf(self.height_sd))) {
                self.height_sd = contentHeight;
                self.fixedHeight = @(self.height_sd);
            }
            
            if (self.sd_rightViewsArray.count && (floorf(contentWidth) != floorf(self.width_sd))) {
                self.width_sd = contentWidth;
                self.fixedWidth = @(self.width_sd);
            }
        }
        
        if (![self isKindOfClass:[UIScrollView class]] && self.sd_rightViewsArray.count && (self.ownLayoutModel.right || self.ownLayoutModel.equalRight)) {
            [self layoutRightWithView:self model:self.ownLayoutModel];
        }
        
        if (![self isKindOfClass:[UIScrollView class]] && self.sd_bottomViewsArray.count && (self.ownLayoutModel.bottom || self.ownLayoutModel.equalBottom)) {
            [self layoutBottomWithView:self model:self.ownLayoutModel];
        }
        
        if (self.didFinishAutoLayoutBlock) {
            self.didFinishAutoLayoutBlock(self.frame);
        }
    }
}

- (void)sd_resizeWithModel:(SDAutoLayoutModel *)model
{
    UIView *view = model.needsAutoResizeView;
    
    if (!view || view.sd_isClosingAotuLayout) return;
    
    if (view.sd_maxWidth && (model.rightSpaceToView || model.rightEqualToView)) { // 靠右布局前提设置
        [self layoutAutoWidthWidthView:view model:model];
        view.fixedWidth = @(view.width_sd);
    }
    
    [self layoutWidthWithView:view model:model];
    
    [self layoutHeightWithView:view model:model];
    
    [self layoutLeftWithView:view model:model];
    
    [self layoutRightWithView:view model:model];
    
    if (view.autoHeightRatioValue && view.width_sd > 0 && (model.bottomEqualToView || model.bottomSpaceToView)) { // 底部布局前提设置
        [self layoutAutoHeightWidthView:view model:model];
        view.fixedHeight = @(view.height_sd);
    }
    
    
    [self layoutTopWithView:view model:model];
    
    [self layoutBottomWithView:view model:model];
    
    if (view.sd_maxWidth) {
        [self layoutAutoWidthWidthView:view model:model];
    }
    
    if (model.maxWidth && [model.maxWidth floatValue] < view.width_sd) {
        view.width_sd = [model.maxWidth floatValue];
    }
    
    if (model.minWidth && [model.minWidth floatValue] > view.width_sd) {
        view.width_sd = [model.minWidth floatValue];
    }
    
    if (view.autoHeightRatioValue && view.width_sd > 0) {
        [self layoutAutoHeightWidthView:view model:model];
    }
    
    if (model.maxHeight && [model.maxHeight floatValue] < view.height_sd) {
        view.height_sd = [model.maxHeight floatValue];
    }
    
    if (model.minHeight && [model.minHeight floatValue] > view.height_sd) {
        view.height_sd = [model.minHeight floatValue];
    }
    
    if (model.widthEqualHeight) {
        view.width_sd = view.height_sd;
    }
    
    if (model.heightEqualWidth) {
        view.height_sd = view.width_sd;
    }
    
    if (view.didFinishAutoLayoutBlock) {
        view.didFinishAutoLayoutBlock(view.frame);
    }
    
    if (view.sd_bottomViewsArray.count || view.sd_rightViewsArray.count) {
        [view layoutSubviews];
    }
    
    
    [self setupCornerRadiusWithView:view model:model];
    
}

- (void)layoutAutoHeightWidthView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if ([view.autoHeightRatioValue floatValue] > 0) {
        view.height_sd = view.width_sd * [view.autoHeightRatioValue floatValue];
    } else {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.numberOfLines = 0;
            if (label.text.length) {
                if (!label.isAttributedContent) {
                    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(label.width_sd, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                    label.height_sd = rect.size.height;
                } else {
                    [label sizeToFit];
                }
            } else {
                label.height_sd = 0;
            }
        } else {
            view.height_sd = 0;
        }
    }
}

- (void)layoutAutoWidthWidthView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        CGFloat width = [view.sd_maxWidth floatValue] > 0 ? [view.sd_maxWidth floatValue] : MAXFLOAT;
        label.numberOfLines = 1;
        if (label.text.length) {
            if (!label.isAttributedContent) {
                CGRect rect = [label.text boundingRectWithSize:CGSizeMake(width, label.height_sd) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                label.width_sd = rect.size.width;
            } else{
                [label sizeToFit];
                if (label.width_sd > width) {
                    label.width_sd = width;
                }
            }
        } else {
            label.width_sd = 0;
        }
    }
}

- (void)layoutWidthWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.width) {
        view.width_sd = [model.width.value floatValue];
        view.fixedWidth = @(view.width_sd);
    } else if (model.ratio_width) {
        view.width_sd = model.ratio_width.refView.width_sd * [model.ratio_width.value floatValue];
        view.fixedWidth = @(view.width_sd);
    }
}

- (void)layoutHeightWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.height) {
        view.height_sd = [model.height.value floatValue];
        view.fixedHeight = @(view.height_sd);
    } else if (model.ratio_height) {
        view.height_sd = [model.ratio_height.value floatValue] * model.ratio_height.refView.height_sd;
        view.fixedHeight = @(view.height_sd);
    }
}

- (void)layoutLeftWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.left) {
        if (view.superview == model.left.refView) {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd = view.right_sd - [model.left.value floatValue];
            }
            view.left_sd = [model.left.value floatValue];
        } else {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd = view.right_sd - model.left.refView.right_sd - [model.left.value floatValue];
            }
            view.left_sd = model.left.refView.right_sd + [model.left.value floatValue];
        }
        
    } else if (model.equalLeft) {
        if (!view.fixedWidth) {
            if (model.needsAutoResizeView == view.superview) {
                view.width_sd = view.right_sd - (0 + model.equalLeft.offset);
            } else {
                view.width_sd = view.right_sd  - (model.equalLeft.refView.left_sd + model.equalLeft.offset);
            }
        }
        if (view.superview == model.equalLeft.refView) {
            view.left_sd = 0 + model.equalLeft.offset;
        } else {
            view.left_sd = model.equalLeft.refView.left_sd + model.equalLeft.offset;
        }
    } else if (model.equalCenterX) {
        if (view.superview == model.equalCenterX.refView) {
            view.centerX_sd = model.equalCenterX.refView.width_sd * 0.5 + model.equalCenterX.offset;
        } else {
            view.centerX_sd = model.equalCenterX.refView.centerX_sd + model.equalCenterX.offset;
        }
    } else if (model.centerX) {
        view.centerX_sd = [model.centerX floatValue];
    }
}

- (void)layoutRightWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.right) {
        if (view.superview == model.right.refView) {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd = model.right.refView.width_sd - view.left_sd - [model.right.value floatValue];
            }
            view.right_sd = model.right.refView.width_sd - [model.right.value floatValue];
        } else {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd =  model.right.refView.left_sd - view.left_sd - [model.right.value floatValue];
            }
            view.right_sd = model.right.refView.left_sd - [model.right.value floatValue];
        }
    } else if (model.equalRight) {
        if (!view.fixedWidth) {
            if (model.equalRight.refView == view.superview) {
                view.width_sd = model.equalRight.refView.width_sd - view.left_sd + model.equalRight.offset;
            } else {
                view.width_sd = model.equalRight.refView.right_sd - view.left_sd + model.equalRight.offset;
            }
        }
        
        view.right_sd = model.equalRight.refView.right_sd + model.equalRight.offset;
        if (view.superview == model.equalRight.refView) {
            view.right_sd = model.equalRight.refView.width_sd + model.equalRight.offset;
        }
        
    }
}

- (void)layoutTopWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.top) {
        if (view.superview == model.top.refView) {
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height_sd = view.bottom_sd - [model.top.value floatValue];
            }
            view.top_sd = [model.top.value floatValue];
        } else {
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height_sd = view.bottom_sd - model.top.refView.bottom_sd - [model.top.value floatValue];
            }
            view.top_sd = model.top.refView.bottom_sd + [model.top.value floatValue];
        }
    } else if (model.equalTop) {
        if (view.superview == model.equalTop.refView) {
            if (!view.fixedHeight) {
                view.height_sd = view.bottom_sd - model.equalTop.offset;
            }
            view.top_sd = 0 + model.equalTop.offset;
        } else {
            if (!view.fixedHeight) {
                view.height_sd = view.bottom_sd - (model.equalTop.refView.top_sd + model.equalTop.offset);
            }
            view.top_sd = model.equalTop.refView.top_sd + model.equalTop.offset;
        }
    } else if (model.equalCenterY) {
        if (view.superview == model.equalCenterY.refView) {
            view.centerY_sd = model.equalCenterY.refView.height_sd * 0.5 + model.equalCenterY.offset;
        } else {
            view.centerY_sd = model.equalCenterY.refView.centerY_sd + model.equalCenterY.offset;
        }
    } else if (model.centerY) {
        view.centerY_sd = [model.centerY floatValue];
    }
}

- (void)layoutBottomWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.bottom) {
        if (view.superview == model.bottom.refView) {
            if (!view.fixedHeight) {
                view.height_sd = view.superview.height_sd - view.top_sd - [model.bottom.value floatValue];
            }
            view.bottom_sd = model.bottom.refView.height_sd - [model.bottom.value floatValue];
        } else {
            if (!view.fixedHeight) {
                view.height_sd = model.bottom.refView.top_sd - view.top_sd - [model.bottom.value floatValue];
            }
            view.bottom_sd = model.bottom.refView.top_sd - [model.bottom.value floatValue];
        }
        
    } else if (model.equalBottom) {
        if (view.superview == model.equalBottom.refView) {
            if (!view.fixedHeight) {
                view.height_sd = view.superview.height_sd - view.top_sd + model.equalBottom.offset;
            }
            view.bottom_sd = model.equalBottom.refView.height_sd + model.equalBottom.offset;
        } else {
            if (!view.fixedHeight) {
                view.height_sd = model.equalBottom.refView.bottom_sd - view.top_sd + model.equalBottom.offset;
            }
            view.bottom_sd = model.equalBottom.refView.bottom_sd + model.equalBottom.offset;
        }
    }
}


- (void)setupCornerRadiusWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    CGFloat cornerRadius = view.layer.cornerRadius;
    CGFloat newCornerRadius = 0;
    
    if (view.sd_cornerRadius && (cornerRadius != [view.sd_cornerRadius floatValue])) {
        newCornerRadius = [view.sd_cornerRadius floatValue];
    } else if (view.sd_cornerRadiusFromWidthRatio && (cornerRadius != [view.sd_cornerRadiusFromWidthRatio floatValue] * view.width_sd)) {
        newCornerRadius = view.width_sd * [view.sd_cornerRadiusFromWidthRatio floatValue];
    } else if (view.sd_cornerRadiusFromHeightRatio && (cornerRadius != view.height_sd * [view.sd_cornerRadiusFromHeightRatio floatValue])) {
        newCornerRadius = view.height_sd * [view.sd_cornerRadiusFromHeightRatio floatValue];
    }
    
    if (newCornerRadius > 0) {
        view.layer.cornerRadius = newCornerRadius;
        view.clipsToBounds = YES;
    }
}

- (void)addAutoLayoutModel:(SDAutoLayoutModel *)model
{
    [self.autoLayoutModelsArray addObject:model];
}

@end

@implementation UIButton (SDAutoLayoutButton)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *selString = @"layoutSubviews";
        NSString *mySelString = [@"sd_button_" stringByAppendingString:selString];
        
        Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
        Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
        method_exchangeImplementations(originalMethod, myMethod);
    });
}

- (void)sd_button_layoutSubviews
{
    // 如果程序崩溃在这行代码说明是你的view在执行“layoutSubvies”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“layoutSubvies”方法
    [self sd_button_layoutSubviews];
    
    [self sd_layoutSubviewsHandle];
    
}

@end


@implementation UIView (SDChangeFrame)

- (BOOL)shouldReadjustFrameBeforeStoreCache
{
    return self.sd_categoryManager.shouldReadjustFrameBeforeStoreCache;
}

- (void)setShouldReadjustFrameBeforeStoreCache:(BOOL)shouldReadjustFrameBeforeStoreCache
{
    self.sd_categoryManager.shouldReadjustFrameBeforeStoreCache = shouldReadjustFrameBeforeStoreCache;
}

- (CGFloat)left_sd {
    return self.frame.origin.x;
}

- (void)setLeft_sd:(CGFloat)x_sd {
    CGRect frame = self.frame;
    frame.origin.x = x_sd;
    self.frame = frame;
}

- (CGFloat)top_sd {
    return self.frame.origin.y;
}

- (void)setTop_sd:(CGFloat)y_sd {
    CGRect frame = self.frame;
    frame.origin.y = y_sd;
    self.frame = frame;
}

- (CGFloat)right_sd {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight_sd:(CGFloat)right_sd {
    CGRect frame = self.frame;
    frame.origin.x = right_sd - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom_sd {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom_sd:(CGFloat)bottom_sd {
    CGRect frame = self.frame;
    frame.origin.y = bottom_sd - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX_sd
{
    return self.left_sd + self.width_sd * 0.5;
}

- (void)setCenterX_sd:(CGFloat)centerX_sd
{
    self.left_sd = centerX_sd - self.width_sd * 0.5;
}

- (CGFloat)centerY_sd
{
    return self.top_sd + self.height_sd * 0.5;
}

- (void)setCenterY_sd:(CGFloat)centerY_sd
{
    self.top_sd = centerY_sd - self.height_sd * 0.5;
}

- (CGFloat)width_sd {
    return self.frame.size.width;
}

- (void)setWidth_sd:(CGFloat)width_sd {
    if (self.ownLayoutModel.widthEqualHeight) {
        if (width_sd != self.height_sd) return;
    }
    if (self.ownLayoutModel.heightEqualWidth) {
        self.height_sd = width_sd;
    }
    [self setWidth:width_sd];
}

- (CGFloat)height_sd {
    return self.frame.size.height;
}

- (void)setHeight_sd:(CGFloat)height_sd {
    if (self.ownLayoutModel.heightEqualWidth) {
        if (height_sd != self.width_sd) return;
    }
    if (self.ownLayoutModel.widthEqualHeight) {
        self.width_sd = height_sd;
    }
    [self setHeight:height_sd];
}

- (CGPoint)origin_sd {
    return self.frame.origin;
}

- (void)setOrigin_sd:(CGPoint)origin_sd {
    CGRect frame = self.frame;
    frame.origin = origin_sd;
    self.frame = frame;
}

- (CGSize)size_sd {
    return self.frame.size;
}

- (void)setSize_sd:(CGSize)size_sd {
    [self setSize:size_sd];
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

// 兼容旧版本

- (CGFloat)left
{
    return self.left_sd;
}

- (void)setLeft:(CGFloat)left
{
    self.left_sd = left;
}

- (CGFloat)right
{
    return self.right_sd;
}

- (void)setRight:(CGFloat)right
{
    self.right_sd = right;
}

- (CGFloat)width
{
    return self.width_sd;
}

- (CGFloat)height
{
    return self.height_sd;
}

- (CGFloat)top
{
    return self.top_sd;
}

- (void)setTop:(CGFloat)top
{
    self.top_sd = top;
}

- (CGFloat)bottom
{
    return self.bottom_sd;
}

- (void)setBottom:(CGFloat)bottom
{
    self.bottom_sd = bottom;
}

- (CGFloat)centerX
{
    return self.centerX_sd;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.centerX_sd = centerX;
}

- (CGFloat)centerY
{
    return self.centerY_sd;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.centerY_sd = centerY;
}

- (CGPoint)origin
{
    return self.origin_sd;
}

- (void)setOrigin:(CGPoint)origin
{
    self.origin_sd = origin;
}

- (CGSize)size
{
    return self.size_sd;
}

@end

@implementation SDUIViewCategoryManager

@end

