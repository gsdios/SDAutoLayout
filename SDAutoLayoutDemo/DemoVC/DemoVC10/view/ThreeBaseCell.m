//
//  ThreeBaseCell.m
//  SDAutoLayoutDemo
//
//  Created by lixiya on 16/1/14.
//  Copyright © 2016年 lixiya. All rights reserved.
//

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#import "ThreeBaseCell.h"

@implementation ThreeBaseCell

// 获取数据类型对应的cell
+(NSString *)cellIdentifierForRow:(ThreeModel *)threeModel{

    if (threeModel.hasHead){
        return @"ThreeFourthCell";
    }else if (threeModel.imgType){
        return @"ThreeThirdCell";
    }else if (threeModel.imgextra){
        return @"ThreeSecondCell";
    }else{
        return @"ThreeFirstCell";
    }
 
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imgIcon = [UIImageView new];
        [self.contentView addSubview:self.imgIcon];
        
        self.lblTitle = [UILabel new];
        self.lblTitle.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.lblTitle];
        
        self.lblSubtitle = [UILabel new];
        self.lblSubtitle.textColor = [UIColor grayColor];
        self.lblSubtitle.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.lblSubtitle];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = rgba(238, 238, 238, 1.0);
        [self.contentView addSubview:self.lineView];
        
        self.imgOther1 = [UIImageView new];
        [self.contentView addSubview:self.imgOther1];

        self.imgOther2 = [UIImageView new];
        [self.contentView addSubview:self.imgOther2];
        
         
    }
    return self;
}

@end
