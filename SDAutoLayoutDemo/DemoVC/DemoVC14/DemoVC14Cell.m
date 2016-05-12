//
//  DemoVC14Cell.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/12.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "DemoVC14Cell.h"
#import "UIView+SDAutoLayout.h"

@implementation DemoVC14Cell

- (void)awakeFromNib {
    
    
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textColor = [UIColor lightGrayColor];
    
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
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:10]; // 如果你不能确定具体哪个view会在contentview的最底部，你可以把所有可能的view都包装在一个数组里面传过去，对应的方法为 [self setupAutoHeightWithBottomViewsArray:<#(NSArray *)#> bottomMargin:<#(CGFloat)#>]
    
    
}


- (void)setModel:(DemoVC7Model *)model
{
    _model = model;
    
    _contentLabel.text = model.title;
    _iconView.image = [UIImage imageNamed:model.imagePathsArray.firstObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
