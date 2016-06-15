//
//  ThreeSecondCell.m
//  SDAutoLayoutDemo
//
//  Created by lixiya on 16/1/14.
//  Copyright © 2016年 lixiya. All rights reserved.
//

#import "ThreeSecondCell.h"

@implementation ThreeSecondCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setup];
    }
    return self;
}

-(void)setup{
    
    // 设置约束
    CGFloat margin = 10;
    UIView * contentView = self.contentView;

    NSArray * equalSubViews = [NSArray arrayWithObjects:self.imgIcon,self.imgOther1,self.imgOther2,nil];
    self.contentView.sd_equalWidthSubviews = equalSubViews;
    
    self.lblTitle.sd_layout
    .topSpaceToView(contentView,margin)
    .leftSpaceToView(contentView,margin)
    .rightSpaceToView(contentView,margin)
    .heightIs(21);
    
    self.imgIcon.sd_layout
    .leftSpaceToView(contentView,margin)
    .topSpaceToView(self.lblTitle,margin)
    .autoHeightRatio(0.75);
    
    self.imgOther1.sd_layout
    .leftSpaceToView(self.imgIcon,margin)
    .topSpaceToView(self.lblTitle,margin)
    .autoHeightRatio(0.75);

    self.imgOther2.sd_layout
    .leftSpaceToView(self.imgOther1,margin)
    .rightSpaceToView(contentView,margin)
    .topSpaceToView(self.lblTitle,margin)
    .autoHeightRatio(0.75);
    
    self.lineView.sd_layout
    .topSpaceToView(self.imgOther2,margin)
    .leftSpaceToView(contentView,margin)
    .rightSpaceToView(contentView,margin)
    .heightIs(0.5f);

    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];

}

-(void)setThreeModel:(ThreeModel *)threeModel{

    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:threeModel.imgsrc] placeholderImage:[UIImage imageNamed:@"303"]];
    self.lblTitle.text = threeModel.title;
    
    // 多图
    Imgextra * imgextra1 = threeModel.imgextra[0];
    Imgextra * imgextra2 = threeModel.imgextra[1];
    [self.imgOther1 sd_setImageWithURL:[NSURL URLWithString:imgextra1.imgsrc] placeholderImage:[UIImage imageNamed:@"303"]];
    [self.imgOther2 sd_setImageWithURL:[NSURL URLWithString:imgextra2.imgsrc] placeholderImage:[UIImage imageNamed:@"303"]];
}

@end
