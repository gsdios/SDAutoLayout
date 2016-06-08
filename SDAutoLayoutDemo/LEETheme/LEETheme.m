/*!
 *  @header LEETheme.m
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


#import "LEETheme.h"

#import <objc/runtime.h>

NSString * const LEEThemeChangingNotificaiton = @"LEEThemeChangingNotificaiton";
NSString * const LEEThemeCurrentTag = @"LEEThemeCurrentTag";


@interface LEETheme ()

@property (nonatomic , copy ) NSString *currentTag;

@property (nonatomic , copy ) NSMutableSet *allTags;

@property (nonatomic , copy ) NSMutableDictionary *jsonConfigInfo;

@end

@implementation LEETheme

+ (LEETheme *)shareTheme{
    
    static LEETheme *themeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        themeManager = [[LEETheme alloc]init];
    });
    
    return themeManager;
}

+ (void)startTheme:(NSString *)tag{
    
    [LEETheme shareTheme].currentTag = tag;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LEEThemeChangingNotificaiton object:nil userInfo:nil];
}

+ (NSString *)currentThemeTag{
    
    return [LEETheme shareTheme].currentTag ? [LEETheme shareTheme].currentTag : [[NSUserDefaults standardUserDefaults] objectForKey:LEEThemeCurrentTag];
}

+ (void)addThemeConfigJson:(NSString *)json WithTag:(NSString *)tag WithResourcesPath:(NSString *)path{
    
    if (json) {
        
        NSError *jsonError = nil;
        
        NSDictionary *jsonConfigInfo = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        
        NSAssert(!jsonError, @"添加的主题json配置数据解析错误 - 错误描述");
        NSAssert(jsonConfigInfo, @"添加的主题json配置数据解析为空 - 请检查");
        NSAssert(tag, @"添加的主题json标签不能为空");
        
        if (!jsonError) if(jsonConfigInfo) [[LEETheme shareTheme].jsonConfigInfo setValue:[NSMutableDictionary dictionaryWithObjectsAndKeys:jsonConfigInfo , @"json", path , @"path" , nil] forKey:tag];
        
        [[LEETheme shareTheme].allTags addObject:tag];
    }
    
}

- (void)setCurrentTag:(NSString *)currentTag{
    
    _currentTag = currentTag;
    
    [[NSUserDefaults standardUserDefaults] setObject:currentTag forKey:LEEThemeCurrentTag];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - LazyLoading

- (NSMutableSet *)allTags{
    
    if (!_allTags) _allTags = [NSMutableSet set];

    return _allTags;
}

- (NSMutableDictionary *)jsonConfigInfo{
    
    if (!_jsonConfigInfo) _jsonConfigInfo = [NSMutableDictionary dictionary];
    
    return _jsonConfigInfo;
}

@end

#pragma mark - ----------------主题设置模型----------------

typedef NS_ENUM(NSInteger, LEEThemeIdentifierConfigType) {
    
    /** 标识符设置类型 - Color */
    
    LEEThemeIdentifierConfigTypeTintColor,
    LEEThemeIdentifierConfigTypeTextColor,
    LEEThemeIdentifierConfigTypeFillColor,
    LEEThemeIdentifierConfigTypeStrokeColor,
    LEEThemeIdentifierConfigTypeBorderColor,
    LEEThemeIdentifierConfigTypeShadowColor,
    LEEThemeIdentifierConfigTypeOnTintColor,
    LEEThemeIdentifierConfigTypeThumbTintColor,
    LEEThemeIdentifierConfigTypeBarTintColor,
    LEEThemeIdentifierConfigTypeBackgroundColor,
    LEEThemeIdentifierConfigTypePlaceholderColor,
    LEEThemeIdentifierConfigTypeButtonTitleColor,
    LEEThemeIdentifierConfigTypeButtonTitleShadowColor,
    
    /** 标识符设置类型 - Image */
    
    LEEThemeIdentifierConfigTypeImage,
    LEEThemeIdentifierConfigTypeShadowImage,
    LEEThemeIdentifierConfigTypeSelectedImage,
    LEEThemeIdentifierConfigTypeBackgroundImage,
    LEEThemeIdentifierConfigTypeSelectionIndicatorImage,
    LEEThemeIdentifierConfigTypeScopeBarBackgroundImage,
    LEEThemeIdentifierConfigTypeButtonImage,
    LEEThemeIdentifierConfigTypeButtonBackgroundImage
    
};

@interface LEEThemeConfigModel ()

@property (nonatomic , copy ) void(^modelInitCurrentThemeConfig)();

@property (nonatomic , copy ) NSString *modelCurrentThemeTag;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeConfigInfo;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeIdentifierConfigInfo;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeTintColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeTextColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeFillColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeStrokeColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeBorderColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeShadowColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeOnTintColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeThumbTintColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeBarTintColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeBackgroundColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemePlaceholderColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeButtonTitleColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeButtonShadowTitleColorConfigInfo;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeImageNameConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeImagePathConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeShadowImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeShadowImageNameConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeShadowImagePathConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeSelectedImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeSelectedImageNameConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeSelectedImagePathConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeBackgroundImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeBackgroundImageNameConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeBackgroundImagePathConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeSelectionIndicatorImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeSelectionIndicatorImageNameConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeSelectionIndicatorImagePathConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeScopeBarBackgroundImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeScopeBarBackgroundImageNameConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeScopeBarBackgroundImagePathConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeButtonImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeButtonBackgroundImageConfigInfo;

@property (nonatomic , assign ) CGFloat modelChangeThemeAnimationDuration;

@end

@implementation LEEThemeConfigModel

- (void)dealloc{
    
    _modelCurrentThemeTag = nil;
    _modelThemeConfigInfo = nil;
    _modelThemeIdentifierConfigInfo = nil;
    
    _modelThemeTintColorConfigInfo = nil;
    _modelThemeTextColorConfigInfo = nil;
    _modelThemeFillColorConfigInfo = nil;
    _modelThemeStrokeColorConfigInfo = nil;
    _modelThemeBorderColorConfigInfo = nil;
    _modelThemeShadowColorConfigInfo = nil;
    _modelThemeOnTintColorConfigInfo = nil;
    _modelThemeThumbTintColorConfigInfo = nil;
    _modelThemeBarTintColorConfigInfo = nil;
    _modelThemeBackgroundColorConfigInfo = nil;
    _modelThemePlaceholderColorConfigInfo = nil;
    _modelThemeButtonTitleColorConfigInfo = nil;
    _modelThemeButtonShadowTitleColorConfigInfo = nil;
    
    _modelThemeImageConfigInfo = nil;
    _modelThemeImageNameConfigInfo = nil;
    _modelThemeImagePathConfigInfo = nil;
    _modelThemeShadowImageConfigInfo = nil;
    _modelThemeShadowImageNameConfigInfo = nil;
    _modelThemeShadowImagePathConfigInfo = nil;
    _modelThemeSelectedImageConfigInfo = nil;
    _modelThemeSelectedImageNameConfigInfo = nil;
    _modelThemeSelectedImagePathConfigInfo = nil;
    _modelThemeBackgroundImageConfigInfo = nil;
    _modelThemeBackgroundImageNameConfigInfo = nil;
    _modelThemeBackgroundImagePathConfigInfo = nil;
    _modelThemeSelectionIndicatorImageConfigInfo = nil;
    _modelThemeSelectionIndicatorImageNameConfigInfo = nil;
    _modelThemeSelectionIndicatorImagePathConfigInfo = nil;
    _modelThemeScopeBarBackgroundImageConfigInfo = nil;
    _modelThemeScopeBarBackgroundImageNameConfigInfo = nil;
    _modelThemeScopeBarBackgroundImagePathConfigInfo = nil;
    _modelThemeButtonImageConfigInfo = nil;
    _modelThemeButtonBackgroundImageConfigInfo = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //默认属性值
        
        _modelChangeThemeAnimationDuration = 0.2f; //默认更改主题动画时长为0.2秒
    }
    return self;
}

- (void)initCurrentThemeConfigHandleWithTag:(NSString *)tag{
    
    if ([[LEETheme currentThemeTag] isEqualToString:tag]) {
        
        if (self.modelInitCurrentThemeConfig) self.modelInitCurrentThemeConfig();
    }
    
}

- (void)initCurrentThemeConfigHandleWithIdentifier:(NSString *)identifier{
    
    if ([LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]]) {
        
        NSDictionary *tempJson = [LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]][@"json"];
        
        if (tempJson[@"color"][identifier] || tempJson[@"image"][identifier]) {
            
            if (self.modelInitCurrentThemeConfig) self.modelInitCurrentThemeConfig();
        }
    
    }
    
}

#pragma mark ***独立设置方式***

- (LEEConfigThemeToTagAndBlock)LeeAddCustomConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , LEEThemeConfigBlock configBlock){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeConfigInfo setObject:configBlock forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToTagsAndBlock)LeeAddCustomConfigs{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSArray *tags , LEEThemeConfigBlock configBlock){
        
        [[LEETheme shareTheme].allTags addObjectsFromArray:tags];
        
        [tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [weakSelf.modelThemeConfigInfo setObject:configBlock forKey:tag];
            
            [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        }];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeTintColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeTextColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddFillColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeFillColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddStrokeColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeStrokeColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddBorderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeBorderColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeShadowColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddOnTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeOnTintColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddThumbTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeThumbTintColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddBarTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeBarTintColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddBackgroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeBackgroundColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddPlaceholderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemePlaceholderColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColorAndState)LeeAddButtonTitleColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color , UIControlState state){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        NSMutableDictionary *info = weakSelf.modelThemeButtonTitleColorConfigInfo[tag];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:color forKey:@(state)];
        
        [weakSelf.modelThemeButtonTitleColorConfigInfo setObject:info forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColorAndState)LeeAddButtonTitleShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color , UIControlState state){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        NSMutableDictionary *info = weakSelf.modelThemeButtonShadowTitleColorConfigInfo[tag];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:color forKey:@(state)];
        
        [weakSelf.modelThemeButtonShadowTitleColorConfigInfo setObject:info forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImage)LeeAddImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeImageConfigInfo setObject:image forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddImageName{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imageName){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeImageNameConfigInfo setObject:imageName forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddImagePath{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imagePath){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeImagePathConfigInfo setObject:imagePath forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImage)LeeAddShadowImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeShadowImageConfigInfo setObject:image forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddShadowImageName{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imageName){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeShadowImageNameConfigInfo setObject:imageName forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddShadowImagePath{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imagePath){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeShadowImagePathConfigInfo setObject:imagePath forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImage)LeeAddSelectedImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeSelectedImageConfigInfo setObject:image forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddSelectedImageName{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imageName){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeSelectedImageNameConfigInfo setObject:imageName forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddSelectedImagePath{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imagePath){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeSelectedImagePathConfigInfo setObject:imagePath forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImage)LeeAddBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeBackgroundImageConfigInfo setObject:image forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddBackgroundImageName{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imageName){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeBackgroundImageNameConfigInfo setObject:imageName forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddBackgroundImagePath{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imagePath){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeBackgroundImagePathConfigInfo setObject:imagePath forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImage)LeeAddSelectionIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeSelectionIndicatorImageConfigInfo setObject:image forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddSelectionIndicatorImageName{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imageName){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeSelectionIndicatorImageNameConfigInfo setObject:imageName forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddSelectionIndicatorImagePath{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imagePath){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeSelectionIndicatorImagePathConfigInfo setObject:imagePath forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImage)LeeAddScopeBarBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeScopeBarBackgroundImageConfigInfo setObject:image forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddScopeBarBackgroundImageName{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imageName){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeScopeBarBackgroundImageNameConfigInfo setObject:imageName forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddScopeBarBackgroundImagePath{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imagePath){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeScopeBarBackgroundImagePathConfigInfo setObject:imagePath forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImageAndState)LeeAddButtonImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image , UIControlState state){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        NSMutableDictionary *info = weakSelf.modelThemeButtonImageConfigInfo[tag];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:image forKey:@(state)];
        
        [weakSelf.modelThemeButtonImageConfigInfo setObject:info forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImageAndState)LeeAddButtonBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image , UIControlState state){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        NSMutableDictionary *info = weakSelf.modelThemeButtonBackgroundImageConfigInfo[tag];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:image forKey:@(state)];
        
        [weakSelf.modelThemeButtonBackgroundImageConfigInfo setObject:info forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

#pragma mark ***JSON设置方式***

- (LEEConfigThemeToIdentifier)LeeConfigTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeTintColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeTextColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigFillColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeFillColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigStrokeColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeStrokeColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBorderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeBorderColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeShadowColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigOnTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeOnTintColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigThumbTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeThumbTintColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBarTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeBarTintColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackgroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeBackgroundColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigPlaceholderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypePlaceholderColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifierAndState)LeeConfigButtonTitleColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , UIControlState state){
        
        NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeButtonTitleColor)];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:identifier forKey:@(state)];
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:@(LEEThemeIdentifierConfigTypeButtonTitleColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifierAndState)LeeConfigButtonTitleShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , UIControlState state){
        
        NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeButtonTitleShadowColor)];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:identifier forKey:@(state)];
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:@(LEEThemeIdentifierConfigTypeButtonTitleShadowColor)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeImage)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigShadowImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeShadowImage)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigSelectedImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeSelectedImage)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeBackgroundImage)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigSelectionIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeSelectionIndicatorImage)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigScopeBarBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:@(LEEThemeIdentifierConfigTypeScopeBarBackgroundImage)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifierAndState)LeeConfigButtonImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , UIControlState state){
        
        NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeButtonImage)];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:identifier forKey:@(state)];
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:@(LEEThemeIdentifierConfigTypeButtonImage)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifierAndState)LeeConfigButtonBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , UIControlState state){
        
        NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeButtonBackgroundImage)];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:identifier forKey:@(state)];
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:@(LEEThemeIdentifierConfigTypeButtonBackgroundImage)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToFloat)LeeChangeThemeAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelChangeThemeAnimationDuration = number;
        
        return weakSelf;
    };
    
}

#pragma mark - LazyLoading

- (NSMutableDictionary *)modelThemeConfigInfo{
    
    if (!_modelThemeConfigInfo) _modelThemeConfigInfo = [NSMutableDictionary dictionary];

    return _modelThemeConfigInfo;
}

- (NSMutableDictionary *)modelThemeIdentifierConfigInfo{
    
    if (!_modelThemeIdentifierConfigInfo) _modelThemeIdentifierConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeIdentifierConfigInfo;
}

- (NSMutableDictionary *)modelThemeTintColorConfigInfo{
    
    if (!_modelThemeTintColorConfigInfo) _modelThemeTintColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeTintColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeTextColorConfigInfo{
    
    if (!_modelThemeTextColorConfigInfo) _modelThemeTextColorConfigInfo = [NSMutableDictionary dictionary];

    return _modelThemeTextColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeFillColorConfigInfo{
    
    if (!_modelThemeFillColorConfigInfo) _modelThemeFillColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeFillColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeStrokeColorConfigInfo{
    
    if (!_modelThemeStrokeColorConfigInfo) _modelThemeStrokeColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeStrokeColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeBorderColorConfigInfo{
    
    if (!_modelThemeBorderColorConfigInfo) _modelThemeBorderColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBorderColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeShadowColorConfigInfo{
    
    if (!_modelThemeShadowColorConfigInfo) _modelThemeShadowColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeShadowColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeOnTintColorConfigInfo{
    
    if (!_modelThemeOnTintColorConfigInfo) _modelThemeOnTintColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeOnTintColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeThumbTintColorConfigInfo{
    
    if (!_modelThemeThumbTintColorConfigInfo) _modelThemeThumbTintColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeThumbTintColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeBarTintColorConfigInfo{
    
    if (!_modelThemeBarTintColorConfigInfo) _modelThemeBarTintColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBarTintColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeBackgroundColorConfigInfo{
    
    if (!_modelThemeBackgroundColorConfigInfo) _modelThemeBackgroundColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBackgroundColorConfigInfo;
}

- (NSMutableDictionary *)modelThemePlaceholderColorConfigInfo{
    
    if (!_modelThemePlaceholderColorConfigInfo) _modelThemePlaceholderColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemePlaceholderColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeButtonTitleColorConfigInfo{
    
    if(!_modelThemeButtonTitleColorConfigInfo) _modelThemeButtonTitleColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeButtonTitleColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeButtonShadowTitleColorConfigInfo{
    
    if (!_modelThemeButtonShadowTitleColorConfigInfo) _modelThemeButtonShadowTitleColorConfigInfo = [NSMutableDictionary dictionary];
        
    return _modelThemeButtonShadowTitleColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeImageConfigInfo{
    
    if (!_modelThemeImageConfigInfo) _modelThemeImageConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeImageConfigInfo;
}

- (NSMutableDictionary *)modelThemeImageNameConfigInfo{
    
    if (!_modelThemeImageNameConfigInfo) _modelThemeImageNameConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeImageNameConfigInfo;
}

- (NSMutableDictionary *)modelThemeImagePathConfigInfo{
    
    if (!_modelThemeImagePathConfigInfo) _modelThemeImagePathConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeImagePathConfigInfo;
}

- (NSMutableDictionary *)modelThemeShadowImageConfigInfo{
    
    if (!_modelThemeShadowImageConfigInfo) _modelThemeShadowImageConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeShadowImageConfigInfo;
}

- (NSMutableDictionary *)modelThemeShadowImageNameConfigInfo{
    
    if (!_modelThemeShadowImageNameConfigInfo) _modelThemeShadowImageNameConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeShadowImageNameConfigInfo;
}

- (NSMutableDictionary *)modelThemeShadowImagePathConfigInfo{
    
    if (!_modelThemeShadowImagePathConfigInfo) _modelThemeShadowImagePathConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeShadowImagePathConfigInfo;
}

- (NSMutableDictionary *)modelThemeSelectedImageConfigInfo{
    
    if (!_modelThemeSelectedImageConfigInfo) _modelThemeSelectedImageConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeSelectedImageConfigInfo;
}

- (NSMutableDictionary *)modelThemeSelectedImageNameConfigInfo{
    
    if (!_modelThemeSelectedImageNameConfigInfo) _modelThemeSelectedImageNameConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeSelectedImageNameConfigInfo;
}

- (NSMutableDictionary *)modelThemeSelectedImagePathConfigInfo{
    
    if (!_modelThemeSelectedImagePathConfigInfo) _modelThemeSelectedImagePathConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeSelectedImagePathConfigInfo;
}

- (NSMutableDictionary *)modelThemeBackgroundImageConfigInfo{
    
    if (!_modelThemeBackgroundImageConfigInfo) _modelThemeBackgroundImageConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBackgroundImageConfigInfo;
}

- (NSMutableDictionary *)modelThemeBackgroundImageNameConfigInfo{
    
    if (!_modelThemeBackgroundImageNameConfigInfo) _modelThemeBackgroundImageNameConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBackgroundImageNameConfigInfo;
}

- (NSMutableDictionary *)modelThemeBackgroundImagePathConfigInfo{
    
    if (!_modelThemeBackgroundImagePathConfigInfo) _modelThemeBackgroundImagePathConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBackgroundImagePathConfigInfo;
}

- (NSMutableDictionary *)modelThemeSelectionIndicatorImageConfigInfo{
    
    if (!_modelThemeSelectionIndicatorImageConfigInfo) _modelThemeSelectionIndicatorImageConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeSelectionIndicatorImageConfigInfo;
}

- (NSMutableDictionary *)modelThemeSelectionIndicatorImageNameConfigInfo{
    
    if (!_modelThemeSelectionIndicatorImageNameConfigInfo) _modelThemeSelectionIndicatorImageNameConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeSelectionIndicatorImageNameConfigInfo;
}

- (NSMutableDictionary *)modelThemeSelectionIndicatorImagePathConfigInfo{
    
    if (!_modelThemeSelectionIndicatorImagePathConfigInfo) _modelThemeSelectionIndicatorImagePathConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeSelectionIndicatorImagePathConfigInfo;
}

- (NSMutableDictionary *)modelThemeScopeBarBackgroundImageConfigInfo{
    
    if (!_modelThemeScopeBarBackgroundImageConfigInfo) _modelThemeScopeBarBackgroundImageConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeScopeBarBackgroundImageConfigInfo;
}

- (NSMutableDictionary *)modelThemeScopeBarBackgroundImageNameConfigInfo{
    
    if (!_modelThemeScopeBarBackgroundImageNameConfigInfo) _modelThemeScopeBarBackgroundImageNameConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeScopeBarBackgroundImageNameConfigInfo;
}

- (NSMutableDictionary *)modelThemeScopeBarBackgroundImagePathConfigInfo{
    
    if (!_modelThemeScopeBarBackgroundImagePathConfigInfo) _modelThemeScopeBarBackgroundImagePathConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeScopeBarBackgroundImagePathConfigInfo;
}

- (NSMutableDictionary *)modelThemeButtonImageConfigInfo{
    
    if (!_modelThemeButtonImageConfigInfo) _modelThemeButtonImageConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeButtonImageConfigInfo;
}

- (NSMutableDictionary *)modelThemeButtonBackgroundImageConfigInfo{
    
    if (!_modelThemeButtonBackgroundImageConfigInfo) _modelThemeButtonBackgroundImageConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeButtonBackgroundImageConfigInfo;
}

@end

#pragma mark - ----------------主题设置----------------

@implementation NSObject (LEEThemeConfigObject)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"dealloc"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *leeSelString = [@"lee_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            
            method_exchangeImplementations(originalMethod, leeMethod);
        }];
        
    });
    
}

- (void)lee_dealloc{
    
    if ([self isLeeTheme]) [[NSNotificationCenter defaultCenter] removeObserver:self name:LEEThemeChangingNotificaiton object:nil];
    
    if ([self isLeeTheme]) objc_removeAssociatedObjects(self);
    
    [self lee_dealloc];
}

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThemeConfigNotify:) name:LEEThemeChangingNotificaiton object:nil];
}

- (void)changeThemeConfigNotify:(NSNotification *)notify{
    
    [self changeThemeConfigWithAboutConfigBlock:nil];
}

- (BOOL)isChangeTheme{
    
    return (!self.lee_theme.modelCurrentThemeTag || ![self.lee_theme.modelCurrentThemeTag isEqualToString:[LEETheme currentThemeTag]]) ? YES : NO;
}

- (UIColor *)getCurrentThemeTagColorWithType:(LEEThemeIdentifierConfigType)type{
    
    NSString *colorHexString = [LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]][@"json"][@"color"][self.lee_theme.modelThemeIdentifierConfigInfo[@(type)]];
    
    return colorHexString ? [UIColor leeTheme_ColorWithHexString:colorHexString] : nil;
}

- (UIColor *)getCurrentThemeTagButtonColorWithType:(LEEThemeIdentifierConfigType)type WithState:(NSNumber *)state{
    
    NSDictionary *info = self.lee_theme.modelThemeIdentifierConfigInfo[@(type)];
    
    NSString *identifier = info[state];
    
    NSString *colorHexString = [LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]][@"json"][@"color"][identifier];
    
    return colorHexString ? [UIColor leeTheme_ColorWithHexString:colorHexString] : nil;
}

- (UIImage *)getCurrentThemeTagImageWithType:(LEEThemeIdentifierConfigType)type{
    
    NSString *imageName = [LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]][@"json"][@"image"][self.lee_theme.modelThemeIdentifierConfigInfo[@(type)]];
    
    NSString *path = [LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]][@"path"];
    
    UIImage *image = path ? [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]] : [UIImage imageNamed:imageName];
    
    return image;
}

- (UIImage *)getCurrentThemeTagButtonImageWithType:(LEEThemeIdentifierConfigType)type WithState:(NSNumber *)state{
    
    NSDictionary *info = self.lee_theme.modelThemeIdentifierConfigInfo[@(type)];
    
    NSString *identifier = info[state];
    
    NSString *imageName = [LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]][@"json"][@"image"][identifier];
    
    NSString *path = [LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]][@"path"];
    
    UIImage *image = path ? [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]] : [UIImage imageNamed:imageName];
    
    return image;
}

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        self.lee_theme.modelCurrentThemeTag = [LEETheme currentThemeTag];
        
        NSDictionary *themeConfigInfo = self.lee_theme.modelThemeConfigInfo;
        
        LEEThemeConfigBlock configBlock = themeConfigInfo[[LEETheme currentThemeTag]];
        
        [UIView beginAnimations:@"LEEThemeChangeAnimations" context:nil];
        
        [UIView setAnimationDuration:self.lee_theme.modelChangeThemeAnimationDuration];
        
        if (aboutConfigBlock) aboutConfigBlock();
        
        if (configBlock) configBlock(self);
        
        [UIView commitAnimations];
    }
    
}

- (LEEThemeConfigModel *)lee_theme{
    
    LEEThemeConfigModel *model = objc_getAssociatedObject(self, _cmd);
    
    if (!model) {
        
        if ([self isKindOfClass:[LEEThemeConfigModel class]]) {
            
            return nil;
        }
        
        model = [LEEThemeConfigModel new];
        
        objc_setAssociatedObject(self, _cmd, model , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self addNotification];
        
        [self setIsLeeTheme:YES];
        
        __weak typeof(self) weakSelf = self;
        
        model.modelInitCurrentThemeConfig = ^(){
            
            weakSelf.lee_theme.modelCurrentThemeTag = nil;
            
            if (weakSelf) [weakSelf changeThemeConfigWithAboutConfigBlock:nil];
        };
        
    }
    
    return model;
}

- (void)setLee_theme:(LEEThemeConfigModel *)lee_theme{
    
    objc_setAssociatedObject(self, @selector(lee_theme), lee_theme , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLeeTheme{
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsLeeTheme:(BOOL)isLeeTheme{
    
    objc_setAssociatedObject(self, @selector(isLeeTheme), @(isLeeTheme) , OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation CALayer (LEEThemeConfigLayer)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        void (^tempAboutConfigBlock)() = aboutConfigBlock;
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            if (tempAboutConfigBlock) tempAboutConfigBlock();
            
            UIColor *borderColor = weakSelf.lee_theme.modelThemeBorderColorConfigInfo[[LEETheme currentThemeTag]];
            
            UIColor *shadowColor = weakSelf.lee_theme.modelThemeShadowColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!borderColor) borderColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeBorderColor];
            
            if (!shadowColor) shadowColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeShadowColor];
            
            if (borderColor) [weakSelf setBorderColor:borderColor.CGColor];
            
            if (shadowColor) [weakSelf setShadowColor:shadowColor.CGColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation CAShapeLayer (LEEThemeConfigShapeLayer)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
          
            UIColor *fillColor = weakSelf.lee_theme.modelThemeFillColorConfigInfo[[LEETheme currentThemeTag]];
            
            UIColor *strokeColor = weakSelf.lee_theme.modelThemeStrokeColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!fillColor) fillColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeFillColor];
            
            if (!strokeColor) strokeColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeStrokeColor];
            
            if (fillColor) [weakSelf setFillColor:fillColor.CGColor];
            
            if (strokeColor) [weakSelf setStrokeColor:strokeColor.CGColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UIView (LEEThemeConfigView)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        void (^tempAboutConfigBlock)() = aboutConfigBlock;
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            if (tempAboutConfigBlock) tempAboutConfigBlock();
            
            UIColor *backgroundColor = weakSelf.lee_theme.modelThemeBackgroundColorConfigInfo[[LEETheme currentThemeTag]];
            
            UIColor *tintColor = weakSelf.lee_theme.modelThemeTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!backgroundColor) backgroundColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeBackgroundColor];
            
            if (!tintColor) tintColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeTintColor];
            
            if (backgroundColor) [weakSelf setBackgroundColor:backgroundColor];
            
            if (tintColor) [weakSelf setTintColor:tintColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UITextField (LEEThemeConfigTextField)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            UIColor *textColor = weakSelf.lee_theme.modelThemeTextColorConfigInfo[[LEETheme currentThemeTag]];
            
            UIColor *placeholderColor = weakSelf.lee_theme.modelThemePlaceholderColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!textColor) textColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeTextColor];
            
            if (!placeholderColor) placeholderColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypePlaceholderColor];
            
            if (textColor) [weakSelf setTextColor:textColor];
            
            if (placeholderColor) [weakSelf setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UITextView (LEEThemeConfigTextView)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            UIColor *textColor = weakSelf.lee_theme.modelThemeTextColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!textColor) textColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeTextColor];
            
            if (textColor) [weakSelf setTextColor:textColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UILabel (LEEThemeConfigLabel)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
     
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
          
            UIColor *textColor = weakSelf.lee_theme.modelThemeTextColorConfigInfo[[LEETheme currentThemeTag]];
            
            UIColor *shadowColor = weakSelf.lee_theme.modelThemeShadowColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!textColor) textColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeTextColor];
            
            if (!shadowColor) shadowColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeShadowColor];
            
            if (textColor) [weakSelf setTextColor:textColor];
            
            if (shadowColor) [weakSelf setShadowColor:shadowColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UISwitch (LEEThemeConfigSwitch)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            UIColor *onTintColor = weakSelf.lee_theme.modelThemeOnTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            UIColor *thumbTintColor = weakSelf.lee_theme.modelThemeThumbTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!onTintColor) onTintColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeOnTintColor];
            
            if (!thumbTintColor) thumbTintColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeThumbTintColor];
            
            if (onTintColor) [weakSelf setOnTintColor:onTintColor];
            
            if (thumbTintColor) [weakSelf setThumbTintColor:thumbTintColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UISearchBar (LEEThemeConfigSearchBar)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            UIColor *barTintColor = weakSelf.lee_theme.modelThemeBarTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!barTintColor) barTintColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeBarTintColor];
            
            if (barTintColor) [weakSelf setBarTintColor:barTintColor];
            
            UIImage *backgroundImage = weakSelf.lee_theme.modelThemeBackgroundImageConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *backgroundImageName = weakSelf.lee_theme.modelThemeBackgroundImageNameConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *backgroundImagePath = weakSelf.lee_theme.modelThemeBackgroundImagePathConfigInfo[[LEETheme currentThemeTag]];
            
            UIImage *scopeBarBackgroundImage = weakSelf.lee_theme.modelThemeScopeBarBackgroundImageConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *scopeBarBackgroundImageName = weakSelf.lee_theme.modelThemeScopeBarBackgroundImageNameConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *scopeBarBackgroundImagePath = weakSelf.lee_theme.modelThemeScopeBarBackgroundImagePathConfigInfo[[LEETheme currentThemeTag]];
            
            if (!backgroundImage) backgroundImage = [UIImage imageNamed:backgroundImageName];
            
            if (!backgroundImage) backgroundImage = [UIImage imageWithContentsOfFile:backgroundImagePath];
            
            if (!backgroundImage) backgroundImage = [weakSelf getCurrentThemeTagImageWithType:LEEThemeIdentifierConfigTypeBackgroundImage];
            
            if (backgroundImage) [weakSelf setBackgroundImage:backgroundImage];
            
            if (!scopeBarBackgroundImage) scopeBarBackgroundImage = [UIImage imageNamed:scopeBarBackgroundImageName];
            
            if (!scopeBarBackgroundImage) scopeBarBackgroundImage = [UIImage imageWithContentsOfFile:scopeBarBackgroundImagePath];
            
            if (!scopeBarBackgroundImage) scopeBarBackgroundImage = [weakSelf getCurrentThemeTagImageWithType:LEEThemeIdentifierConfigTypeScopeBarBackgroundImage];
            
            if (scopeBarBackgroundImage) [weakSelf setScopeBarBackgroundImage:scopeBarBackgroundImage];
            
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UINavigationBar (LEEThemeConfigNavigationBar)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            UIColor *barTintColor = weakSelf.lee_theme.modelThemeBarTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!barTintColor) barTintColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeBarTintColor];
            
            if (barTintColor) [weakSelf setBarTintColor:barTintColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UITabBar (LEEThemeConfigTabBar)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            UIColor *barTintColor = weakSelf.lee_theme.modelThemeBarTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!barTintColor) barTintColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeBarTintColor];
            
            if (barTintColor) [weakSelf setBarTintColor:barTintColor];
            
            UIImage *shadowImage = weakSelf.lee_theme.modelThemeShadowImageConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *shadowImageName = weakSelf.lee_theme.modelThemeShadowImageNameConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *shadowImagePath = weakSelf.lee_theme.modelThemeShadowImagePathConfigInfo[[LEETheme currentThemeTag]];
            
            UIImage *backgroundImage = weakSelf.lee_theme.modelThemeBackgroundImageConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *backgroundImageName = weakSelf.lee_theme.modelThemeBackgroundImageNameConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *backgroundImagePath = weakSelf.lee_theme.modelThemeBackgroundImagePathConfigInfo[[LEETheme currentThemeTag]];
            
            UIImage *selectionIndicatorImage = weakSelf.lee_theme.modelThemeSelectionIndicatorImageConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *selectionIndicatorImageName = weakSelf.lee_theme.modelThemeSelectionIndicatorImageNameConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *selectionIndicatorImagePath = weakSelf.lee_theme.modelThemeSelectionIndicatorImagePathConfigInfo[[LEETheme currentThemeTag]];
            
            if (!shadowImage) shadowImage = [UIImage imageNamed:shadowImageName];
            
            if (!shadowImage) shadowImage = [UIImage imageWithContentsOfFile:shadowImagePath];
            
            if (!shadowImage) shadowImage = [weakSelf getCurrentThemeTagImageWithType:LEEThemeIdentifierConfigTypeShadowImage];
            
            if (shadowImage) [weakSelf setShadowImage:shadowImage];
            
            if (!backgroundImage) backgroundImage = [UIImage imageNamed:backgroundImageName];
            
            if (!backgroundImage) backgroundImage = [UIImage imageWithContentsOfFile:backgroundImagePath];
            
            if (!backgroundImage) backgroundImage = [weakSelf getCurrentThemeTagImageWithType:LEEThemeIdentifierConfigTypeBackgroundImage];
            
            if (backgroundImage) [weakSelf setBackgroundImage:backgroundImage];
            
            if (!selectionIndicatorImage) selectionIndicatorImage = [UIImage imageNamed:selectionIndicatorImageName];
            
            if (!selectionIndicatorImage) selectionIndicatorImage = [UIImage imageWithContentsOfFile:selectionIndicatorImagePath];
            
            if (!selectionIndicatorImage) selectionIndicatorImage = [weakSelf getCurrentThemeTagImageWithType:LEEThemeIdentifierConfigTypeSelectionIndicatorImage];
            
            if (selectionIndicatorImage) [weakSelf setSelectionIndicatorImage:selectionIndicatorImage];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UIToolbar (LEEThemeConfigToolbar)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            UIColor *barTintColor = weakSelf.lee_theme.modelThemeBarTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!barTintColor) barTintColor = [weakSelf getCurrentThemeTagColorWithType:LEEThemeIdentifierConfigTypeBarTintColor];
            
            if (barTintColor) [weakSelf setBarTintColor:barTintColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UIBarItem (LEEThemeConfigBarItem)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        void (^tempAboutConfigBlock)() = aboutConfigBlock;
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            if (tempAboutConfigBlock) tempAboutConfigBlock();
            
            UIImage *image = weakSelf.lee_theme.modelThemeImageConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *imageName = weakSelf.lee_theme.modelThemeImageNameConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *imagePath = weakSelf.lee_theme.modelThemeImagePathConfigInfo[[LEETheme currentThemeTag]];
            
            if (!image) image = [UIImage imageNamed:imageName];
            
            if (!image) image = [UIImage imageWithContentsOfFile:imagePath];
            
            if (!image) image = [weakSelf getCurrentThemeTagImageWithType:LEEThemeIdentifierConfigTypeImage];
            
            if (image) [weakSelf setImage:image];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UITabBarItem (LEEThemeConfigTabBarItem)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            UIImage *selectedImage = weakSelf.lee_theme.modelThemeSelectedImageConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *selectedImageName = weakSelf.lee_theme.modelThemeSelectedImageNameConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *selectedImagePath = weakSelf.lee_theme.modelThemeSelectedImagePathConfigInfo[[LEETheme currentThemeTag]];
            
            if (!selectedImage) selectedImage = [UIImage imageNamed:selectedImageName];
            
            if (!selectedImage) selectedImage = [UIImage imageWithContentsOfFile:selectedImagePath];
            
            if (!selectedImage) selectedImage = [weakSelf getCurrentThemeTagImageWithType:LEEThemeIdentifierConfigTypeSelectedImage];
            
            if (selectedImage) [weakSelf setSelectedImage:selectedImage];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UIButton (LEEThemeConfigButton)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
            
            NSDictionary *titleColorInfo = weakSelf.lee_theme.modelThemeButtonTitleColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!titleColorInfo) titleColorInfo = weakSelf.lee_theme.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeButtonTitleColor)];
            
            for (NSNumber *key in titleColorInfo.allKeys) {
                
                id value = titleColorInfo[key];
                
                UIColor *titleColor = [value isKindOfClass:[UIColor class]] ? value : nil;
                
                if (!titleColor) titleColor = [weakSelf getCurrentThemeTagButtonColorWithType:LEEThemeIdentifierConfigTypeButtonTitleColor WithState:key];
                
                if (titleColor) [weakSelf setTitleColor:titleColor forState:(UIControlState)[key integerValue]];
            }
            
            NSDictionary *titleShadowColorInfo = weakSelf.lee_theme.modelThemeButtonShadowTitleColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (!titleShadowColorInfo) titleShadowColorInfo = weakSelf.lee_theme.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeButtonTitleShadowColor)];
            
            for (NSNumber *key in titleShadowColorInfo.allKeys) {
                
                id value = titleShadowColorInfo[key];
                
                UIColor *titleShadowColor = [value isKindOfClass:[UIColor class]] ? value : nil;
                
                if (!titleShadowColor) titleShadowColor = [weakSelf getCurrentThemeTagButtonColorWithType:LEEThemeIdentifierConfigTypeButtonTitleShadowColor WithState:key];
                
                if (titleShadowColor) [weakSelf setTitleShadowColor:titleShadowColor forState:(UIControlState)[key integerValue]];
            }
            
            NSDictionary *imageInfo = weakSelf.lee_theme.modelThemeButtonImageConfigInfo[[LEETheme currentThemeTag]];
            
            if (!imageInfo) imageInfo = weakSelf.lee_theme.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeButtonImage)];
            
            for (NSNumber *key in imageInfo.allKeys) {
                
                id value = imageInfo[key];
                
                UIImage *image = [value isKindOfClass:[UIImage class]] ? value : nil;
                
                if (!image) image = [weakSelf getCurrentThemeTagButtonImageWithType:LEEThemeIdentifierConfigTypeButtonImage WithState:key];
                
                if (image) [weakSelf setImage:image forState:(UIControlState)[key integerValue]];
            }
            
            NSDictionary *backgroundImageInfo = weakSelf.lee_theme.modelThemeButtonBackgroundImageConfigInfo[[LEETheme currentThemeTag]];
            
            if (!backgroundImageInfo) backgroundImageInfo = weakSelf.lee_theme.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeButtonBackgroundImage)];
            
            for (NSNumber *key in backgroundImageInfo.allKeys) {
                
                id value = backgroundImageInfo[key];
                
                UIImage *backgroundImage = [value isKindOfClass:[UIImage class]] ? value : nil;
                
                if (!backgroundImage) backgroundImage = [weakSelf getCurrentThemeTagButtonImageWithType:LEEThemeIdentifierConfigTypeButtonBackgroundImage WithState:key];
                
                if (backgroundImage) [weakSelf setBackgroundImage:backgroundImage forState:(UIControlState)[key integerValue]];
            }
            
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UIImageView (LEEThemeConfigImageView)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        __weak typeof(self) weakSelf = self;
        
        aboutConfigBlock = ^(){
        
            UIImage *image = weakSelf.lee_theme.modelThemeImageConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *imageName = weakSelf.lee_theme.modelThemeImageNameConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *imagePath = weakSelf.lee_theme.modelThemeImagePathConfigInfo[[LEETheme currentThemeTag]];
            
            if (!image) image = [UIImage imageNamed:imageName];
            
            if (!image) image = [UIImage imageWithContentsOfFile:imagePath];
            
            if (!image) image = [weakSelf getCurrentThemeTagImageWithType:LEEThemeIdentifierConfigTypeImage];
            
            if (image) [weakSelf setImage:image];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end


#pragma mark - ----------------工具扩展----------------

@implementation UIColor (LEEThemeColor)

+ (UIColor *)leeTheme_ColorWithHexString:(NSString *)hexString{
    
    if (!hexString) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 0:
            return nil;
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            alpha = 0, red = 0, blue = 0, green = 0;
            break;
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start:(NSUInteger) start length:(NSUInteger) length{
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0f;
}

@end
