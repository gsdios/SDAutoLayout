//
//  DemoVC9Cell.m
//  SDAutoLayout 测试 Demo
//
//  Created by Chai on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "DemoVC9Cell.h"
#import "DemoVC7Model.h"
#import "UIView+SDAutoLayout.h"

@interface DemoVC9Cell()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbInfo;
@end

@implementation DemoVC9Cell

- (void)awakeFromNib {
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    [self setupAutoHeightWithBottomView:_lbInfo bottomMargin:10];
}

- (void)setModel:(DemoVC7Model *)model
{
    _model = model;
    
    _lbTitle.text = model.title;
    _lbInfo.text = model.title;
    _img.image = [UIImage imageNamed:model.imagePathsArray.firstObject];
}
@end
