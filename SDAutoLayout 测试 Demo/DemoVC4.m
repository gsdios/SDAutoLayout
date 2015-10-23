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
    .heightIs(80);
    
    self.view3.sd_layout
    .topEqualToView(self.view2)
    .leftSpaceToView(self.view2, 10)
    .heightRatioToView(self.view2, 1)
    .rightEqualToView(self.view1);
    
    self.view4.sd_layout
    .leftEqualToView(self.view2)
    .topSpaceToView(self.view2, 20)
    .bottomSpaceToView(self.view, 30)
    .widthRatioToView(self.view1, 0.7);
    
    self.view5.sd_layout
    .leftSpaceToView(self.view4, 10)
    .rightEqualToView(self.view1)
    .heightRatioToView(self.view4, 1)
    .topEqualToView(self.view4);
    
}

@end
