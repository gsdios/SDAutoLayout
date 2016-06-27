//
//  DemoVC12.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/3/18.
//  Copyright © 2016年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * 持续更新地址: https://github.com/gsdios/SDAutoLayout                              *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 * QQ交流群：519489682（一群）497140713（二群）                                       *
 *********************************************************************************
 
 */



#import "DemoVC12.h"

#import "UIView+SDAutoLayout.h"

@implementation DemoVC12
{
    UIScrollView *_scrollView;
    
    UIView *_flowItemContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupScrollView];
}


// 添加scrollview
- (void)setupScrollView
{
    UIScrollView *scroll = [UIScrollView new];
    [self.view addSubview:scroll];
    _scrollView = scroll;
    
    // 设置scrollview与父view的边距
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupFlowItemContentView];
    
    // 设置scrollview的contentsize自适应
    [scroll setupAutoContentSizeWithBottomView:_flowItemContentView bottomMargin:10];
}


// 添加flowItemContentView
- (void)setupFlowItemContentView
{
    _flowItemContentView = [UIView new];
    _flowItemContentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    [_scrollView addSubview:_flowItemContentView];
    
    _flowItemContentView.sd_layout
    .leftEqualToView(_scrollView)
    .rightEqualToView(_scrollView)
    .topEqualToView(_scrollView);
    
    [self setupFlowItemViews];
}



- (void)setupFlowItemViews
{
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 35; i++) {
        UIView *view = [UIView new];
        view.backgroundColor = [self randomColor];
        [_flowItemContentView addSubview:view];
        view.sd_layout.autoHeightRatio(0.8);
        [temp addObject:view];
    }
    
    // 关键步骤：设置类似collectionView的展示效果
    [_flowItemContentView setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:3 verticalMargin:10 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
}


- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
























/*

// 设置scrollview的第一个子深粉色view（包含左边一个label、右边一个button的深粉色view，这个view根据label文字高度自适应）
- (void)setupScrollViewSubView1
{
    // 深粉色view
    UIView *container = [UIView new];
    container.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [_scrollView addSubview:container];
    _subview1 = container;
    
    
    // 深粉色view第一个子view：左边的lable
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = @"我是SDAutoLayout，你是谁？么么哒！";
    _subview1_label = leftLabel;
    
    // 深粉色view第二个子view：白色文字button
    UIButton *rightButton = [UIButton new];
    [rightButton setTitle:@"添加文字" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(subView1ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [container sd_addSubviews:@[leftLabel, rightButton]];
    
    leftLabel.sd_layout
    .leftSpaceToView(container, 10)
    .rightSpaceToView(container, 100)
    .topSpaceToView(container, 10)
    .autoHeightRatio(0); // 此行设置label文字自适应
    
    rightButton.sd_layout
    .bottomEqualToView(container)
    .rightSpaceToView(container, 10)
    .widthIs(80)
    .heightIs(20);

    
    container.sd_layout
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .topSpaceToView(_scrollView, 10);
    [container setupAutoHeightWithBottomView:leftLabel bottomMargin:10]; // 设置深粉色view根据label的具体内容而自适应
}


- (void)setupScrollViewSubView2
{
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@" 共有%lu个字符 ", [_subview1_label.text length]];
    label.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    _subview2 = label;
    [_scrollView addSubview:label];
    
    label.sd_layout
    .topSpaceToView(_subview1, 10)
    .centerXEqualToView(_subview1)
    .heightIs(30);
    [label setSingleLineAutoResizeWithMaxWidth:400];
}

- (void)setupScrollViewSubView3
{
    UIView *red = [UIView new];
    red.backgroundColor = [UIColor redColor];
    _redView = red;
    
    UIView *green = [UIView new];
    green.backgroundColor = [UIColor greenColor];
    
    UIView *blue = [UIView new];
    blue.backgroundColor = [UIColor blueColor];
    
    [_scrollView sd_addSubviews:@[red, green, blue]];
    
    // 设置scrollview底部三个等宽子view（红绿蓝三个view）
    _scrollView.sd_equalWidthSubviews = @[red, green, blue];
    
    red.sd_layout
    .leftSpaceToView(_scrollView, 20) // 设置redview的左边距
    .topSpaceToView(_subview2, 20)
    .heightEqualToWidth();
    
    green.sd_layout
    .leftSpaceToView(red, 20) // 设置greenview的左边距
    .topEqualToView(red)
    .heightEqualToWidth();
    
    blue.sd_layout
    .leftSpaceToView(green, 20) // 设置blueview的左边距
    .topEqualToView(red)
    .rightSpaceToView(_scrollView, 20) // 设置blueview的右边距
    .heightEqualToWidth();
}


- (void)subView1ButtonClicked
{
    NSString *addStr = [NSString stringWithFormat:@"新增文字，发生时间：%@", [[NSDate date] descriptionWithLocale:nil]];
    _subview1_label.text = [NSString stringWithFormat:@"%@     ---> %@", _subview1_label.text, addStr];
    [_subview1_label updateLayout];
    
    _subview2.text = [NSString stringWithFormat:@" 共有%lu个字符 ", [_subview1_label.text length]];
    
    if (_scrollView.contentSize.height > _scrollView.height) {
        CGPoint point = _scrollView.contentOffset;
        point.y = _scrollView.contentSize.height - _scrollView.height;
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentOffset = point;
        }];
    }
}

*/

@end
