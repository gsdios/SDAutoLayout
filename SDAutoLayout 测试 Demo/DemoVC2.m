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
    
    [self.view0 addSubview:self.view1];
    [self.view1 addSubview:self.view2];
    
    self.view0.sd_layout.leftSpaceToView(self.view, 30).rightSpaceToView(self.view, 30).topSpaceToView(self.view, 100).bottomSpaceToView(self.view, 30);
    self.view1.sd_layout.leftSpaceToView(self.view0, 30).topSpaceToView(self.view0, 30).widthRatioToView(self.view0, 0.5).heightRatioToView(self.view0, 0.5);
    self.view2.sd_layout.leftSpaceToView(self.view1, 30).topSpaceToView(self.view1, 30).widthRatioToView(self.view1, 0.5).heightRatioToView(self.view1, 0.5);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view0.sd_layout.heightIs(200).topSpaceToView(self.view, 80);
    });
}


@end
