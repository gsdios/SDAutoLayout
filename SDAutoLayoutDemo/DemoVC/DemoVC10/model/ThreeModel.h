//
//  ThreeModel.h
//  SDAutoLayoutDemo
//
//  Created by lixiya on 16/1/14.
//  Copyright © 2016年 lixiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ads.h"
#import "Imgextra.h"
#import "Editor.h"

@interface ThreeModel : NSObject

@property (nonatomic,copy) NSString *tname;

/**
 *  新闻发布时间
 */
@property (nonatomic,copy) NSString *ptime;

/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;

/**
 *  跟帖人数
 */
@property (nonatomic,copy)NSNumber *replyCount;

/**
 *  新闻ID
 */
@property (nonatomic,copy) NSString *docid;

/**
 *  图片连接
 */
@property (nonatomic,copy) NSString *imgsrc;

/**
 *  描述
 */
@property (nonatomic,copy) NSString *digest;

/**
 *  大图样式
 */
@property (nonatomic,copy)NSNumber *imgType;


/**
 *  多图数组
 *  里面放的是Imgextra模型
 */
@property (nonatomic,strong)NSArray *imgextra;

/**
 *  里面放的是Editor模型
 */
@property (nonatomic,strong)NSArray *editor;

/**
 *  里面放的是Ads模型
 */
@property (nonatomic,strong)NSArray *ads;

@property (nonatomic,strong)NSArray *videoID;
@property (nonatomic,strong)NSArray *specialextra;
@property (nonatomic,strong)NSArray *applist;

@property (nonatomic,copy) NSString *photosetID;
@property (nonatomic,copy)NSNumber *hasHead;
@property (nonatomic,copy)NSNumber *hasImg;
@property (nonatomic,copy) NSString *lmodify;
@property (nonatomic,copy) NSString *template;
@property (nonatomic,copy) NSString *skipType;


@property (nonatomic,copy)NSNumber *votecount;
@property (nonatomic,copy)NSNumber *voteCount;
@property (nonatomic,copy) NSString *alias;


@property (nonatomic,assign)BOOL hasCover;
@property (nonatomic,copy)NSNumber *hasAD;
@property (nonatomic,copy)NSNumber *priority;
@property (nonatomic,copy) NSString *cid;


@property (nonatomic,assign)BOOL hasIcon;
@property (nonatomic,copy) NSString *ename;
@property (nonatomic,copy) NSString *skipID;
@property (nonatomic,copy)NSNumber *order;



@property (nonatomic,copy) NSString *url_3w;
@property (nonatomic,copy) NSString *specialID;
@property (nonatomic,copy) NSString *timeConsuming;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *adTitle;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *source;


@property (nonatomic,copy) NSString *TAGS;
@property (nonatomic,copy) NSString *TAG;


@property (nonatomic,copy) NSString *boardid;
@property (nonatomic,copy) NSString *commentid;
@property (nonatomic,copy)NSNumber *speciallogo;
@property (nonatomic,copy) NSString *specialtip;
@property (nonatomic,copy) NSString *specialadlogo;

@property (nonatomic,copy) NSString *pixel;


@property (nonatomic,copy) NSString *wap_portal;
@property (nonatomic,copy) NSString *live_info;



@property (nonatomic,copy) NSString *videosource;

@end
