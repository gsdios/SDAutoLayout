//
//  DemoVC14Cell.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/12.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "DemoVC14Cell.h"
#import "UIView+SDAutoLayout.h"

#import "PhotosContainerView.h"

@implementation DemoVC14Cell
{
    PhotosContainerView *_photosContainer;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    _photosContainer = photosContainer;
    [self.contentView addSubview:photosContainer];
    
    
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textColor = [UIColor grayColor];
    
    self.iconView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(50)
    .heightEqualToWidth();
    
    self.contentLabel.sd_layout
    .leftSpaceToView(self.iconView, 10)
    .topEqualToView(self.iconView)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    /*
    // 如果你需要限制最多显示多少行文字可以这样做
    [self.contentLabel setMaxNumberOfLinesToShow:6];
     */
    
    _photosContainer.sd_layout
    .leftEqualToView(self.contentLabel)
    .rightEqualToView(self.contentLabel)
    .topSpaceToView(self.contentLabel, 10); // 高度自适应了，不需要再设置约束
    
    
    
    
}


- (void)setModel:(DemoVC7Model *)model
{
    _model = model;
    
    _contentLabel.text = model.title;
    _iconView.image = [UIImage imageNamed:model.iconImagePath];
    
    
    UIView *bottomView = _contentLabel;
    
    _photosContainer.photoNamesArray = model.imagePathsArray;
    if (model.imagePathsArray.count > 0) {
        _photosContainer.hidden = NO;
        bottomView = _photosContainer;
    } else {
        _photosContainer.hidden = YES;
    }
    
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10]; // 如果你不能确定具体哪个view会在contentview的最底部，你可以把所有可能的view都包装在一个数组里面传过去，对应的方法为 [self setupAutoHeightWithBottomViewsArray:<#(NSArray *)#> bottomMargin:<#(CGFloat)#>]
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
