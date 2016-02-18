//
//  SDChatTableViewCell.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/13.
//  Copyright © 2016年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * 持续更新地址: https://github.com/gsdios/SDAutoLayout                              *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 * QQ交流群：519489682（已满）497140713                                              *
 *********************************************************************************
 
 */




#import <UIKit/UIKit.h>

#import "SDChatModel.h"
#import "MLEmojiLabel.h"

@interface SDChatTableViewCell : UITableViewCell

@property (nonatomic, strong) SDChatModel *model;

@property (nonatomic, copy) void (^didSelectLinkTextOperationBlock)(NSString *link, MLEmojiLabelLinkType type);

@end
