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
    
    self.view1.sd_layout
    .leftSpaceToView(self.view0, 10)
    .topEqualToView(self.view0)
    .rightSpaceToView(self.view, 30)
    .heightRatioToView(self.view, 0.2);
    
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
    
    self.view5.tag = 19999;
}

@end
