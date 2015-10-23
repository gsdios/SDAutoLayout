//
//  DemoVC0.m
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

#import "DemoVC0.h"

@implementation DemoVC0

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view0.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view,80)
    .heightIs(130)
    .widthRatioToView(self.view, 0.4);
    
    self.view1.sd_layout
    .leftSpaceToView(self.view0, 10)
    .topEqualToView(self.view0)
    .heightIs(60);
    
    self.view2.sd_layout
    .leftSpaceToView(self.view1, 10)
    .topEqualToView(self.view1)
    .heightRatioToView(self.view1, 1)
    .widthRatioToView(self.view1, 1);
    
    self.view3.sd_layout
    .leftEqualToView(self.view1)
    .topSpaceToView(self.view1, 10)
    .heightRatioToView(self.view1, 1)
    .widthRatioToView(self.view1, 1);
    
    self.view4.sd_layout
    .leftEqualToView(self.view2)
    .topEqualToView(self.view3)
    .heightRatioToView(self.view3, 1)
    .widthRatioToView(self.view1, 1);
    
    
    self.view5.sd_layout
    .topSpaceToView(self.view0, 20)
    .leftEqualToView(self.view0)
    .bottomSpaceToView(self.view, 30);
    
    self.view6.sd_layout
    .leftSpaceToView(self.view5, 10)
    .topEqualToView(self.view5)
    .heightRatioToView(self.view5, 1)
    .widthRatioToView(self.view5, 1);
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat view1W = (self.view.width * 0.6 - 10 * 4) / 2;
    self.view1.sd_layout.widthIs(view1W);
    
    CGFloat view5W = (self.view.width - 30) / 2;
    self.view5.sd_layout.widthIs(view5W);
}


@end

