
/*!
 *  @header LEETheme.h
 *
 *  ┌─┐      ┌───────┐ ┌───────┐ 帅™
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ │      │ └─────┐ │ └─────┐
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ └─────┐│ └─────┐ │ └─────┐
 *  └───────┘└───────┘ └───────┘
 *
 *  @brief  LEE主题管理
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    V1.0
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LEEThemeConfigModel;

typedef void(^LEEThemeConfigBlock)(id item);
typedef LEEThemeConfigModel *(^LEEConfigThemeToFloat)(CGFloat number);
typedef LEEThemeConfigModel *(^LEEConfigThemeToIdentifier)(NSString *identifier);
typedef LEEThemeConfigModel *(^LEEConfigThemeToColor)(NSString *tag , UIColor *color);
typedef LEEThemeConfigModel *(^LEEConfigThemeToImage)(NSString *tag , UIImage *image);
typedef LEEThemeConfigModel *(^LEEConfigThemeToString)(NSString *tag , NSString *string);
typedef LEEThemeConfigModel *(^LEEConfigThemeToTagAndBlock)(NSString *tag , LEEThemeConfigBlock);
typedef LEEThemeConfigModel *(^LEEConfigThemeToTagsAndBlock)(NSArray *tags , LEEThemeConfigBlock);
typedef LEEThemeConfigModel *(^LEEConfigThemeToIdentifierAndState)(NSString *identifier , UIControlState state);
typedef LEEThemeConfigModel *(^LEEConfigThemeToColorAndState)(NSString *tag , UIColor *color , UIControlState state);
typedef LEEThemeConfigModel *(^LEEConfigThemeToImageAndState)(NSString *tag , UIImage *image , UIControlState state);

/*
 
 *********************************************************************************
 *
 * 在使用LEETheme的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ    : 可以添加SDAutoLayout群 497140713 在这里找到我(LEE)
 * Email : applelixiang@126.com
 * GitHub: https://github.com/lixiang1994/LEETheme
 * 简书:    http://www.jianshu.com/users/a6da0db100c8
 *
 *********************************************************************************
 
 */

@interface LEETheme : NSObject

/**
 *  启动主题
 *
 *  @param tag 主题标签
 */
+ (void)startTheme:(NSString *)tag;

/**
 *  默认主题
 *
 *  @param tag 主题标签
 */
+ (void)defaultTheme:(NSString *)tag;

/**
 *  当前主题标签
 *
 *  @return 主题标签 tag
 */
+ (NSString *)currentThemeTag;

/**
 *  添加主题设置Json
 *
 *  @param json json字符串
 *  @param tag 主题标签
 */
+ (void)addThemeConfigJson:(NSString *)json WithTag:(NSString *)tag WithResourcesPath:(NSString *)path;

@end

@interface LEEThemeConfigModel : NSObject

/** ----独立设置方式---- */

/** Block */

/** 添加自定义设置 -> 格式: .LeeAddCustomConfig(@@"tag" , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToTagAndBlock LeeAddCustomConfig;
/** 添加多标签自定义设置 -> 格式: .LeeAddCustomConfigs(@@[tag1 , tag2] , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToTagsAndBlock LeeAddCustomConfigs;

/** Color */

/** 添加渲染颜色设置 -> 格式: .LeeAddTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddTintColor;
/** 添加文本颜色设置 -> 格式: .LeeAddTextColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddTextColor;
/** 添加填充颜色设置 -> 格式: .LeeAddFillColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddFillColor;
/** 添加笔画颜色设置 -> 格式: .LeeAddStrokeColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddStrokeColor;
/** 添加边框颜色设置 -> 格式: .LeeAddBorderColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddBorderColor;
/** 添加阴影颜色设置 -> 格式: .LeeAddShadowColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddShadowColor;
/** 添加开关开启颜色设置 -> 格式: .LeeAddOnTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddOnTintColor;
/** 添加开关按钮颜色设置 -> 格式: .LeeAddThumbTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddThumbTintColor;
/** 添加bar渲染颜色设置 -> 格式: .LeeAddBarTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddBarTintColor;
/** 添加背景颜色设置 -> 格式: .LeeAddBackgroundColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddBackgroundColor;
/** 添加占位符颜色设置 -> 格式: .LeeAddPlaceholderColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddPlaceholderColor;
/** 添加按钮标题颜色设置 -> 格式: .LeeAddButtonTitleColor(@@"tag" , UIColor , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColorAndState LeeAddButtonTitleColor;
/** 添加按钮标题阴影颜色设置 -> 格式: .LeeAddButtonTitleShadowColor(@@"tag" , UIColor , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColorAndState LeeAddButtonTitleShadowColor;


/** Image */

/** 添加图片设置 -> 格式: .LeeAddImage(@@"tag" , UIImage) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddImage;
/** 添加图片设置 -> 格式: .LeeAddImageName(@@"tag" , @"lee") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddImageName;
/** 添加图片设置 -> 格式: .LeeAddImagePath(@@"tag" , @"var/XXX/XXXX/lee.png") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddImagePath;
/** 添加阴影图片设置 -> 格式: .LeeAddShadowImage(@@"tag" , UIImage) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddShadowImage;
/** 添加阴影图片设置 -> 格式: .LeeAddShadowImageName(@@"tag" , @"lee") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddShadowImageName;
/** 添加阴影图片设置 -> 格式: .LeeAddShadowImagePath(@@"tag" , @"var/XXX/XXXX/lee.png") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddShadowImagePath;
/** 添加选中图片设置 -> 格式: .LeeAddSelectedImage(@@"tag" , UIImage) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddSelectedImage;
/** 添加选中图片设置 -> 格式: .LeeAddSelectedImageName(@@"tag" , @"lee") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddSelectedImageName;
/** 添加选中图片设置 -> 格式: .LeeAddSelectedImagePath(@@"tag" , @"var/XXX/XXXX/lee.png") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddSelectedImagePath;
/** 添加背景图片设置 -> 格式: .LeeAddBackgroundImage(@@"tag" , UIImage) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddBackgroundImage;
/** 添加背景图片设置 -> 格式: .LeeAddBackgroundImageName(@@"tag" , @"lee") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddBackgroundImageName;
/** 添加背景图片设置 -> 格式: .LeeAddBackgroundImagePath(@@"tag" , @"var/XXX/XXXX/lee.png") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddBackgroundImagePath;
/** 添加选择指示器图片设置 -> 格式: .LeeAddSelectionIndicatorImage(@@"tag" , UIImage) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddSelectionIndicatorImage;
/** 添加选择指示器图片设置 -> 格式: .LeeAddSelectionIndicatorImageName(@@"tag" , @"lee") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddSelectionIndicatorImageName;
/** 添加选择指示器图片设置 -> 格式: .LeeAddSelectionIndicatorImagePath(@@"tag" , @"var/XXX/XXXX/lee.png") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddSelectionIndicatorImagePath;
/** 添加分栏背景图片设置 -> 格式: .LeeAddScopeBarBackgroundImage(@@"tag" , UIImage) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddScopeBarBackgroundImage;
/** 添加分栏背景图片设置 -> 格式: .LeeAddScopeBarBackgroundImageName(@@"tag" , @"lee") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddScopeBarBackgroundImageName;
/** 添加分栏背景图片设置 -> 格式: .LeeAddScopeBarBackgroundImagePath(@@"tag" , @"var/XXX/XXXX/lee.png") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddScopeBarBackgroundImagePath;
/** 添加按钮图片设置 -> 格式: .LeeAddButtonImage(@@"tag" , UIImage , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImageAndState LeeAddButtonImage;
/** 添加按钮背景图片设置 -> 格式: .LeeAddButtonBackgroundImage(@@"tag" , UIImage , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImageAndState LeeAddButtonBackgroundImage;

/** ----JSON设置方式---- */

/** 设置渲染颜色标识符 -> 格式: .LeeConfigTintColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigTintColor;
/** 设置文本颜色标识符 -> 格式: .LeeConfigTextColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigTextColor;
/** 设置填充颜色标识符 -> 格式: .LeeConfigFillColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigFillColor;
/** 设置笔画颜色标识符 -> 格式: .LeeConfigStrokeColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigStrokeColor;
/** 设置边框颜色标识符 -> 格式: .LeeConfigBorderColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigBorderColor;
/** 设置文本颜色标识符 -> 格式: .LeeConfigShadowColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigShadowColor;
/** 设置开关开启颜色标识符 -> 格式: .LeeConfigOnTintColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigOnTintColor;
/** 设置开关按钮颜色标识符 -> 格式: .LeeConfigThumbTintColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigThumbTintColor;
/** 设置bar渲染颜色标识符 -> 格式: .LeeConfigBarTintColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigBarTintColor;
/** 设置背景颜色标识符 -> 格式: .LeeConfigBackgroundColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigBackgroundColor;
/** 设置占位符颜色标识符 -> 格式: .LeeConfigPlaceholderColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigPlaceholderColor;
/** 设置按钮标题颜色标识符 -> 格式: .LeeConfigButtonTitleColor(@@"identifier" , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndState LeeConfigButtonTitleColor;
/** 设置按钮标题阴影颜色标识符 -> 格式: .LeeConfigButtonTitleColor(@@"identifier" , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndState LeeConfigButtonTitleShadowColor;

/** 设置图片标识符 -> 格式: .LeeConfigImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigImage;
/** 设置阴影图片标识符 -> 格式: .LeeConfigShadowImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigShadowImage;
/** 设置选中图片标识符 -> 格式: .LeeConfigSelectedImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigSelectedImage;
/** 设置背景图片标识符 -> 格式: .LeeConfigBackgroundImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigBackgroundImage;
/** 设置选择指示器图片标识符 -> 格式: .LeeConfigSelectionIndicatorImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigSelectionIndicatorImage;
/** 设置分栏背景图片标识符 -> 格式: .LeeConfigScopeBarBackgroundImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigScopeBarBackgroundImage;
/** 设置按钮图片标识符 -> 格式: .LeeConfigButtonImage(@@"identifier" , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndState LeeConfigButtonImage;
/** 设置按钮背景图片标识符 -> 格式: .LeeConfigButtonBackgroundImage(@@"identifier" , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndState LeeConfigButtonBackgroundImage;

/** 设置主题更改过渡动画时长 -> 格式: .LeeChangeThemeAnimationDuration(0.2f) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToFloat LeeChangeThemeAnimationDuration;

@end

@interface NSObject (LEEThemeConfigObject)

@property (nonatomic , strong ) LEEThemeConfigModel *lee_theme;

@end




/*
 *
 *          ┌─┐       ┌─┐
 *       ┌──┘ ┴───────┘ ┴──┐
 *       │                 │
 *       │       ───       │
 *       │  ─┬┘       └┬─  │
 *       │                 │
 *       │       ─┴─       │
 *       │                 │
 *       └───┐         ┌───┘
 *           │         │
 *           │         │
 *           │         │
 *           │         └──────────────┐
 *           │                        │
 *           │                        ├─┐
 *           │                        ┌─┘
 *           │                        │
 *           └─┐  ┐  ┌───────┬──┐  ┌──┘
 *             │ ─┤ ─┤       │ ─┤ ─┤
 *             └──┴──┘       └──┴──┘
 *                 神兽保佑
 *                 代码无BUG!
 */

@interface UIColor (LEEThemeColor)

+ (UIColor *)leeTheme_ColorWithHexString:(NSString *)hexString;

@end



