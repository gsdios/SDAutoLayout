
/*!
 *  @header LEEThemeHelper.h
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

FOUNDATION_EXPORT double LEEThemeVersionNumber;
FOUNDATION_EXPORT const unsigned char LEEThemeVersionString[];

#ifndef LEEThemeHelper_h
#define LEEThemeHelper_h

@class LEEThemeConfigModel;

#pragma mark - 宏

#define LEEColorRGBA(R , G , B , A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#define LEEColorRGB(R , G , B) LEEColorRGBA(R , G , B , 1.0f)

#define LEEColorHex(hex) [UIColor leeTheme_ColorWithHexString:hex]

#define LEEColorFromIdentifier(tag, identifier) ({((UIColor *)([LEETheme getValueWithTag:tag Identifier:identifier]));})

#define LEEImageFromIdentifier(tag, identifier) ({((UIImage *)([LEETheme getValueWithTag:tag Identifier:identifier]));})

#define LEEValueFromIdentifier(tag, identifier) ({([LEETheme getValueWithTag:tag Identifier:identifier]);})

#pragma mark - typedef

typedef void(^LEEThemeConfigBlock)(id item);
typedef void(^LEEThemeConfigBlockToValue)(id item , id value);
typedef void(^LEEThemeChangingBlock)(NSString *tag , id item);
typedef LEEThemeConfigModel *(^LEEConfigTheme)();
typedef LEEThemeConfigModel *(^LEEConfigThemeToFloat)(CGFloat number);
typedef LEEThemeConfigModel *(^LEEConfigThemeToTag)(NSString *tag);
typedef LEEThemeConfigModel *(^LEEConfigThemeToKeyPath)(NSString *keyPath);
typedef LEEThemeConfigModel *(^LEEConfigThemeToSelector)(SEL selector);
typedef LEEThemeConfigModel *(^LEEConfigThemeToIdentifier)(NSString *identifier);
typedef LEEThemeConfigModel *(^LEEConfigThemeToChangingBlock)(LEEThemeChangingBlock);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_KeyPath)(NSString *tag , NSString *keyPath);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_Selector)(NSString *tag , SEL selector);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_Color)(NSString *tag , id color);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_Image)(NSString *tag , id image);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_Block)(NSString *tag , LEEThemeConfigBlock);
typedef LEEThemeConfigModel *(^LEEConfigThemeToTs_Block)(NSArray *tags , LEEThemeConfigBlock);
typedef LEEThemeConfigModel *(^LEEConfigThemeToKeyPathAndIdentifier)(NSString *keyPath , NSString *identifier);
typedef LEEThemeConfigModel *(^LEEConfigThemeToSelectorAndIdentifier)(SEL sel , NSString *identifier);
typedef LEEThemeConfigModel *(^LEEConfigThemeToSelectorAndIdentifierAndValueIndexAndValueArray)(SEL sel , NSString *identifier , NSInteger valueIndex , NSArray *otherValues);
typedef LEEThemeConfigModel *(^LEEConfigThemeToSelectorAndValues)(SEL sel , NSArray *values);
typedef LEEThemeConfigModel *(^LEEConfigThemeToIdentifierAndState)(NSString *identifier , UIControlState state);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_ColorAndState)(NSString *tag , UIColor *color , UIControlState state);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_ImageAndState)(NSString *tag , UIImage *image , UIControlState state);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_KeyPathAndValue)(NSString *tag , NSString *keyPath , id value);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_SelectorAndColor)(NSString *tag , SEL sel , id color);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_SelectorAndImage)(NSString *tag , SEL sel , id image);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_SelectorAndValues)(NSString *tag , SEL sel , ...);
typedef LEEThemeConfigModel *(^LEEConfigThemeToT_SelectorAndValueArray)(NSString *tag , SEL sel , NSArray *values);
typedef LEEThemeConfigModel *(^LEEConfigThemeToIdentifierAndBlock)(NSString *identifier , LEEThemeConfigBlockToValue);

#endif /* LEEThemeHelper_h */
