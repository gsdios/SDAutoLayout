//
//  DemoVC3.m
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

#import "DemoVC3.h"
#import "TestCell2.h"

@implementation DemoVC3
{
    NSTimer *_timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 150;
    // 打开可进行性能测试
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(test) userInfo:nil repeats:YES];
}

- (void)test
{
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.frame.size.height + self.tableView.contentOffset.y) animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"test";
    TestCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TestCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

@end
