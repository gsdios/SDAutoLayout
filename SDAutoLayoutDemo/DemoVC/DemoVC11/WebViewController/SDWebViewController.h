//
//  SDWebViewController.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/16.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDWebViewController : UIViewController

+ (instancetype)webViewControllerWithUrlString:(NSString *)urlString;

@property (nonatomic, copy) NSString *urlString;

@end
