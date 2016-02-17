//
//  SDChatTableViewCell.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/13.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDChatModel.h"
#import "MLEmojiLabel.h"

@interface SDChatTableViewCell : UITableViewCell

@property (nonatomic, strong) SDChatModel *model;

@property (nonatomic, copy) void (^didSelectLinkTextOperationBlock)(NSString *link, MLEmojiLabelLinkType type);

@end
