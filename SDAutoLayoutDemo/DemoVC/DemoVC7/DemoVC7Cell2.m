//
//  DemoVC7Cell2.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/17.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "DemoVC7Cell2.h"

#import "UIView+SDAutoLayout.h"

#import "DemoVC7Model.h"

@implementation DemoVC7Cell2
{
    UILabel *_titleLabel;
    NSArray *_imageViewsArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    
    UIImageView * imageView0 = [UIImageView new];
    [self.contentView addSubview:imageView0];
    
    UIImageView * imageView1 = [UIImageView new];
    [self.contentView addSubview:imageView1];
    
    UIImageView * imageView2 = [UIImageView new];
    [self.contentView addSubview:imageView2];
    
    imageView0.layer.borderColor = [UIColor grayColor].CGColor;
    imageView0.layer.borderWidth = 1;
    
    imageView1.layer.borderColor = [UIColor grayColor].CGColor;
    imageView1.layer.borderWidth = 1;
    
    imageView2.layer.borderColor = [UIColor grayColor].CGColor;
    imageView2.layer.borderWidth = 1;
    
    _imageViewsArray = @[imageView0, imageView1, imageView2];
    
    // 设置等宽的子view
    self.contentView.sd_equalWidthSubviews = _imageViewsArray;
    
    CGFloat margin = 15;
    UIView *contentView = self.contentView;
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    imageView0.sd_layout
    .topSpaceToView(_titleLabel, margin)
    .leftSpaceToView(contentView, margin)
    .autoHeightRatio(0.8);
    
    imageView1.sd_layout
    .topSpaceToView(_titleLabel, margin)
    .leftSpaceToView(imageView0, margin)
    .autoHeightRatio(0.8);
    
    imageView2.sd_layout
    .topSpaceToView(_titleLabel, margin)
    .leftSpaceToView(imageView1, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0.8);
    
    [self setupAutoHeightWithBottomView:imageView0 bottomMargin:margin];
}

- (void)setModel:(DemoVC7Model *)model
{
    _model = model;
    
    _titleLabel.text = model.title;

    [model.imagePathsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = _imageViewsArray[idx];
        imageView.image = [UIImage imageNamed:str];
    }];
}


@end
