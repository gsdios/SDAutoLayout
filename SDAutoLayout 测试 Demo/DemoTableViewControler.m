//
//  DemoTableViewControler.m
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

#import "DemoTableViewControler.h"

#import "DemoVC5.h"
#import "DemoVC9.h"

@implementation DemoTableViewControler

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIViewController *vc = [DemoVC5 new];
//    vc.title = @"DemoVC5";
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableview datasourece and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Demo -- %ld", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *demoClassString = [NSString stringWithFormat:@"DemoVC%ld", indexPath.row];
    
    if (indexPath.row == 9) {
        static UIStoryboard * s_storyboardHome = nil;
        
        if ( !s_storyboardHome ){
            s_storyboardHome = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        }
        DemoVC9 *vc9 = [s_storyboardHome instantiateViewControllerWithIdentifier:@"DemoVC9"];
        vc9.title = demoClassString;
        [self.navigationController pushViewController:vc9 animated:YES];
        return;
    }
    
    
    UIViewController *vc = [NSClassFromString(demoClassString) new];
    vc.title = demoClassString;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
