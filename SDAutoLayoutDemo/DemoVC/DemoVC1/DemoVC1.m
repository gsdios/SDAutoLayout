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
    
    
    // 暂时用view替代展示cell效果
    
    self.view0.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 80)
    .widthIs(50)
    .heightIs(50);
    
    // view1使用高度根据子view内容自适应，所以不需要设置高度，而是在后面设置“[self.view1 setupAutoHeightWithBottomView:testView bottomMargin:10];”实现高度根据内容自适应
    self.view1.sd_layout
    .leftSpaceToView(self.view0, 10)
    .topEqualToView(self.view0)
    .rightSpaceToView(self.view, 30);
    
    self.view2.sd_layout
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(self.view1, 20)
    .widthRatioToView(self.view0, 1)
    .heightRatioToView(self.view0, 1);
    
    self.view3.sd_layout
    .rightSpaceToView(self.view2, 10)
    .leftSpaceToView(self.view, 30)
    .heightRatioToView(self.view, 0.17)
    .topEqualToView(self.view2);
    
    self.view4.sd_layout
    .leftEqualToView(self.view0)
    .heightRatioToView(self.view0, 1)
    .widthRatioToView(self.view0, 1)
    .topSpaceToView(self.view3, 20);
    
    self.view5.sd_layout
    .leftEqualToView(self.view1)
    .rightEqualToView(self.view1)
    .bottomSpaceToView(self.view, 20)
    .topEqualToView(self.view4);

//  ============================================================
    
    // 在view1中加入两个子view，然后设置view1高度根据子view内容自适应
    
    
    UILabel *testLabel = [UILabel new];
    UIView *testView = [UIView new];
    [self.view1 addSubview:testLabel];
    [self.view1 addSubview:testView];
    
    testLabel.backgroundColor = [UIColor purpleColor];
    testView.backgroundColor = [UIColor orangeColor];
    
    testLabel.text = @"edflgjl;ijf;iljd;lij;lfk;lknsdfhfg;ljhl;sfdj;oigfj;jgf;lfgjrlkfewiorrgi";
    
    testLabel.sd_layout
    .leftSpaceToView(self.view1, 10)
    .rightSpaceToView(self.view1, 10)
    .topSpaceToView(self.view1, 10)
    .autoHeightRatio(0); // 设置文本内容自适应，如果这里的参数为大于0的数值则会以此数值作为view的高宽比设置view的高度
    
    testView.sd_layout
    .topSpaceToView(testLabel, 10)
    .widthRatioToView(testLabel, 1)
    .heightIs(30)
    .leftEqualToView(testLabel);
    
    // 设置view1高度根据子其内容自适应
    [self.view1 setupAutoHeightWithBottomView:testView bottomMargin:10];
    
//  ============================================================
}

@end
