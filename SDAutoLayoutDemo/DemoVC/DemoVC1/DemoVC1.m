//
//  DemoVC1.m
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

#import "DemoVC1.h"

@implementation DemoVC1

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*  
     
     设置view1高度根据子view而自适应(在view1中加入两个子view(testLabel和testView)，然后设置view1高度根据子view内容自适应)
     */
    
    

    UILabel *testLabel_subview1 = [UILabel new]; // 初始化子view1
    testLabel_subview1.text = @"这个紫色的label会根据这些文字内容高度自适应；而这个灰色的父view会根据紫色的label和橙色的view具体情况实现高度自适应。\nGot it! OH YAEH!";
    testLabel_subview1.backgroundColor = [UIColor purpleColor];
    
    UIView *testView_subview2 = [UIView new];    // 初始化子view2
    testView_subview2.backgroundColor = [UIColor orangeColor];
    
    // 将子view添加进父view
    [self.view1 sd_addSubviews:@[testLabel_subview1, testView_subview2]];
    
    
    testLabel_subview1.sd_layout
    .leftSpaceToView(self.view1, 10)
    .rightSpaceToView(self.view1, 10)
    .topSpaceToView(self.view1, 10)
    .autoHeightRatio(0); // 设置文本内容自适应，如果这里的参数为大于0的数值则会以此数值作为view的高宽比设置view的高度
    
    testView_subview2.sd_layout
    .topSpaceToView(testLabel_subview1, 10)
    .widthRatioToView(testLabel_subview1, 1)
    .heightIs(30)
    .leftEqualToView(testLabel_subview1);
    
    
    // view1使用高度根据子view内容自适应，所以不需要设置高度，而是设置“[self.view1 setupAutoHeightWithBottomView:testView bottomMargin:10];”实现高度根据内容自适应
    self.view1.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 80)
    .rightSpaceToView(self.view, 10);
    
    // 设置view1高度根据子其内容自适应
    [self.view1 setupAutoHeightWithBottomView:testView_subview2 bottomMargin:10];
    
    
}

@end
