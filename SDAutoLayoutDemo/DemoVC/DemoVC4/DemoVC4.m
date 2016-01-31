//
//  DemoVC4.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/10/16.
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

#import "DemoVC4.h"

@implementation DemoVC4


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view0.sd_layout
    .widthIs(50)
    .heightIs(50)
    .topSpaceToView(self.view, 80)
    .leftSpaceToView(self.view, 20);
    
    self.view1.sd_layout
    .topEqualToView(self.view0)
    .leftSpaceToView(self.view0, 20)
    .rightSpaceToView(self.view, 20)
    .heightRatioToView(self.view0, 0.4);
    
    
    self.view2.sd_layout
    .topSpaceToView(self.view1, 20)
    .widthRatioToView(self.view1, 0.45)
    .leftEqualToView(self.view1)
    .heightIs(40);
    
    self.view3.sd_layout
    .topEqualToView(self.view2)
    .leftSpaceToView(self.view2, 10)
    .heightRatioToView(self.view2, 1)
    .rightEqualToView(self.view1);
    
    self.view4.sd_layout
    .leftEqualToView(self.view2)
    .topSpaceToView(self.view2, 20)
    .heightRatioToView(self.view, 0.05)
    .widthRatioToView(self.view1, 0.7);
    
    self.view5.sd_layout
    .leftSpaceToView(self.view4, 10)
    .rightEqualToView(self.view1)
    .heightRatioToView(self.view4, 1)
    .topEqualToView(self.view4);
    
    
//  --------- attributedString测试：行间距为8 ---------------------------
    
    NSString *text = @"attributedString测试：行间距为8。彩虹网络卡福利费绿调查开房；卡法看得出来分开了的出口来反馈率打开了房；快烦死了；了； 调查开房；；v单纯考虑分离开都快来反馈来看发v离开的积分房积分jdhflgfkkvvm.cm。";
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    UIColor *color = [UIColor blackColor];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName: paragraphStyle}];
    
    
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    label.attributedText = string;
    
    label.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(self.view4, 10)
    .autoHeightRatio(0);
    
    // 标注lable的text为attributedString
    label.isAttributedContent = YES;
    
//  --------- attributedString测试：行间距为8 ---------------------------
    
}

@end
