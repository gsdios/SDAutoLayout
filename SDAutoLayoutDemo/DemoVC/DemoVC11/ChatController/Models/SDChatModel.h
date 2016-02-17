//
//  SDChatModel.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/13.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SDMessageTypeSendToOthers,
    SDMessageTypeSendToMe
} SDMessageType;

@interface SDChatModel : NSObject

@property (nonatomic, assign) SDMessageType messageType;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *imageName;

@end
