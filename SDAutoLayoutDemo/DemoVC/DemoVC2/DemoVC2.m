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

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    
    
    
    self.view3.sd_layout
    .widthIs(50)
    .heightEqualToWidth()
    .centerYEqualToView(self.view)
    .centerXEqualToView(self.view);
    
}


@end
