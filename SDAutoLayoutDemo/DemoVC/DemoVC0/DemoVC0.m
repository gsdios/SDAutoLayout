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

#define kTimeInterval 0.8

@implementation DemoVC0
{
    NSTimer *_timer;
    CGFloat _widthRatio;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _widthRatio = 0.4;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(animation) userInfo:nil repeats:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view0.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view,80)
    .heightIs(130)
    .widthRatioToView(self.view, _widthRatio);
    
    self.view1.sd_layout
    .leftSpaceToView(self.view0, 10)
    .topEqualToView(self.view0)
    .heightIs(60)
    .widthRatioToView(self.view0, 0.5);
    
    self.view2.sd_layout
    .leftSpaceToView(self.view1, 10)
    .topEqualToView(self.view1)
    .heightRatioToView(self.view1, 1)
    .widthIs(50);
    
    self.view3.sd_layout
    .leftEqualToView(self.view1)
    .topSpaceToView(self.view1, 10)
    .heightRatioToView(self.view1, 1)
    .widthRatioToView(self.view1, 1);
    
    self.view4.sd_layout
    .leftEqualToView(self.view2)
    .topEqualToView(self.view3)
    .heightRatioToView(self.view3, 1)
    .widthRatioToView(self.view2, 1);
    
    
    [self.view0 addSubview:self.view5];
    self.view5.sd_layout
    .centerYEqualToView(self.view0)
    .rightSpaceToView(self.view0, 10)
    .widthRatioToView(self.view0, 0.5)
    .heightIs(20);
    
    /** button作为父视图示例 */
    /*
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button1 setTitle:@"一个button" forState:UIControlStateNormal];
    
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button1 setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:button1];
    
    button1.sd_layout
    .centerYEqualToView(self.view)
    .centerXEqualToView(self.view)
    .widthIs(200)
    .heightIs(100);
    
    UIView *buttonSubView = [[UIView alloc]init];
    
    buttonSubView.backgroundColor = [UIColor grayColor];
    
    [button1 addSubview:buttonSubView];
    
    buttonSubView.sd_layout
    .topSpaceToView(button1 , 10)
    .leftSpaceToView(button1 , 10)
    .rightSpaceToView(button1 , 20)
    .heightIs(20);
    
    UIView *buttonSubView2 = [[UIView alloc]init];
    
    buttonSubView2.backgroundColor = [UIColor grayColor];
    
    [button1 addSubview:buttonSubView2];
    
    buttonSubView2.sd_layout
    .topSpaceToView(buttonSubView , 10)
    .leftSpaceToView(button1 , 20)
    .rightSpaceToView(button1 , 10)
    .heightIs(20);
     */
}



- (void)animation
{
    if (_widthRatio >= 0.4) {
        _widthRatio = 0.1;
    } else {
        _widthRatio = 0.4;
    }
    
    // 开启动画
    [UIView animateWithDuration:0.8 animations:^{
        self.view0.sd_layout
        .widthRatioToView(self.view, _widthRatio);
        [self.view0 updateLayout]; // 调用此方法开启view0动画效果
        [self.view5 updateLayout]; // 调用此方法开启view5动画效果
        /*
         调用[self.view0 updateLayout]就可以实现view0和其它兄弟view一起动画，view0和view5是父子关系，如果view0需要动画要再主动调用一次[self.view5 updateLayout]
         */
    }];
    
    
    /*
     
     SDAutoLayout（新建QQ交流群：497140713）
     github:https://github.com/gsdios/SDAutoLayout
     ☆☆ SDAutoLayout 视频教程：http://www.letv.com/ptv/vplay/24038772.html ☆☆
     一行代码搞定自动布局！致力于做最简单易用的Autolayout库。The most easy way for autolayout.
     
     */

}

- (void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
    _timer = nil;
}

@end

