
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
 *  @copyright    Copyright © 2016 - 2017年 lee. All rights reserved.
 *  @version    V1.1.7
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LEEThemeHelper.h"

/*
 
 *********************************************************************************
 *
 * 在使用LEETheme的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ    : 可以添加SDAutoLayout群 497140713 在这里找到我(LEE 332459523)
 * Email : 18611401994@163.com
 * GitHub: https://github.com/lixiang1994/LEETheme
 * 简书:    http://www.jianshu.com/users/a6da0db100c8
 * 博客:    http://www.lee1994.com
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
 *  默认主题 (必设置 , 应用程序最少需要一个默认主题)
 *
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
 *  全部主题标签
 *
 *  @return 主题标签集合
 */
+ (NSArray *)allThemeTag;

@end

@interface LEETheme (JsonModeExtend)

/**
 *  添加主题设置Json
 *
 *  @param json json字符串
 *  @param tag 主题标签
 *  @param path 资源路径 (在Documents目录下的路径 如果资源不在Documents目录下应传入nil 例: ResourcesPath:@@"themeResources/day/")
 */
+ (void)addThemeConfigWithJson:(NSString *)json Tag:(NSString *)tag ResourcesPath:(NSString *)path;

/**
 *  移除主题设置
 *
 *  @param tag 主题标签
 */
+ (void)removeThemeConfigWithTag:(NSString *)tag;

/**
 *  获取指定主题标签的资源路径
 *
 *  @param tag 主题标签
 *
 *  @return 资源路径 (如为不存在则返回mainBundle路径)
 */
+ (NSString *)getResourcesPathWithTag:(NSString *)tag;

/**
 *  获取值
 *
 *  @param tag          主题标签
 *  @param identifier   标识符
 *
 *  @return 值对象 (UIColor或UIImage或NSString 如为不存在则返回nil)
 */
+ (id)getValueWithTag:(NSString *)tag Identifier:(NSString *)identifier;

@end

@interface LEEThemeConfigModel : NSObject

/** ----默认设置方式---- */

/** Block */

/** 主题改变Block -> 格式: .LeeThemeChangingBlock(^(NSString *tag , id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToChangingBlock LeeThemeChangingBlock;

/** 添加自定义设置 -> 格式: .LeeAddCustomConfig(@@"tag" , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Block LeeAddCustomConfig;

/** 添加多标签自定义设置 -> 格式: .LeeAddCustomConfigs(@@[tag1 , tag2] , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToTs_Block LeeAddCustomConfigs;

/** Color快捷设置方法 */

/** 添加渲染颜色设置 -> 格式: .LeeAddTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddTintColor;

/** 添加文本颜色设置 -> 格式: .LeeAddTextColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddTextColor;

/** 添加填充颜色设置 -> 格式: .LeeAddFillColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddFillColor;

/** 添加笔画颜色设置 -> 格式: .LeeAddStrokeColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddStrokeColor;

/** 添加边框颜色设置 -> 格式: .LeeAddBorderColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddBorderColor;

/** 添加阴影颜色设置 -> 格式: .LeeAddShadowColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddShadowColor;

/** 添加开关开启颜色设置 -> 格式: .LeeAddOnTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddOnTintColor;

/** 添加开关按钮颜色设置 -> 格式: .LeeAddThumbTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddThumbTintColor;

/** 添加分隔线颜色设置 -> 格式: .LeeAddSeparatorColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddSeparatorColor;

/** 添加bar渲染颜色设置 -> 格式: .LeeAddBarTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddBarTintColor;

/** 添加背景颜色设置 -> 格式: .LeeAddBackgroundColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddBackgroundColor;

/** 添加占位符颜色设置 -> 格式: .LeeAddPlaceholderColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddPlaceholderColor;

/** 添加进度轨道渲染颜色设置 -> 格式: .LeeAddTrackTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddTrackTintColor;

/** 添加进度渲染颜色设置 -> 格式: .LeeAddProgressTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddProgressTintColor;

/** 添加高亮文本颜色设置 -> 格式: .LeeAddHighlightedTextColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddHighlightedTextColor;

/** 添加页数指示渲染颜色设置 -> 格式: .LeeAddPageIndicatorTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddPageIndicatorTintColor;

/** 添加当前页数指示渲染颜色设置 -> 格式: .LeeAddCurrentPageIndicatorTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Color LeeAddCurrentPageIndicatorTintColor;

/** 添加按钮标题颜色设置 -> 格式: .LeeAddButtonTitleColor(@@"tag" , UIColor , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_ColorAndState LeeAddButtonTitleColor;

/** 添加按钮标题阴影颜色设置 -> 格式: .LeeAddButtonTitleShadowColor(@@"tag" , UIColor , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_ColorAndState LeeAddButtonTitleShadowColor;

/** Image快捷设置方法 */

/** 添加图片设置 -> 格式: .LeeAddImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddImage;

/** 添加进度轨道图片设置 -> 格式: .LeeAddTrackImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddTrackImage;

/** 添加进度图片设置 -> 格式: .LeeAddProgressImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddProgressImage;

/** 添加阴影图片设置 -> 格式: .LeeAddShadowImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddShadowImage;

/** 添加选中图片设置 -> 格式: .LeeAddSelectedImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddSelectedImage;

/** 添加背景图片设置 -> 格式: .LeeAddBackgroundImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddBackgroundImage;

/** 添加返回指示图片设置 -> 格式: .LeeAddBackIndicatorImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddBackIndicatorImage;

/** 添加返回指示图片设置 -> 格式: .LeeAddBackIndicatorTransitionMaskImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddBackIndicatorTransitionMaskImage;

/** 添加选择指示器图片设置 -> 格式: .LeeAddSelectionIndicatorImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddSelectionIndicatorImage;

/** 添加分栏背景图片设置 -> 格式: .LeeAddScopeBarBackgroundImage(@@"tag" , UIImage 或 @@"imageName" 或 @@"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Image LeeAddScopeBarBackgroundImage;

/** 添加按钮图片设置 -> 格式: .LeeAddButtonImage(@@"tag" , UIImage , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_ImageAndState LeeAddButtonImage;

/** 添加按钮背景图片设置 -> 格式: .LeeAddButtonBackgroundImage(@@"tag" , UIImage , UIControlStateNormal) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_ImageAndState LeeAddButtonBackgroundImage;


/** 添加颜色设置 -> 格式: .LeeAddSelectorAndColor(@@"tag" , @@selector(XXX:) , UIColor 或 @"F3F3F3") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_SelectorAndColor LeeAddSelectorAndColor;

/** 添加图片设置 -> 格式: .LeeAddSelectorAndImage(@@"tag" , @@selector(XXX:) , UIImage 或 @"imageName" 或 @"imagePath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_SelectorAndImage LeeAddSelectorAndImage;


/** 基础设置方法 */

/** 添加路径设置 -> 格式: .LeeAddKeyPathAndValue(@@"tag" , @@"keyPath" , id) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_KeyPathAndValue LeeAddKeyPathAndValue;

/** 添加方法设置 -> 格式: .LeeAddSelectorAndValues(@@"tag" , @@selector(XXX:XXX:) , id , id) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_SelectorAndValues LeeAddSelectorAndValues;

/** 添加方法设置 -> 格式: .LeeAddSelectorAndValueArray(@@"tag" , @@selector(XXX:XXX:) , @@[id , id]) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_SelectorAndValueArray LeeAddSelectorAndValueArray;

/** 移除路径设置 -> 格式: .LeeRemoveKeyPath(@@"tag" , @@"keyPath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_KeyPath LeeRemoveKeyPath;

/** 移除方法设置 -> 格式: .LeeRemoveSelector(@@"tag" , @@selector(XXX:XXX:)) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToT_Selector LeeRemoveSelector;


/** 移除全部设置 -> 格式: .LeeClearAllConfig() */
@property (nonatomic , copy , readonly ) LEEConfigTheme LeeClearAllConfig;

/** 移除标签全部的设置 -> 格式: .LeeClearAllConfig_Tag(@@"tag") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToTag LeeClearAllConfig_Tag;

/** 移除路径全部的设置 -> 格式: .LeeClearAllConfig_KeyPath(@@"keyPath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToKeyPath LeeClearAllConfig_KeyPath;

/** 移除方法全部的设置 -> 格式: .LeeClearAllConfig_Selector(@selector(XXXX:)) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToSelector LeeClearAllConfig_Selector;

@end

@interface LEEThemeConfigModel (IdentifierModeExtend)

/** Block */

/** 自定义设置 -> 格式: .LeeCustomConfig(@@"identifier" , ^(id item , id value){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifierAndBlock LeeCustomConfig;

/** Color快捷设置方法 */

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

/** Image快捷设置方法 */

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

/** 基础设置方法 */

/** 设置路径标识符 -> 格式: .LeeConfigKeyPathAndIdentifier(@@"keyPath" , @@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToKeyPathAndIdentifier LeeConfigKeyPathAndIdentifier;

/** 设置方法标识符 -> 格式: .LeeConfigSelectorAndIdentifier(@@selector(XXX:) , @@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToSelectorAndIdentifier LeeConfigSelectorAndIdentifier;

/** 设置方法标识符 -> 格式: .LeeConfigSelectorAndValueArray(@@selector(XXX:XXX:) , @@[id , id]) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToSelectorAndValues LeeConfigSelectorAndValueArray;

/** 移除路径标识符设置 -> 格式: .LeeRemoveKeyPathIdentifier(@@"keyPath") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToKeyPath LeeRemoveKeyPathIdentifier;

/** 移除方法标识符设置 -> 格式: .LeeRemoveSelectorIdentifier(@@selector(XXX:)) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToSelector LeeRemoveSelectorIdentifier;

/** 移除标识符设置 -> 格式: .LeeRemoveIdentifier(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToIdentifier LeeRemoveIdentifier;


/** 移除全部设置(标识符模式) -> 格式: .LeeClearAllConfigOnIdentifierMode() */
@property (nonatomic , copy , readonly ) LEEConfigTheme LeeClearAllConfigOnIdentifierMode;

@end

@interface LEEThemeIdentifier : NSString

+ (LEEThemeIdentifier *)ident:(NSString *)ident;

@end

@interface NSObject (LEEThemeConfigObject)

@property (nonatomic , strong ) LEEThemeConfigModel *lee_theme;

@end

@interface UIColor (LEEThemeColor)

+ (UIColor *)leeTheme_ColorWithHexString:(NSString *)hexString;

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
 *                 神兽 保佑
 *                 代码无BUG!
 */
