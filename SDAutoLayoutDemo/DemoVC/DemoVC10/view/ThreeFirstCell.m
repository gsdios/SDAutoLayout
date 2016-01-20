//
//  ThreeFirstCell.m
//  SDAutoLayoutDemo
//
//  Created by lixiya on 16/1/14.
//  Copyright © 2016年 lixiya. All rights reserved.
//

#import "ThreeFirstCell.h"

@implementation ThreeFirstCell


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
    
    self.imgIcon.sd_layout
    .leftSpaceToView(self.contentView,margin)
    .topSpaceToView(self.contentView,margin)
    .widthIs(90)
    .heightIs(65);
    
    self.lblTitle.sd_layout
    .leftSpaceToView(self.imgIcon ,margin)
    .topSpaceToView(self.contentView,margin)
    .rightSpaceToView(self.contentView,margin)
    .heightIs(21);
    
    self.lblSubtitle.sd_layout
    .topSpaceToView(self.lblTitle,margin)
    .leftSpaceToView(self.imgIcon,margin)
    .rightSpaceToView(self.contentView,margin)
    .autoHeightRatio(0);
    
    self.lineView.sd_layout
    .topSpaceToView(self.imgIcon,margin)
    .rightSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,0)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
}


-(void)setThreeModel:(ThreeModel *)threeModel{

    self.lblTitle.text = threeModel.title;
    self.lblSubtitle.text = [NSString stringWithFormat:@"%@",threeModel.digest];
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:threeModel.imgsrc] placeholderImage:[UIImage imageNamed:@"303"]];

}


@end
