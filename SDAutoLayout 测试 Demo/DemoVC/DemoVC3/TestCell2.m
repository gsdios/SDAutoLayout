//
//  TestCell2.m
//  iphone6 plus 适配测试
//
//  Created by gsd on 15/10/10.
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

#import "TestCell2.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@implementation TestCell2
{
    UIView *_view0;
    UIView *_view1;
    UILabel *_view2;
    UIView *_view3;
    UIView *_view4;
    UIView *_view5;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        UIImageView *view0 = [UIImageView new];
        view0.image = [UIImage imageNamed:@"iii"];
        view0.backgroundColor = [UIColor redColor];
        _view0 = view0;
        
        UIView *view1 = [UIView new];
        view1.backgroundColor = [UIColor grayColor];
        _view1 = view1;
        
        UILabel *view2 = [UILabel new];
        view2.backgroundColor = [UIColor brownColor];
        _view2 = view2;
        
        UILabel *view3 = [UILabel new];
        view3.backgroundColor = [UIColor orangeColor];
        _view3 = view3;
        
        UIView *view4 = [UIView new];
        view4.backgroundColor = [UIColor purpleColor];
        _view4 = view4;
        
        UIView *view5 = [UIView new];
        view5.backgroundColor = [UIColor yellowColor];
        _view5 = view5;
        
        [self.contentView addSubview:view0];
        [self.contentView addSubview:view1];
        [self.contentView addSubview:view2];
        [self.contentView addSubview:view3];
        [self.contentView addSubview:view4];
        [self.contentView addSubview:view5];
        
        
        
        _view0.sd_layout
        .widthIs(50)
        .heightIs(50)
        .topSpaceToView(self.contentView, 10)
        .leftSpaceToView(self.contentView, 10);
        
        _view1.sd_layout
        .topEqualToView(_view0)
        .leftSpaceToView(_view0, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightRatioToView(_view0, 0.4);
        
        _view2.sd_layout
        .topSpaceToView(_view1, 10)
        .rightSpaceToView(self.contentView, 60)
        .leftEqualToView(_view1)
        .autoHeightRatio(0);
        
        _view3.sd_layout
        .topEqualToView(_view2)
        .leftSpaceToView(_view2, 10)
        .heightRatioToView(_view2, 1)
        .rightEqualToView(_view1);
        
        _view4.sd_layout
        .leftEqualToView(_view2)
        .topSpaceToView(_view2, 10)
        .heightIs(30)
        .widthRatioToView(_view1, 0.7);
        
        _view5.sd_layout
        .leftSpaceToView(_view4, 10)
        .rightSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 10)
        .heightRatioToView(_view4, 1);
 
        
        //***********************高度自适应cell设置步骤************************
        
        [self setupAutoHeightWithBottomView:_view4 bottomMargin:10];
        
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    _view2.text = text;
}

@end
