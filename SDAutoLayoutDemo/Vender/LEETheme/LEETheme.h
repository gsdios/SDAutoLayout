
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
 *  @version    V1.0.7
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LEEThemeConfigModel;

typedef void(^LEEThemeConfigBlock)(id item);
typedef void(^LEEThemeConfigBlockToIdentifier)(id item , id value);
typedef LEEThemeConfigModel *(^LEEConfigThemeToFloat)(CGFloat number);
typedef LEEThemeConfigModel *(^LEEConfigThemeToIdentifier)(NSString *identifier);
typedef LEEThemeConfigModel *(^LEEConfigThemeToColor)(NSString *tag , UIColor *color);
typedef LEEThemeConfigModel *(^LEEConfigThemeToImage)(NSString *tag , id image);
typedef LEEThemeConfigModel *(^LEEConfigThemeToString)(NSString *tag , NSString *string);
typedef LEEThemeConfigModel *(^LEEConfigThemeToStringAndBlock)(NSString *tag , LEEThemeConfigBlock);
typedef LEEThemeConfigModel *(^LEEConfigThemeToArrayAndBlock)(NSArray *tags , LEEThemeConfigBlock);
typedef LEEThemeConfigModel *(^LEEConfigThemeToIdentifierAndState)(NSString *identifier , UIControlState state);
typedef LEEThemeConfigModel *(^LEEConfigThemeToColorAndState)(NSString *tag , UIColor *color , UIControlState state);
typedef LEEThemeConfigModel *(^LEEConfigThemeToImageAndState)(NSString *tag , UIImage *image , UIControlState state);
typedef LEEThemeConfigModel *(^LEEConfigThemeToImageAndState)(NSString *tag , UIImage *image , UIControlState state);
typedef LEEThemeConfigModel *(^LEEConfigThemeToKeyPathAndColor)(NSString *tag , NSString *keyPath , UIColor *color);
typedef LEEThemeConfigModel *(^LEEConfigThemeToKeyPathAndImage)(NSString *tag , NSString *keyPath , id image);
typedef LEEThemeConfigModel *(^LEEConfigThemeToIdentifierAndBlock)(NSString *identifier , LEEThemeConfigBlockToIdentifier);

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
 *  默认更改主题动画时长 (这是所有对象默认的时长 , 但如果你对某个对象单独进行了时长设置 , 那么该对象将以单独设置的为准)
 *
 *  @param duration 动画时长
 */
+ (void)defaultChangeThemeAnimationDuration:(CGFloat)duration;

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
 *  @param path 资源路径 (传入nil 默认为mainBundle路径)
 */
+ (void)addThemeConfigJson:(NSString *)json WithTag:(NSString *)tag WithResourcesPath:(NSString *)path;

/**
 *  获取指定主题标签的资源路径
 *
 *  @param tag 主题标签
 *
 *  @return 资源路径 (如为不存在则返回mainBundle路径)
 */
+ (NSString *)getResourcesPathWithTag:(NSString *)tag;

@end

@interface LEEThemeConfigModel : NSObject

/** ----独立设置方式---- */

/** Block */

/** 添加自定义设置 -> 格式: .LeeAddCustomConfig(@@"tag" , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToStringAndBlock LeeAddCustomConfig;
/** 添加多标签自定义设置 -> 格式: .LeeAddCustomConfigs(@@[tag1 , tag2] , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToArrayAndBlock LeeAddCustomConfigs;

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
/** 添加分隔线颜色设置 -> 格式: .LeeAddSeparatorColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddSeparatorColor;
/** 添加bar渲染颜色设置 -> 格式: .LeeAddBarTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddBarTintColor;
/** 添加背景颜色设置 -> 格式: .LeeAddBackgroundColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddBackgroundColor;
/** 添加占位符颜色设置 -> 格式: .LeeAddPlaceholderColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddPlaceholderColor;
/** 添加进度轨道渲染颜色设置 -> 格式: .LeeAddTrackTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddTrackTintColor;
/** 添加进度渲染颜色设置 -> 格式: .LeeAddProgressTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddProgressTintColor;
/** 添加高亮文本颜色设置 -> 格式: .LeeAddHighlightedTextColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddHighlightedTextColor;
/** 添加页数指示渲染颜色设置 -> 格式: .LeeAddPageIndicatorTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddPageIndicatorTintColor;
/** 添加当前页数指示渲染颜色设置 -> 格式: .LeeAddCurrentPageIndicatorTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddCurrentPageIndicatorTintColor;
/** 添加按钮标题颜色设置 -> 格式: .LeeAddButtonTitleColor(@@"tag" , UIColor , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColorAndState LeeAddButtonTitleColor;
/** 添加按钮标题阴影颜色设置 -> 格式: .LeeAddButtonTitleShadowColor(@@"tag" , UIColor , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColorAndState LeeAddButtonTitleShadowColor;

/** 添加属性颜色设置 -> 格式: .LeeAddKeyPathAndColor(@@"tag" , @@"keyPath" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToKeyPathAndColor LeeAddKeyPathAndColor;

/** Image */

/** 添加图片设置 -> 格式: .LeeAddImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddImage;
/** 添加进度轨道图片设置 -> 格式: .LeeAddTrackImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddTrackImage;
/** 添加进度图片设置 -> 格式: .LeeAddProgressImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddProgressImage;
/** 添加阴影图片设置 -> 格式: .LeeAddShadowImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddShadowImage;
/** 添加选中图片设置 -> 格式: .LeeAddSelectedImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddSelectedImage;
/** 添加背景图片设置 -> 格式: .LeeAddBackgroundImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddBackgroundImage;
/** 添加返回指示图片设置 -> 格式: .LeeAddBackIndicatorImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddBackIndicatorImage;
/** 添加返回指示图片设置 -> 格式: .LeeAddBackIndicatorTransitionMaskImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddBackIndicatorTransitionMaskImage;
/** 添加选择指示器图片设置 -> 格式: .LeeAddSelectionIndicatorImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddSelectionIndicatorImage;
/** 添加分栏背景图片设置 -> 格式: .LeeAddScopeBarBackgroundImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddScopeBarBackgroundImage;
/** 添加按钮图片设置 -> 格式: .LeeAddButtonImage(@@"tag" , UIImage , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImageAndState LeeAddButtonImage;
/** 添加按钮背景图片设置 -> 格式: .LeeAddButtonBackgroundImage(@@"tag" , UIImage , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImageAndState LeeAddButtonBackgroundImage;

/** 添加属性图片设置 -> 格式: .LeeAddKeyPathAndImage(@@"tag" , @@"keyPath" , UIImage 或 @"imageName" 或 @"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToKeyPathAndImage LeeAddKeyPathAndImage;

/** ----JSON设置方式---- */

/** Block */

/** 自定义设置 -> 格式: .LeeCustomConfig(@@"identifier" , ^(id item , id value){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndBlock LeeCustomConfig;

/** Color */

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
/** 设置分隔线颜色标识符 -> 格式: .LeeConfigSeparatorColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigSeparatorColor;
/** 设置bar渲染颜色标识符 -> 格式: .LeeConfigBarTintColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigBarTintColor;
/** 设置背景颜色标识符 -> 格式: .LeeConfigBackgroundColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigBackgroundColor;
/** 设置占位符颜色标识符 -> 格式: .LeeConfigPlaceholderColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigPlaceholderColor;
/** 设置进度轨道渲染颜色标识符 -> 格式: .LeeConfigTrackTintColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigTrackTintColor;
/** 设置进度渲染颜色标识符 -> 格式: .LeeConfigProgressTintColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigProgressTintColor;
/** 设置高亮文本颜色标识符 -> 格式: .LeeConfigHighlightedTextColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigHighlightedTextColor;
/** 设置页数指示渲染颜色标识符 -> 格式: .LeeConfigPageIndicatorTintColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigPageIndicatorTintColor;
/** 设置当前页数指示渲染颜色标识符 -> 格式: .LeeConfigCurrentPageIndicatorTintColor(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigCurrentPageIndicatorTintColor;
/** 设置按钮标题颜色标识符 -> 格式: .LeeConfigButtonTitleColor(@@"identifier" , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndState LeeConfigButtonTitleColor;
/** 设置按钮标题阴影颜色标识符 -> 格式: .LeeConfigButtonTitleColor(@@"identifier" , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndState LeeConfigButtonTitleShadowColor;

/** Image */

/** 设置图片标识符 -> 格式: .LeeConfigImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigImage;
/** 设置进度轨道图片标识符 -> 格式: .LeeConfigTrackImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigTrackImage;
/** 设置进度图片标识符 -> 格式: .LeeConfigProgressImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigProgressImage;
/** 设置阴影图片标识符 -> 格式: .LeeConfigShadowImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigShadowImage;
/** 设置选中图片标识符 -> 格式: .LeeConfigSelectedImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigSelectedImage;
/** 设置背景图片标识符 -> 格式: .LeeConfigBackgroundImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigBackgroundImage;
/** 设置返回指示图片标识符 -> 格式: .LeeConfigBackIndicatorImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigBackIndicatorImage;
/** 设置返回指示图片标识符 -> 格式: .LeeConfigBackIndicatorTransitionMaskImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigBackIndicatorTransitionMaskImage;
/** 设置选择指示器图片标识符 -> 格式: .LeeConfigSelectionIndicatorImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigSelectionIndicatorImage;
/** 设置分栏背景图片标识符 -> 格式: .LeeConfigScopeBarBackgroundImage(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeConfigScopeBarBackgroundImage;
/** 设置按钮图片标识符 -> 格式: .LeeConfigButtonImage(@@"identifier" , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndState LeeConfigButtonImage;
/** 设置按钮背景图片标识符 -> 格式: .LeeConfigButtonBackgroundImage(@@"identifier" , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndState LeeConfigButtonBackgroundImage;

/** 设置属性标识符 -> 格式: .LeeConfigKeyPathAndIdentifier(@@"keyPath" , @@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeConfigKeyPathAndIdentifier;

/** ----通用设置---- */

/** 设置主题更改过渡动画时长 -> 格式: .LeeChangeThemeAnimationDuration(0.1f) */
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

+ (UIColor *)leeTheme_ColorFromJsonWithTag:(NSString *)tag WithIdentifier:(NSString *)identifier;

@end

@interface UIImage (LEEThemeImage)

+ (UIImage *)leeTheme_ImageFromJsonWithTag:(NSString *)tag WithIdentifier:(NSString *)identifier;

@end


