//
//  DemoVC2.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/10/12.
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

#import "DemoVC2.h"

@implementation DemoVC2
{
    UIButton *_centerButton;
    UIView *_autoWidthViewsContainer;
    UIView *_autoMarginViewsContainer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    // 设置自定义图片和label位置的button
    [self setupCustomButton];
    
    // 设置一排固定间距自动宽度子view
    [self setupAutoWidthViewsWithCount:4 margin:10];
    
    // 设置一排固定宽度自动间距子view
    [self setupAutoMarginViewsWithCount:4 itemWidth:80];
}

// 设置自定义图片和label位置的button
- (void)setupCustomButton
{
    _centerButton = [UIButton new];
    _centerButton.backgroundColor = [UIColor orangeColor];
    [_centerButton setTitle:@"自定义Button" forState:UIControlStateNormal];
    [_centerButton setImage:[UIImage imageNamed:@"7.jpg"] forState:UIControlStateNormal];
    _centerButton.titleLabel.backgroundColor = [UIColor lightGrayColor];
    _centerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _centerButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_centerButton];
    
    
    _centerButton.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 10)
    .widthRatioToView(self.view, 0.5)
    .heightIs(120);
    

    
    // 设置button的图片的约束
    _centerButton.imageView.sd_layout
    .widthRatioToView(_centerButton, 0.8)
    .topSpaceToView(_centerButton, 10)
    .centerXEqualToView(_centerButton)
    .heightRatioToView(_centerButton, 0.6);
    
    // 设置button的label的约束
    _centerButton.titleLabel.sd_layout
    .topSpaceToView(_centerButton.imageView, 10)
    .leftEqualToView(_centerButton.imageView)
    .rightEqualToView(_centerButton.imageView)
    .bottomSpaceToView(_centerButton, 10);
}

// 设置一排固定间距自动宽度子view
- (void)setupAutoWidthViewsWithCount:(NSInteger)count margin:(CGFloat)margin
{
    _autoWidthViewsContainer = [UIView new];
    _autoWidthViewsContainer.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_autoWidthViewsContainer];
    
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor orangeColor];
        [_autoWidthViewsContainer addSubview:view];
        view.sd_layout.autoHeightRatio(0.4); // 设置高度约束
        [temp addObject:view];
    }
    
    _autoWidthViewsContainer.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(_centerButton, 10);
    
    // 此步设置之后_autoWidthViewsContainer的高度可以根据子view自适应
    [_autoWidthViewsContainer setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:4 verticalMargin:margin horizontalMargin:margin verticalEdgeInset:5 horizontalEdgeInset:10];
    
}

// 设置一排固定宽度自动间距子view
- (void)setupAutoMarginViewsWithCount:(NSInteger)count itemWidth:(CGFloat)itemWidth
{
    _autoMarginViewsContainer = [UIView new];
    _autoMarginViewsContainer.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_autoMarginViewsContainer];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor orangeColor];
        [_autoMarginViewsContainer addSubview:view];
        view.sd_layout.autoHeightRatio(0.5); // 设置高度约束
        [temp addObject:view];
    }
    
    // 此步设置之后_autoMarginViewsContainer的高度可以根据子view自适应
    [_autoMarginViewsContainer setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:3 itemWidth:itemWidth verticalMargin:10 verticalEdgeInset:4 horizontalEdgeInset:10];
    
    _autoMarginViewsContainer.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(_autoWidthViewsContainer, 10);
}








/*
 
 // ------------------设置3个水平等宽子view----------------
 
 self.view.sd_equalWidthSubviews = @[self.view0, self.view1, self.view2];
 
 self.view0.sd_layout
 .leftSpaceToView(self.view, 0)      // 左边距父view为0
 .topSpaceToView(self.view, 100)     // 上边距离父view为100
 .heightEqualToWidth();              // 高度等于自身宽度
 
 self.view1.sd_layout
 .leftSpaceToView(self.view0, 0)     // 左边距离view0为0
 .topEqualToView(self.view0)         // top和view0相同
 .heightEqualToWidth();              // 高度等于自身宽度
 
 self.view2.sd_layout
 .leftSpaceToView(self.view1, 0)     // 左边距离view1为0
 .topEqualToView(self.view1)         // top和view1相同
 .rightSpaceToView(self.view, 0)     // 右边距离父view为0
 .heightEqualToWidth();              // 高度等于自身宽度
 
 // ------------------------------------------------------
 
 */

@end
