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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view0.sd_layout
    .centerXIs(100)
    .centerYIs(100)
    .heightIs(50)
    .widthIs(50);
    
    self.view1.sd_layout
    .xIs(100)
    .yIs(100)
    .heightIs(100)
    .widthIs(100);
    
//    self.view0.sd_layout
//    .leftSpaceToView(self.view, 10)
//    .topSpaceToView(self.view,80)
//    .heightIs(130)
//    .widthRatioToView(self.view, 0.4);
//    
//    self.view1.sd_layout
//    .leftSpaceToView(self.view0, 10)
//    .topEqualToView(self.view0)
//    .heightIs(60);
//    
//    self.view2.sd_layout
//    .leftSpaceToView(self.view1, 10)
//    .topEqualToView(self.view1)
//    .heightRatioToView(self.view1, 1)
//    .widthRatioToView(self.view1, 1);
//    
//    self.view3.sd_layout
//    .leftEqualToView(self.view1)
//    .topSpaceToView(self.view1, 10)
//    .heightRatioToView(self.view1, 1)
//    .widthRatioToView(self.view1, 1);
//    
//    self.view4.sd_layout
//    .leftEqualToView(self.view2)
//    .topEqualToView(self.view3)
//    .heightRatioToView(self.view3, 1)
//    .widthRatioToView(self.view1, 1);
//    
//    
//    self.view5.sd_layout
//    .topSpaceToView(self.view0, 20)
//    .leftEqualToView(self.view0)
//    .bottomSpaceToView(self.view, 30);
//    
//    self.view6.sd_layout
//    .leftSpaceToView(self.view5, 10)
//    .topEqualToView(self.view5)
//    .heightRatioToView(self.view5, 1)
//    .widthRatioToView(self.view5, 1);
}



/*
 Q：这里为什么要在 viewWillLayoutSubviews 里计算宽度？
 
 A：大多情况下的布局需求是不需要在 viewWillLayoutSubviews 里计算宽度，只需要直接一次设置
    就可以了（例如其他的demo案例）。
 
   1.为什么这个界面要计算view5的宽度？
 
     因为这个界面的布局要求（以view5 和 view6 为例）是：view5 距离屏幕
    左边10，view6 距离 view5 10， view6 距离屏幕右边10 ，view5 和 view6 宽度相同，这样一来就需要
    确定 view5 的宽度供 view6 参考，所以要计算下 view5 的宽度。
 
   2.在以上的情形中计算view5宽度理解了，那为什么是要在 viewWillLayoutSubviews 里计算宽度？
 
     如果app需要【同时适配横竖屏】，则在横竖屏幕切换时屏幕的宽高对调，那么就需要再计算一次view5的宽度，而切换屏幕时 在viewWillLayoutSubviews 拿到的self.view的宽度才是正确的（因为viewdidload只是在view初始化完成并加
    载出来时调用一次，以后切换屏幕不再调用），如果app不需要同时适配
    横竖屏则不需要此步骤。
 
 
 */
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    CGFloat view1W = (self.view.width * 0.6 - 10 * 4) / 2;
//    self.view1.sd_layout.widthIs(view1W);
//    
//    CGFloat view5W = (self.view.width - 30) / 2;
//    self.view5.sd_layout.widthIs(view5W);
}


@end

