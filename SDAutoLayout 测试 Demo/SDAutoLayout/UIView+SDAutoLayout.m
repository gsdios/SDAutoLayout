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

#import <objc/runtime.h>

@interface SDAutoLayoutModel ()

@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *left;
@property (nonatomic, strong) NSNumber *top;
@property (nonatomic, strong) NSNumber *right;
@property (nonatomic, strong) NSNumber *bottom;
@property (nonatomic, strong) NSNumber *centerX;
@property (nonatomic, strong) NSNumber *centerY;

@property (nonatomic, strong) NSNumber *ratio_width;
@property (nonatomic, strong) NSNumber *ratio_height;
@property (nonatomic, strong) NSNumber *ratio_left;
@property (nonatomic, strong) NSNumber *ratio_top;
@property (nonatomic, strong) NSNumber *ratio_right;
@property (nonatomic, strong) NSNumber *ratio_bottom;

@property (nonatomic, assign) BOOL equalLeft;
@property (nonatomic, assign) BOOL equalRight;
@property (nonatomic, assign) BOOL equalTop;
@property (nonatomic, assign) BOOL equalBottom;
@property (nonatomic, assign) BOOL equalCenterX;
@property (nonatomic, assign) BOOL equalCenterY;

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

- (void)addLayoutModelToSuperView
{
    if (self.needsAutoResizeView.superview == self.referencedView) {
        [self.referencedView.autoLayoutModelsArray addObject:self];
    } else {
        [self.referencedView.superview.autoLayoutModelsArray addObject:self];
        if (!self.referencedView) {
            [self.needsAutoResizeView.superview.autoLayoutModelsArray addObject:self];
        }
    }
}

- (void)addLayoutModelWithWidthHeightAttributeToSuperView
{
    if (self.needsAutoResizeView.superview == self.referencedView) {
        [self.referencedView addLayoutModelWithAttributeHeightOrWidth:self];
    } else {
        [self.referencedView.superview addLayoutModelWithAttributeHeightOrWidth:self];
    }
}

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
        weakSelf.referencedView = view;
        [weakSelf setValue:@(value) forKey:key];
        [weakSelf addLayoutModelToSuperView];
        
#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒
        
        [weakSelf.needsAutoResizeView addOwnAutoLayoutModel:weakSelf withKey:key];
        
#endif
        
        SDAutoLayoutModel *newModel = [SDAutoLayoutModel new];
        newModel.needsAutoResizeView = weakSelf.needsAutoResizeView;
        return newModel;
    };
}

- (WidthHeight)widthIs
{
    if (!_widthIs) {
        __weak typeof(self) weakSelf = self;
        _widthIs = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.width = value;
            weakSelf.needsAutoResizeView.fixedWith = @(value);
            
#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒
            
            [weakSelf.needsAutoResizeView addOwnAutoLayoutModel:weakSelf withKey:@"width"];
            
#endif
            
            SDAutoLayoutModel *newModel = [SDAutoLayoutModel new];
            newModel.needsAutoResizeView = weakSelf.needsAutoResizeView;
            return newModel;
        };
    }
    return _widthIs;
}

- (WidthHeight)heightIs
{
    if (!_heightIs) {
        __weak typeof(self) weakSelf = self;
        _heightIs = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.height = value;
            weakSelf.needsAutoResizeView.fixedHeight = @(value);
            
#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒
            
            [weakSelf.needsAutoResizeView addOwnAutoLayoutModel:weakSelf withKey:@"height"];
            
#endif
            
            SDAutoLayoutModel *newModel = [SDAutoLayoutModel new];
            newModel.needsAutoResizeView = weakSelf.needsAutoResizeView;
            return newModel;
        };
    }
    return _heightIs;
}

- (WidthHeightEqualToView)widthRatioToView
{
    if (!_widthRatioToView) {
        __weak typeof(self) weakSelf = self;
        _widthRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.referencedView = view;
            weakSelf.ratio_width = @(value);
            [weakSelf addLayoutModelWithWidthHeightAttributeToSuperView];
            
#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒
            
            [weakSelf.needsAutoResizeView addOwnAutoLayoutModel:weakSelf withKey:@"width"];
            
#endif
            
            SDAutoLayoutModel *newModel = [SDAutoLayoutModel new];
            newModel.needsAutoResizeView = weakSelf.needsAutoResizeView;
            return newModel;
        };
    }
    return _widthRatioToView;
}

- (WidthHeightEqualToView)heightRatioToView
{
    if (!_heightRatioToView) {
        __weak typeof(self) weakSelf = self;
        _heightRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.referencedView = view;
            weakSelf.ratio_height = @(value);
            [weakSelf addLayoutModelWithWidthHeightAttributeToSuperView];
            
#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒
            
            [weakSelf.needsAutoResizeView addOwnAutoLayoutModel:weakSelf withKey:@"height"];
            
#endif
            
            SDAutoLayoutModel *newModel = [SDAutoLayoutModel new];
            newModel.needsAutoResizeView = weakSelf.needsAutoResizeView;
            return newModel;
        };
    }
    return _heightRatioToView;
}


- (MarginEqualToView)marginEqualToViewBlockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view) {
        weakSelf.referencedView = view;
        [weakSelf setValue:@(YES) forKey:key];
        [weakSelf addLayoutModelToSuperView];
        
#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒
        
        [weakSelf.needsAutoResizeView addOwnAutoLayoutModel:weakSelf withKey:key];
        
#endif
        
        SDAutoLayoutModel *newModel = [SDAutoLayoutModel new];
        newModel.needsAutoResizeView = weakSelf.needsAutoResizeView;
        return newModel;
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
            weakSelf.needsAutoResizeView.left = value;
        } else if ([key isEqualToString:@"y"]) {
            weakSelf.needsAutoResizeView.top = value;
        } else if ([key isEqualToString:@"centerX"]) {
            weakSelf.centerX = @(value);
            [weakSelf addLayoutModelToSuperView];
        } else if ([key isEqualToString:@"centerY"]) {
            weakSelf.centerY = @(value);
            [weakSelf addLayoutModelToSuperView];
        }
        
#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒
        
        [weakSelf.needsAutoResizeView addOwnAutoLayoutModel:weakSelf withKey:key];
        
#endif

        SDAutoLayoutModel *newModel = [SDAutoLayoutModel new];
        newModel.needsAutoResizeView = weakSelf.needsAutoResizeView;
        return newModel;
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

@end

@implementation UIView (SDAutoLayout)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method layoutSubviews = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method sd_autolayout = class_getInstanceMethod(self, @selector(sd_autolayout));
        method_exchangeImplementations(layoutSubviews, sd_autolayout);
    });
}

#pragma mark - properties

- (void)addLayoutModelWithAttributeHeightOrWidth:(SDAutoLayoutModel *)model
{

    __block long index = 0;
    __block BOOL found = NO;
    [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(SDAutoLayoutModel *obj, NSUInteger idx, BOOL *stop) {
        if (obj.needsAutoResizeView == model.needsAutoResizeView) {
            index = idx;
            found = YES;
            *stop = YES;
        }
    }];
    
    if (found) {
        [self.autoLayoutModelsArray insertObject:model atIndex:index];
    } else {
        [self.autoLayoutModelsArray addObject:model];
    }


    
}

- (NSMutableArray *)autoLayoutModelsArray
{
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSNumber *)fixedWith
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedWith:(NSNumber *)fixedWith
{
    objc_setAssociatedObject(self, @selector(fixedWith), fixedWith, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)fixedHeight
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedHeight:(NSNumber *)fixedHeight
{
    objc_setAssociatedObject(self, @selector(fixedHeight), fixedHeight, OBJC_ASSOCIATION_RETAIN);
}

- (SDAutoLayoutModel *)sd_layout
{
    SDAutoLayoutModel *model = [SDAutoLayoutModel new];
    model.needsAutoResizeView = self;
    
    return model;
}

- (void)sd_autolayout
{
    [self sd_autolayout];
    
    if (self.autoLayoutModelsArray.count) {
        [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(SDAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
            [self sd_resizeWithModel:model];
        }];
    }
    
#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒
    
    [self.subviews makeObjectsPerformSelector:@selector(checkAutoLayoutIntegrality)];
    
#endif
}

- (void)sd_resizeWithModel:(SDAutoLayoutModel *)model
{
    UIView *view = model.needsAutoResizeView;
    
    if (model.width) {
        view.width = [model.width floatValue];
        view.fixedWith = @(view.width);
    } else if (model.ratio_width) {
        view.width = model.referencedView.width * [model.ratio_width floatValue];
        view.fixedWith = @(view.width);
    }
    
    if (model.height) {
        view.height = [model.height floatValue];
        view.fixedHeight = @(view.height);
    } else if (model.ratio_height) {
        view.height = [model.ratio_height floatValue] * model.referencedView.height;
        view.fixedHeight = @(view.height);
    }
    
    if (model.left) {
        if (view.superview == model.referencedView) {
            if (!view.fixedWith) { // view.autoLeft && view.autoRight
                view.width = view.right - [model.left floatValue];
            }
            view.left = [model.left floatValue];
        } else {
            if (!view.fixedWith) { // view.autoLeft && view.autoRight
                view.width = view.right - model.referencedView.right - [model.left floatValue];
            }
            view.left = model.referencedView.right + [model.left floatValue];
        }
        
    } else if (model.equalLeft) {
        if (!view.fixedWith) {
            view.width = view.right - model.referencedView.left;
        }
        if (view.superview == model.referencedView) {
            view.left = 0;
        } else {
            view.left = model.referencedView.left;
        }
    } else if (model.equalCenterX) {
        if (view.superview == model.referencedView) {
            view.centerX = model.referencedView.width * 0.5;
        } else {
            view.centerX = model.referencedView.centerX;
        }
    } else if (model.centerX) {
        view.centerX = [model.centerX floatValue];
    }
    
    if (model.right) {
        if (view.superview == model.referencedView) {
            if (!view.fixedWith) { // view.autoLeft && view.autoRight
                view.width = model.referencedView.width - view.left - [model.right floatValue];
            }
            view.right = model.referencedView.width - [model.right floatValue];
        } else {
            if (!view.fixedWith) { // view.autoLeft && view.autoRight
                view.width =  model.referencedView.left - view.left - [model.right floatValue];
            }
            view.right = model.referencedView.left - [model.right floatValue];
        }
    } else if (model.equalRight) {
        if (!view.fixedWith) {
            view.width = model.referencedView.right - view.left;
        }
        
        view.right = model.referencedView.right;
        if (view.superview == model.referencedView) {
            view.right = model.referencedView.width;
        }
        
    }
    
    if (model.top) {
        if (view.superview == model.referencedView) {
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height = view.bottom - [model.top floatValue];
            }
            view.top = [model.top floatValue];
        } else {
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height = view.bottom - model.referencedView.bottom - [model.top floatValue];
            }
            view.top = model.referencedView.bottom + [model.top floatValue];
        }
    } else if (model.equalTop) {
        if (view.superview == model.referencedView) {
            if (!view.fixedHeight) {
                view.height = view.bottom;
            }
            view.top = 0;
        } else {
            if (!view.fixedHeight) {
                view.height = view.bottom - model.referencedView.top;
            }
            view.top = model.referencedView.top;
        }
    } else if (model.equalCenterY) {
        if (view.superview == model.referencedView) {
            view.centerY = model.referencedView.height * 0.5;
        } else {
            view.centerY = model.referencedView.centerY;
        }
    } else if (model.centerY) {
        view.centerY = [model.centerY floatValue];
    }
    
    if (model.bottom) {
        if (view.superview == model.referencedView) {
            if (!view.fixedHeight) {
                view.height = view.superview.height - view.top - [model.bottom floatValue];
            }
            view.bottom = model.referencedView.height - [model.bottom floatValue];
        } else {
            if (!view.fixedHeight) {
                view.height = model.referencedView.top - view.top - [model.bottom floatValue];
            }
            view.bottom = model.referencedView.top - [model.bottom floatValue];
        }
        
    } else if (model.equalBottom) {
        if (view.superview == model.referencedView) {
            if (!view.fixedHeight) {
                view.height = view.superview.height - view.top;
            }
            view.bottom = model.referencedView.height;
        } else {
            if (!view.fixedHeight) {
                view.height = model.referencedView.bottom - view.top;
            }
            view.bottom = model.referencedView.bottom;
        }
    }
    
}

- (void)addAutoLayoutModel:(SDAutoLayoutModel *)model
{
    [self.autoLayoutModelsArray addObject:model];
}


#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒

#define SDAutoLayoutAttributeLeftKey        @"水平方向约束（left）"
#define SDAutoLayoutAttributeRightKey       @"水平方向约束（right）"
#define SDAutoLayoutAttributeTopKey         @"垂直方向约束（top）"
#define SDAutoLayoutAttributeBottomKey      @"垂直方向约束（bottom）"
#define SDAutoLayoutAttributeWidthKey       @"宽度约束（width）"
#define SDAutoLayoutAttributeHeightKey      @"高度约束（height）"

- (void)addOwnAutoLayoutModel:(SDAutoLayoutModel *)model withKey:(NSString *)key
{
    NSDictionary *modelDict = nil;
    
    if ([key rangeOfString:@"left" options:NSCaseInsensitiveSearch].length || [key rangeOfString:@"centerX" options:NSCaseInsensitiveSearch].length) {
        modelDict = @{SDAutoLayoutAttributeLeftKey : model};
    } else if ([key rangeOfString:@"right" options:NSCaseInsensitiveSearch].length) {
        modelDict = @{SDAutoLayoutAttributeRightKey : model};
    } else if ([key rangeOfString:@"top" options:NSCaseInsensitiveSearch].length || [key rangeOfString:@"centerY" options:NSCaseInsensitiveSearch].length) {
        modelDict = @{SDAutoLayoutAttributeTopKey : model};
    } else if ([key rangeOfString:@"bottom" options:NSCaseInsensitiveSearch].length) {
        modelDict = @{SDAutoLayoutAttributeBottomKey : model};
    } else if ([key rangeOfString:@"width" options:NSCaseInsensitiveSearch].length) {
        modelDict = @{SDAutoLayoutAttributeWidthKey : model};
    } else if ([key rangeOfString:@"height" options:NSCaseInsensitiveSearch].length) {
        modelDict = @{SDAutoLayoutAttributeHeightKey : model};
    }
    if (!modelDict) return;
    [[self ownAutoLayoutModelsArray] addObject:modelDict];
}

- (NSMutableArray *)ownAutoLayoutModelsArray
{
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)checkAutoLayoutIntegrality
{
    if ([self ownAutoLayoutModelsArray].count && [self ownAutoLayoutModelsArray].count < 4) {
        NSString *strStsrt = @"\n\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>（缺少约束）>>>>>>>>>>>>>>>>>>>>>>>>>>> \n\n";
        NSString *strEnd   = @"\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n";
        
        NSMutableString *layoutString = [NSMutableString stringWithString:@"\n 您需要同时设置4个维度的约束，请根据LOG信息检查并修改：\n\n 已经存在的约束：\n"];
        
        [[self ownAutoLayoutModelsArray] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            [layoutString appendFormat:@" ---- %@ ---- %@\n", [dict.allKeys firstObject], [dict.allValues firstObject]];
            SDAutoLayoutModel *model = [dict.allValues firstObject];
            if (model.referencedView == self) {
                [layoutString appendFormat:@" ^^^^ %@ 此条约束引用的view为自身，请检查并修改\n", model];
            }
        }];
        
        NSLog(@"%@ %@\n%@%@",strStsrt, self, layoutString, strEnd);
        
    } else if ([self ownAutoLayoutModelsArray].count > 4) {
        NSString *strStsrt = @"\n\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>（约束冲突）>>>>>>>>>>>>>>>>>>>>>>>>>>> \n\n";
        NSString *strEnd   = @"\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n";
        
        NSMutableString *layoutString = [NSMutableString stringWithString:@"\n 您只需要设置4个维度的约束，请根据LOG信息检查并修改：\n\n 已经存在的约束：\n"];
        
        [[self ownAutoLayoutModelsArray] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            [layoutString appendFormat:@" ---- %@ ---- %@\n", [dict.allKeys firstObject], [dict.allValues firstObject]];
            SDAutoLayoutModel *model = [dict.allValues firstObject];
            if (model.referencedView == self) {
                [layoutString appendFormat:@" ^^^^ %@ 此条约束引用的view为自身，请检查并修改\n", model];
            }
        }];
        
        NSLog(@"%@ %@\n%@%@",strStsrt, self, layoutString, strEnd);
    } else {
        [[self ownAutoLayoutModelsArray] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            SDAutoLayoutModel *model = [dict.allValues firstObject];
            if (model.referencedView == self) {
                NSLog(@"\n -- %@ -- %@ 此条约束引用的view为自身，请检查并修改\n", model.needsAutoResizeView, [[dict allKeys] firstObject]);
            }
        }];
    }
}

#endif

#if defined DEBUG && defined SDAutoLayoutIssueLog // 调试状态下 约束问题提醒

#endif

@end


@implementation UIView (SDChangeFrame)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.left + self.width * 0.5;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.left = centerX - self.width * 0.5;
}

- (CGFloat)centerY
{
    return self.top + self.height * 0.5;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.top = centerY - self.height * 0.5;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
