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
 *  @version    V1.0.7
 */


#import "LEETheme.h"

#import <objc/runtime.h>

NSString * const LEEThemeChangingNotificaiton = @"LEEThemeChangingNotificaiton";
NSString * const LEEThemeCurrentTag = @"LEEThemeCurrentTag";

@interface LEETheme ()

@property (nonatomic , copy ) NSString *currentTag;

@property (nonatomic , copy ) NSMutableSet *allTags;

@property (nonatomic , copy ) NSMutableDictionary *jsonConfigInfo;

@property (nonatomic , assign ) CGFloat animationDuration;

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
    
    NSAssert([[LEETheme shareTheme].allTags containsObject:tag], @"所启用的主题不存在 - 请检查是否添加了该%@主题的设置" , tag);
    
    [LEETheme shareTheme].currentTag = tag;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LEEThemeChangingNotificaiton object:nil userInfo:nil];
}

+ (void)defaultTheme:(NSString *)tag{
    
    if (![LEETheme shareTheme].currentTag && ![[NSUserDefaults standardUserDefaults] objectForKey:LEEThemeCurrentTag]) [LEETheme shareTheme].currentTag = tag;
}

+ (void)defaultChangeThemeAnimationDuration:(CGFloat)duration{
    
    NSAssert(duration >= 0, @"默认的更改主题动画时长不能小于0秒");
    
    [LEETheme shareTheme].animationDuration = duration;
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

+ (NSString *)getResourcesPathWithTag:(NSString *)tag{
    
    NSString *path = [LEETheme shareTheme].jsonConfigInfo[tag][@"path"];
    
    return path ? path : [[NSBundle mainBundle] bundlePath];
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
    
    /** 标识符设置类型 - Block */
    
    LEEThemeIdentifierConfigTypeCustomConfig,
    
    /** 标识符设置类型 - Color */

    LEEThemeIdentifierConfigTypeButtonTitleColor,
    LEEThemeIdentifierConfigTypeButtonTitleShadowColor,
    
    /** 标识符设置类型 - Image */
    
    LEEThemeIdentifierConfigTypeButtonImage,
    LEEThemeIdentifierConfigTypeButtonBackgroundImage
    
};

@interface LEEThemeConfigModel ()

@property (nonatomic , copy ) void(^modelInitCurrentThemeConfig)();

@property (nonatomic , copy ) NSString *modelCurrentThemeTag;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeIdentifierConfigInfo;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeButtonTitleColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeButtonShadowTitleColorConfigInfo;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeButtonImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeButtonBackgroundImageConfigInfo;

@property (nonatomic , assign ) CGFloat modelChangeThemeAnimationDuration;

@end

@implementation LEEThemeConfigModel

- (void)dealloc{
    
    _modelCurrentThemeTag = nil;
    _modelThemeConfigInfo = nil;
    _modelThemeIdentifierConfigInfo = nil;
    
    _modelThemeColorConfigInfo = nil;
    _modelThemeButtonTitleColorConfigInfo = nil;
    _modelThemeButtonShadowTitleColorConfigInfo = nil;
    
    _modelThemeImageConfigInfo = nil;
    _modelThemeButtonImageConfigInfo = nil;
    _modelThemeButtonBackgroundImageConfigInfo = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //默认属性值
        
        _modelChangeThemeAnimationDuration = -1.f; //默认为小于0
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

- (LEEConfigThemeToStringAndBlock)LeeAddCustomConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , LEEThemeConfigBlock configBlock){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeConfigInfo setObject:configBlock forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToArrayAndBlock)LeeAddCustomConfigs{
    
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

- (LEEConfigThemeToKeyPathAndColor)LeeAddKeyPathAndColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *keyPath , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        NSMutableDictionary *info = [weakSelf.modelThemeColorConfigInfo objectForKey:keyPath];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:color forKey:tag];
        
        [weakSelf.modelThemeColorConfigInfo setObject:info forKey:keyPath];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"tintColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"textColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddFillColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"fillColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddStrokeColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"strokeColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddBorderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"borderColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"shadowColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddOnTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"onTintColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddThumbTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"thumbTintColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddSeparatorColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"separatorColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddBarTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"barTintColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddBackgroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"backgroundColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddPlaceholderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"_placeholderLabel.textColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddTrackTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"trackTintColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddProgressTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"progressTintColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddHighlightedTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"highlightedTextColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddCurrentPageIndicatorTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"currentPageIndicatorTintColor" , color);
    };
    
}

- (LEEConfigThemeToColor)LeeAddPageIndicatorTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        return weakSelf.LeeAddKeyPathAndColor(tag , @"pageIndicatorTintColor" , color);
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

- (LEEConfigThemeToKeyPathAndImage)LeeAddKeyPathAndImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *keyPath , id image){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        NSMutableDictionary *info = [weakSelf.modelThemeImageConfigInfo objectForKey:keyPath];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:image forKey:tag];
        
        [weakSelf.modelThemeImageConfigInfo setObject:info forKey:keyPath];
        
        [weakSelf initCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImage)LeeAddImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"image" , image);
    };
    
}

- (LEEConfigThemeToImage)LeeAddTrackImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"trackImage" , image);
    };
    
}

- (LEEConfigThemeToImage)LeeAddProgressImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"progressImage" , image);
    };
    
}

- (LEEConfigThemeToImage)LeeAddShadowImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"shadowImage" , image);
    };
    
}

- (LEEConfigThemeToImage)LeeAddSelectedImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"selectedImage" , image);
    };
    
}

- (LEEConfigThemeToImage)LeeAddBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"backgroundImage" , image);
    };
    
}

- (LEEConfigThemeToImage)LeeAddBackIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"backIndicatorImage" , image);
    };
    
}

- (LEEConfigThemeToImage)LeeAddBackIndicatorTransitionMaskImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"backIndicatorTransitionMaskImage" , image);
    };
    
}

- (LEEConfigThemeToImage)LeeAddSelectionIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"selectionIndicatorImage" , image);
    };
    
}

- (LEEConfigThemeToImage)LeeAddScopeBarBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddKeyPathAndImage(tag , @"scopeBarBackgroundImage" , image);
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

- (LEEConfigThemeToIdentifierAndBlock)LeeCustomConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , LEEThemeConfigBlockToIdentifier configBlock){
        
        NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeCustomConfig)];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:configBlock forKey:identifier];
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:@(LEEThemeIdentifierConfigTypeCustomConfig)];
        
        [weakSelf initCurrentThemeConfigHandleWithIdentifier:identifier];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"tintColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"textColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigFillColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"fillColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigStrokeColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"strokeColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBorderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"borderColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"shadowColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigOnTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"onTintColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigThumbTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"thumbTintColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigSeparatorColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"separatorColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBarTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"barTintColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackgroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"backgroundColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigPlaceholderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"_placeholderLabel.textColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigTrackTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"trackTintColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigProgressTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"progressTintColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigHighlightedTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"highlightedTextColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigPageIndicatorTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"pageIndicatorTintColor" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigCurrentPageIndicatorTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"currentPageIndicatorTintColor" , identifier);
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
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"image" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigTrackImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"trackImage" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigProgressImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"progressImage" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigShadowImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"shadowImage" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigSelectedImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"selectedImage" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"backgroundImage" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"backIndicatorImage" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackIndicatorTransitionMaskImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"backIndicatorTransitionMaskImage" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigSelectionIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"selectionIndicatorImage" , identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigScopeBarBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigKeyPathAndIdentifier(@"scopeBarBackgroundImage" , identifier);
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

- (LEEConfigThemeToString)LeeConfigKeyPathAndIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *keyPath , NSString *identifier){
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:identifier forKey:keyPath];
        
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

- (NSMutableDictionary *)modelThemeColorConfigInfo{
    
    if (!_modelThemeColorConfigInfo) _modelThemeColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeColorConfigInfo;
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
    
    if ([self isLeeTheme]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:LEEThemeChangingNotificaiton object:nil];
        
        objc_removeAssociatedObjects(self);
    }

    [self lee_dealloc];
}

- (void)leeTheme_ChangeThemeConfigNotify:(NSNotification *)notify{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [UIView beginAnimations:@"LEEThemeChangeAnimations" context:nil];
        
        [UIView setAnimationDuration:self.lee_theme.modelChangeThemeAnimationDuration >= 0.0f ? self.lee_theme.modelChangeThemeAnimationDuration : [LEETheme shareTheme].animationDuration ];
        
        [self changeThemeConfigWithAboutConfigBlock:nil];
        
        [UIView commitAnimations];
    });

}

- (BOOL)isChangeTheme{
    
    return (!self.lee_theme.modelCurrentThemeTag || ![self.lee_theme.modelCurrentThemeTag isEqualToString:[LEETheme currentThemeTag]]) ? YES : NO;
}

- (BOOL)isCGColorWithKeyPath:(NSString *)keyPath{
    
    objc_property_t property = class_getProperty([self class] , [keyPath UTF8String]);
    
    if(property != NULL) {
        
        return ([[NSString stringWithUTF8String:property_getAttributes(property)] isEqualToString:@"T^{CGColor=}"]) ? YES : NO;
    
    } else {
        
        return NO;
    }
    
}

- (UIColor *)getCurrentThemeTagColorWithKeyPath:(NSString *)keyPath{
    
    return [UIColor leeTheme_ColorFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:self.lee_theme.modelThemeIdentifierConfigInfo[keyPath]];
}

- (UIColor *)getCurrentThemeTagButtonColorWithType:(LEEThemeIdentifierConfigType)type WithState:(NSNumber *)state{
    
    NSDictionary *info = self.lee_theme.modelThemeIdentifierConfigInfo[@(type)];
    
    NSString *identifier = info[state];
    
    return [UIColor leeTheme_ColorFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:identifier];
}

- (UIImage *)getCurrentThemeTagImageWithKeyPath:(NSString *)keyPath{
    
    return [UIImage leeTheme_ImageFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:self.lee_theme.modelThemeIdentifierConfigInfo[keyPath]];
}

- (UIImage *)getCurrentThemeTagButtonImageWithType:(LEEThemeIdentifierConfigType)type WithState:(NSNumber *)state{
    
    NSDictionary *info = self.lee_theme.modelThemeIdentifierConfigInfo[@(type)];
    
    NSString *identifier = info[state];
    
    return [UIImage leeTheme_ImageFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:identifier];
}

- (id)getCurrentThemeTagValueWithIdentifier:(NSString *)identifier{
    
    id value = [LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]][@"json"][@"other"][identifier];
    
    return value;
}

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        self.lee_theme.modelCurrentThemeTag = [LEETheme currentThemeTag];
        
        LEEThemeConfigBlock configBlock = self.lee_theme.modelThemeConfigInfo[[LEETheme currentThemeTag]];
        
        NSDictionary *identifierConfigInfo = self.lee_theme.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeCustomConfig)];
        
        if (aboutConfigBlock) aboutConfigBlock();
        
        for (NSString *keyPath in self.lee_theme.modelThemeColorConfigInfo) {
            
            UIColor *color = self.lee_theme.modelThemeColorConfigInfo[keyPath][[LEETheme currentThemeTag]];
            
            if (color) [self isCGColorWithKeyPath:keyPath] ? [self setValue:(id)color.CGColor forKeyPath:keyPath] : [self setValue:color forKeyPath:keyPath];
        }
        
        for (NSString *keyPath in self.lee_theme.modelThemeImageConfigInfo) {
            
            id image = self.lee_theme.modelThemeImageConfigInfo[keyPath][[LEETheme currentThemeTag]];
            
            if ([image isKindOfClass:[NSString class]]) {
                
                NSString *info = image;
                
                image = [UIImage imageNamed:image];
                
                if (!image) image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:info]];
                
                if (!image) image = [UIImage imageWithContentsOfFile:info];
            }
            
            if (image) if ([image isKindOfClass:[UIImage class]]) [self setValue:image forKeyPath:keyPath];
        }
        
        for (NSString *keyPath in self.lee_theme.modelThemeIdentifierConfigInfo) {
            
            if (![keyPath isKindOfClass:[NSString class]]) continue;
            
            id value = [self getCurrentThemeTagColorWithKeyPath:keyPath];
            
            if ([self isCGColorWithKeyPath:keyPath]) value = (id)[(UIColor *)value CGColor];
            
            if (!value) value = [self getCurrentThemeTagImageWithKeyPath:keyPath];
            
            if (value) [self setValue:value forKeyPath:keyPath];
        }
        
        if (configBlock) configBlock(self);
        
        if (identifierConfigInfo) {
            
            for (NSString *identifier in identifierConfigInfo.allKeys) {
                
                LEEThemeConfigBlockToIdentifier configBlockItem = identifierConfigInfo[identifier];
                
                if (configBlockItem) configBlockItem(self , [self getCurrentThemeTagValueWithIdentifier:identifier]);
            }
            
        }

    }
    
}

- (LEEThemeConfigModel *)lee_theme{
    
    LEEThemeConfigModel *model = objc_getAssociatedObject(self, _cmd);
    
    if (!model) {
        
        NSAssert(![self isKindOfClass:[LEEThemeConfigModel class]], @"是不是点多了? ( *・ω・)✄╰ひ╯ ");
        
        model = [LEEThemeConfigModel new];
        
        objc_setAssociatedObject(self, _cmd, model , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leeTheme_ChangeThemeConfigNotify:) name:LEEThemeChangingNotificaiton object:nil];
        
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
    
    if(self) if(lee_theme) objc_setAssociatedObject(self, @selector(lee_theme), lee_theme , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLeeTheme{
    
    return self ? [objc_getAssociatedObject(self, _cmd) boolValue] : NO;
}

- (void)setIsLeeTheme:(BOOL)isLeeTheme{
    
    if (self) objc_setAssociatedObject(self, @selector(isLeeTheme), @(isLeeTheme) , OBJC_ASSOCIATION_ASSIGN);
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

+ (UIColor *)leeTheme_ColorFromJsonWithTag:(NSString *)tag WithIdentifier:(NSString *)identifier{
    
    NSString *colorHexString = [LEETheme shareTheme].jsonConfigInfo[tag][@"json"][@"color"][identifier];
    
    return colorHexString ? [UIColor leeTheme_ColorWithHexString:colorHexString] : nil;
}

@end

@implementation UIImage (LEEThemeImage) 

+ (UIImage *)leeTheme_ImageFromJsonWithTag:(NSString *)tag WithIdentifier:(NSString *)identifier{
    
    NSString *imageName = [LEETheme shareTheme].jsonConfigInfo[tag][@"json"][@"image"][identifier];
    
    NSString *path = [LEETheme shareTheme].jsonConfigInfo[[LEETheme currentThemeTag]][@"path"];
    
    UIImage *image = path ? [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]] : [UIImage imageNamed:imageName];
    
    if (!image) image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imageName]];
    
    return image;
}

@end
