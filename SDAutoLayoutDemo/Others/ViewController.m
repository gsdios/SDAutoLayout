//
//  ViewController.m
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

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupDemoViews];
}


- (void)setupDemoViews
{
    UIView *view0 = [UIView new];
    view0.backgroundColor = [UIColor redColor];
    self.view0 = view0;
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor grayColor];
    self.view1 = view1;
    
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor brownColor];
    self.view2 = view2;
    
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor orangeColor];
    self.view3 = view3;
    
    UIView *view4 = [UIView new];
    view4.backgroundColor = [UIColor purpleColor];
    self.view4 = view4;
    
    UIView *view5 = [UIView new];
    view5.backgroundColor = [UIColor yellowColor];
    self.view5 = view5;
    
    UIView *view6 = [UIView new];
    view6.backgroundColor = [UIColor cyanColor];
    self.view6 = view6;
    
    UIView *view7 = [UIView new];
    view7.backgroundColor = [UIColor magentaColor];
    self.view7 = view7;
    
    UIView *view8 = [UIView new];
    view8.backgroundColor = [UIColor blackColor];
    self.view8 = view8;
    
    [self.view addSubview:view0];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:view4];
    [self.view addSubview:view5];
    [self.view addSubview:view6];
    [self.view addSubview:view7];
    [self.view addSubview:view8];
}


@end
