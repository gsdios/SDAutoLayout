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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imgIcon = [UIImageView new];
        [self.contentView addSubview:self.imgIcon];
        
        self.lblTitle = [UILabel new];
        self.lblTitle.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.lblTitle];
        
        self.lblSubtitle = [UILabel new];
        self.lblSubtitle.textColor = [UIColor grayColor];
        self.lblSubtitle.font = [UIFont systemFontOfSize:13];
        self.lblSubtitle.numberOfLines = 0;
        [self.contentView addSubview:self.lblSubtitle];
        
        self.lineView = [UIView new];
        [self.contentView addSubview:self.lineView];
        
        self.imgOther1 = [UIImageView new];
        [self.contentView addSubview:self.imgOther1];

        self.imgOther2 = [UIImageView new];
        [self.contentView addSubview:self.imgOther2];
        
        //设置主题
        
        [self configTheme];
    }
    return self;
}

//设置主题

- (void)configTheme{
    
    //使用标识符设置模式
    
    self.lblTitle.lee_theme.LeeConfigTextColor(@"demovc10_cell_titlecolor");
    
    self.lblSubtitle.lee_theme.LeeConfigTextColor(@"demovc10_cell_summarycolor");
    
    self.lineView.lee_theme.LeeConfigBackgroundColor(@"demovc10_cell_linecolor");
    
    self.lee_theme.LeeConfigBackgroundColor(@"demovc10_cell_backgroundcolor");
    
}

@end
