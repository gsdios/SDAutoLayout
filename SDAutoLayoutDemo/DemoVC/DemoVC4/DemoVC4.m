//
//  DemoVC4.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/10/16.
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

#import "DemoVC4.h"

@implementation DemoVC4
{
    UILabel *_label;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//  --------- attributedString测试：行间距为8 ---------------------------
    
    
    
    
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    _label = label;
    [self setupAttributedStringForTestLabel];
    
    label.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 70)
    .autoHeightRatio(0);
    
    // 标注lable的text为attributedString
    label.isAttributedContent = YES;
    
    UIButton *button = [UIButton new];
    [button setTitle:@"点我随机刷新文字" forState:UIControlStateNormal];
    button.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(label, 20)
    .heightIs(30);
    
//  --------- attributedString测试：行间距为8 ---------------------------
    
}

- (void)onClickButton
{
    [self setupAttributedStringForTestLabel];
    [_label updateLayout];
}

- (void)setupAttributedStringForTestLabel
{
    NSString *text = @"富文本高度自适应demo\nattributedString测试：行间距为8。彩虹网络卡福利费绿调查开房；卡法看得出来分开了的出口来反馈率打开了房；快烦死了；了； 调查开房；；v单纯考虑分离开都快来反馈来看发v离开的积分房积分jdhflgfkkvvm.cm。attributedString测试：行间距为8。彩虹网络卡福利费绿调查开房；卡法看得出来分开了的出口来反馈率打开了房；";
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    UIColor *color = [UIColor blackColor];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSInteger length = text.length;
    int loc = 0;
    while (length > 8) {
        int random = arc4random_uniform(10);
        if (loc + random < text.length) {
            [string addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:(10 + arc4random_uniform(20))]
                           range:NSMakeRange(loc, random)];
            
            [string addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithRed:(arc4random_uniform(255) / 255.0)
                                                 green:(arc4random_uniform(255) / 255.0)
                                                  blue:(arc4random_uniform(255) / 255.0)
                                                 alpha:(arc4random_uniform(255) / 255.0) + 0.2]
                           range:NSMakeRange(loc, random)];
        }
        loc += random;
        length -= random;
    }
    
    _label.attributedText = string;
}

@end
