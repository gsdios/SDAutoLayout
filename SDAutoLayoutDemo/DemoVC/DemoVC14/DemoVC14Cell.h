//
//  DemoVC14Cell.h
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/12.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoVC7Model.h"

@interface DemoVC14Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) DemoVC7Model *model;

@end
