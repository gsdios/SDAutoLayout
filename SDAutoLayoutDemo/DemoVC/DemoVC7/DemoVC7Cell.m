//
//  DemoVC7Cell.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/17.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "DemoVC7Cell.h"

#import "UIView+SDAutoLayout.h"

#import "DemoVC7Model.h"

@implementation DemoVC7Cell
{
    UILabel *_titleLabel;
    UIImageView *_imageView;
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
    
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
    _imageView.layer.borderColor = [UIColor grayColor].CGColor;
    _imageView.layer.borderWidth = 1;
    
    
    CGFloat margin = 15;
    UIView *contentView = self.contentView;
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, 120)
    .autoHeightRatio(0);
    
    _imageView.sd_layout
    .topEqualToView(_titleLabel)
    .leftSpaceToView(_titleLabel, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(60);
    
    // 当你不确定哪个view在自动布局之后会排布在cell最下方的时候可以调用次方法将所有可能在最下方的view都传过去
    [self setupAutoHeightWithBottomViewsArray:@[_titleLabel, _imageView] bottomMargin:margin];
}

- (void)setModel:(DemoVC7Model *)model
{
    _model = model;

    _titleLabel.text = model.title;
    _imageView.image = [UIImage imageNamed:model.imagePathsArray.firstObject];
}

@end

