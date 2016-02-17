//
//  DemoVC11.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/2/17.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "DemoVC11.h"

#import "GlobalDefines.h"

#import "SDChatTableViewCell.h"
#import "SDAnalogDataGenerator.h"
#import "SDWebViewController.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#define kChatTableViewControllerCellId @"ChatTableViewController"

@interface DemoVC11 ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DemoVC11

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDataWithCount:30];
    
    CGFloat rgb = 240;
    self.tableView.backgroundColor = SDColor(rgb, rgb, rgb, 1);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SDChatTableViewCell class] forCellReuseIdentifier:kChatTableViewControllerCellId];
}

- (void)setupDataWithCount:(NSInteger)count
{
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    for (int i = 0; i < count; i++) {
        SDChatModel *model = [SDChatModel new];
        model.messageType = arc4random_uniform(2);
        if (model.messageType) {
            model.iconName = [SDAnalogDataGenerator randomIconImageName];
            if (arc4random_uniform(10) > 5) {
                int index = arc4random_uniform(5);
                model.imageName = [NSString stringWithFormat:@"test%d.jpg", index];
            }
        } else {
            if (arc4random_uniform(10) < 5) {
                int index = arc4random_uniform(5);
                model.imageName = [NSString stringWithFormat:@"test%d.jpg", index];
            }
            model.iconName = @"2.jpg";
        }
        
        
        model.text = [SDAnalogDataGenerator randomMessage];
        [self.dataArray addObject:model];
    }
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatTableViewControllerCellId];
    cell.model = self.dataArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [cell setDidSelectLinkTextOperationBlock:^(NSString *link, MLEmojiLabelLinkType type) {
        if (type == MLEmojiLabelLinkTypeURL) {
            [weakSelf.navigationController pushViewController:[SDWebViewController webViewControllerWithUrlString:link] animated:YES];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[SDChatTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@">>>>>  %@", [self.dataArray[indexPath.row] text]);
}


@end
