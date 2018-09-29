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
 *  @copyright    Copyright © 2016 - 2017年 lee. All rights reserved.
 *  @version    V1.1.7
 */

#import "LEETheme.h"

#import <objc/runtime.h>
#import <objc/message.h>

static NSString * const LEEThemeChangingNotificaiton = @"LEEThemeChangingNotificaiton";
static NSString * const LEEThemeAddTagNotificaiton = @"LEEThemeAddTagNotificaiton";
static NSString * const LEEThemeRemoveTagNotificaiton = @"LEEThemeRemoveTagNotificaiton";
static NSString * const LEEThemeAllTags = @"LEEThemeAllTags";
static NSString * const LEEThemeCurrentTag = @"LEEThemeCurrentTag";
static NSString * const LEEThemeConfigInfo = @"LEEThemeConfigInfo";

@interface LEETheme ()

@property (nonatomic , copy ) NSString *defaultTag;

@property (nonatomic , copy ) NSString *currentTag;

@property (nonatomic , strong ) NSMutableArray *allTags;

@property (nonatomic , strong ) NSMutableDictionary *configInfo;

@end

@implementation LEETheme

#if !__has_feature(objc_arc)
#error "ARC才可以  ( *・ω・)✄╰ひ╯ "
#endif

+ (LEETheme *)shareTheme{
    
    static LEETheme *themeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        themeManager = [[LEETheme alloc]init];
    });
    
    return themeManager;
}

#pragma mark Public

+ (void)startTheme:(NSString *)tag{
    
    NSAssert([[LEETheme shareTheme].allTags containsObject:tag], @"所启用的主题不存在 - 请检查是否添加了该%@主题的设置" , tag);
    
    if (!tag) return;
    
    [LEETheme shareTheme].currentTag = tag;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LEEThemeChangingNotificaiton object:nil userInfo:nil];
}

+ (void)defaultTheme:(NSString *)tag{
    
    if (!tag) return;
    
    [LEETheme shareTheme].defaultTag = tag;
    
    if (![LEETheme shareTheme].currentTag && ![[NSUserDefaults standardUserDefaults] objectForKey:LEEThemeCurrentTag]) [LEETheme shareTheme].currentTag = tag;
}

+ (NSString *)currentThemeTag{
    
    return [LEETheme shareTheme].currentTag ? [LEETheme shareTheme].currentTag : [[NSUserDefaults standardUserDefaults] objectForKey:LEEThemeCurrentTag];
}

+ (NSArray *)allThemeTag{
    
    return [[LEETheme shareTheme].allTags copy];
}

#pragma mark Private

- (void)setCurrentTag:(NSString *)currentTag{
    
    _currentTag = currentTag;
    
    [[NSUserDefaults standardUserDefaults] setObject:currentTag forKey:LEEThemeCurrentTag];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveConfigInfo{
    
    [[NSUserDefaults standardUserDefaults] setObject:self.configInfo forKey:LEEThemeConfigInfo];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addTagToAllTags:(NSString *)tag{
    
    if (![[LEETheme shareTheme].allTags containsObject:tag]) {
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [[NSUserDefaults standardUserDefaults] setObject:[LEETheme shareTheme].allTags forKey:LEEThemeAllTags];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

+ (void)removeTagToAllTags:(NSString *)tag{
    
    if ([[LEETheme shareTheme].allTags containsObject:tag]) {
        
        [[LEETheme shareTheme].allTags removeObject:tag];
        
        [[NSUserDefaults standardUserDefaults] setObject:[LEETheme shareTheme].allTags forKey:LEEThemeAllTags];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

#pragma mark - LazyLoading

- (NSMutableArray *)allTags{
    
    if (!_allTags) _allTags = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:LEEThemeAllTags]];

    return _allTags;
}

- (NSMutableDictionary *)configInfo{
    
    if (!_configInfo) _configInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:LEEThemeConfigInfo]];
    
    return _configInfo;
}

@end

@implementation LEETheme (JsonModeExtend)

+ (void)addThemeConfigWithJson:(NSString *)json Tag:(NSString *)tag ResourcesPath:(NSString *)path{
    
    if (json) {
        
        NSError *jsonError = nil;
        
        NSDictionary *jsonConfigInfo = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        
        NSAssert(!jsonError, @"添加的主题json配置数据解析错误 - 错误描述");
        NSAssert(jsonConfigInfo, @"添加的主题json配置数据解析为空 - 请检查");
        NSAssert(tag, @"添加的主题json标签不能为空");
        
        if (!jsonError && jsonConfigInfo) {
        
            [[LEETheme shareTheme].configInfo setValue:[NSMutableDictionary dictionaryWithObjectsAndKeys:jsonConfigInfo , @"info", path , @"path" , nil] forKey:tag];
            
            [[LEETheme shareTheme] saveConfigInfo];
            
            [LEETheme addTagToAllTags:tag];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LEEThemeAddTagNotificaiton object:nil userInfo:@{@"tag" : tag}];
        }
        
    }
    
}

+ (void)removeThemeConfigWithTag:(NSString *)tag{
    
    if ([[LEETheme shareTheme].allTags containsObject:tag] && ![[LEETheme shareTheme].defaultTag isEqualToString:tag]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LEEThemeRemoveTagNotificaiton object:nil userInfo:@{@"tag" : tag}];
        
        [LEETheme removeTagToAllTags:tag];
        
        [[LEETheme shareTheme].configInfo removeObjectForKey:tag];
        
        [[LEETheme shareTheme] saveConfigInfo];
        
        if ([[LEETheme currentThemeTag] isEqualToString:tag]) [LEETheme startTheme:[LEETheme shareTheme].defaultTag];
    }
    
}

+ (NSString *)getResourcesPathWithTag:(NSString *)tag{
    
    NSString *path = [LEETheme shareTheme].configInfo[tag][@"path"];
    
    return path ? path : [[NSBundle mainBundle] bundlePath];
}

+ (id)getValueWithTag:(NSString *)tag Identifier:(NSString *)identifier{
    
    id value = nil;
    
    NSDictionary *configInfo = [LEETheme shareTheme].configInfo[tag];
    
    NSDictionary *info = configInfo[@"info"];
    
    NSDictionary *colorInfo = info[@"color"];
    
    NSString *colorHexString = colorInfo[identifier];
    
    if (colorHexString) {
        
        UIColor *color = [UIColor leeTheme_ColorWithHexString:colorHexString];
        
        if (color && !value) value = color;
    }
    
    NSDictionary *imageInfo = info[@"image"];
    
    NSString *imageName = imageInfo[identifier];
    
    if (imageName) {
        
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString *path = configInfo[@"path"];
        
        if (path) path = [documentsPath stringByAppendingPathComponent:path];
        
        UIImage *image = path ? [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]] : [UIImage imageNamed:imageName];
        
        if (!image) image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imageName]];
        
        if (!image) image = [UIImage imageNamed:imageName];
        
        if (image && !value) value = image;
    }
    
    NSDictionary *otherInfo = info[@"other"];
    
    if (!value) value = otherInfo[identifier];
    
    return value;
}

@end

#pragma mark - ----------------主题设置模型----------------

@interface LEEThemeConfigModel ()

@property (nonatomic , copy ) void(^modelUpdateCurrentThemeConfig)();
@property (nonatomic , copy ) void(^modelConfigThemeChangingBlock)();

@property (nonatomic , copy ) LEEThemeChangingBlock modelChangingBlock;

@property (nonatomic , copy ) NSString *modelCurrentThemeTag;

@property (nonatomic , strong ) NSMutableDictionary <NSString * , NSMutableDictionary *>*modelThemeBlockConfigInfo; // @{tag : @{block : value}}
@property (nonatomic , strong ) NSMutableDictionary <NSString * , NSMutableDictionary *>*modelThemeKeyPathConfigInfo; // @{keypath : @{tag : value}}
@property (nonatomic , strong ) NSMutableDictionary <NSString * , NSMutableDictionary *>*modelThemeSelectorConfigInfo; // @{selector : @{tag : @[@[parameter, parameter,...] , @[...]]}}

@end

@implementation LEEThemeConfigModel

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    objc_removeAssociatedObjects(self);
    
    _modelCurrentThemeTag = nil;
    _modelThemeBlockConfigInfo = nil;
    _modelThemeKeyPathConfigInfo = nil;
    _modelThemeSelectorConfigInfo = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leeTheme_RemoveThemeTagNotify:) name:LEEThemeRemoveTagNotificaiton object:nil];
    }
    return self;
}

- (void)leeTheme_RemoveThemeTagNotify:(NSNotification *)notify{
    
    NSString *tag = notify.userInfo[@"tag"];
    
    self.LeeClearAllConfig_Tag(tag);
}

- (void)updateCurrentThemeConfigHandleWithTag:(NSString *)tag{
    
    if ([[LEETheme currentThemeTag] isEqualToString:tag]) {
        
        if ([NSThread isMainThread]) {
            
            if (self.modelUpdateCurrentThemeConfig) self.modelUpdateCurrentThemeConfig();
        
        } else {
        
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (self.modelUpdateCurrentThemeConfig) self.modelUpdateCurrentThemeConfig();
            });
        }
        
    }
    
}

- (LEEConfigThemeToChangingBlock)LeeThemeChangingBlock{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(LEEThemeChangingBlock changingBlock){
        
        if (changingBlock) {
            
            weakSelf.modelChangingBlock = changingBlock;
            
            if (weakSelf.modelConfigThemeChangingBlock) weakSelf.modelConfigThemeChangingBlock();
        }
            
        return weakSelf;
    };
    
}

- (LEEConfigThemeToT_Block)LeeAddCustomConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , LEEThemeConfigBlock configBlock){
        
        if (configBlock) {
            
            [LEETheme addTagToAllTags:tag];
            
            NSMutableDictionary *info = weakSelf.modelThemeBlockConfigInfo[tag];
            
            if (!info) info = [NSMutableDictionary dictionary];
            
            [info setObject:[NSNull null] forKey:configBlock];
            
            [weakSelf.modelThemeBlockConfigInfo setObject:info forKey:tag];
            
            [weakSelf updateCurrentThemeConfigHandleWithTag:tag];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToTs_Block)LeeAddCustomConfigs{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSArray *tags , LEEThemeConfigBlock configBlock){
        
        if (configBlock) {
            
            [tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [LEETheme addTagToAllTags:tag];
                
                NSMutableDictionary *info = weakSelf.modelThemeBlockConfigInfo[tag];
                
                if (!info) info = [NSMutableDictionary dictionary];
                
                [info setObject:[NSNull null] forKey:configBlock];
                
                [weakSelf.modelThemeBlockConfigInfo setObject:info forKey:tag];
                
                [weakSelf updateCurrentThemeConfigHandleWithTag:tag];
            }];

        }
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setTintColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setTextColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddFillColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setFillColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddStrokeColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setStrokeColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddBorderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setBorderColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setShadowColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddOnTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setOnTintColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddThumbTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setThumbTintColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddSeparatorColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setSeparatorColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddBarTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setBarTintColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddBackgroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setBackgroundColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddPlaceholderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddKeyPathAndValue(tag , @"_placeholderLabel.textColor" , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddTrackTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setTrackTintColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddProgressTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setProgressTintColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddHighlightedTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setHighlightedTextColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddCurrentPageIndicatorTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setCurrentPageIndicatorTintColor:) , color);
    };
    
}

- (LEEConfigThemeToT_Color)LeeAddPageIndicatorTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id color){
        
        return weakSelf.LeeAddSelectorAndColor(tag , @selector(setPageIndicatorTintColor:) , color);
    };
    
}

- (LEEConfigThemeToT_ColorAndState)LeeAddButtonTitleColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color , UIControlState state){
        
        return weakSelf.LeeAddSelectorAndValues(tag , @selector(setTitleColor:forState:) , color , @(state) , nil);
    };
    
}

- (LEEConfigThemeToT_ColorAndState)LeeAddButtonTitleShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color , UIControlState state){
        
        return weakSelf.LeeAddSelectorAndValues(tag , @selector(setTitleShadowColor:forState:) , color , @(state), nil);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setImage:) , image);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddTrackImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setTrackImage:) , image);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddProgressImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setProgressImage:) , image);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddShadowImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setShadowImage:) , image);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddSelectedImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setSelectedImage:) , image);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setBackgroundImage:) , image);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddBackIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setBackIndicatorImage:) , image);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddBackIndicatorTransitionMaskImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setBackIndicatorTransitionMaskImage:) , image);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddSelectionIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setSelectionIndicatorImage:) , image);
    };
    
}

- (LEEConfigThemeToT_Image)LeeAddScopeBarBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , id image){
        
        return weakSelf.LeeAddSelectorAndImage(tag , @selector(setScopeBarBackgroundImage:) , image);
    };
    
}

- (LEEConfigThemeToT_ImageAndState)LeeAddButtonImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image , UIControlState state){
        
        return weakSelf.LeeAddSelectorAndValues(tag , @selector(setImage:forState:) , image , @(state), nil);
    };
    
}

- (LEEConfigThemeToT_ImageAndState)LeeAddButtonBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image , UIControlState state){
        
        return weakSelf.LeeAddSelectorAndValues(tag , @selector(setBackgroundImage:forState:) , image , @(state), nil);
    };
    
}

- (LEEConfigThemeToT_SelectorAndColor)LeeAddSelectorAndColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , SEL sel , id color){
        
        id value = nil;
        
        if ([color isKindOfClass:NSString.class]) {
            
            value = [UIColor leeTheme_ColorWithHexString:color];
            
        } else {
            
            value = color;
        }
        
        if (value) weakSelf.LeeAddSelectorAndValueArray(tag , sel , @[value]);
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToT_SelectorAndImage)LeeAddSelectorAndImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , SEL sel , id image){
        
        id value = nil;
        
        if ([image isKindOfClass:NSString.class]) {
            
            value = [UIImage imageNamed:image];
            
            if (!value) value = [UIImage imageWithContentsOfFile:image];
            
        } else {
            
            value = image;
        }
        
        if (value) weakSelf.LeeAddSelectorAndValueArray(tag , sel , @[value]);
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToT_KeyPathAndValue)LeeAddKeyPathAndValue{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *keyPath , id value){
        
        if (!value) return weakSelf;
        
        [LEETheme addTagToAllTags:tag];
        
        NSMutableDictionary *info = weakSelf.modelThemeKeyPathConfigInfo[keyPath];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:value forKey:tag];
        
        [weakSelf.modelThemeKeyPathConfigInfo setObject:info forKey:keyPath];
        
        [weakSelf updateCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToT_SelectorAndValues)LeeAddSelectorAndValues{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag, SEL sel , ...){
        
        if (!sel) return weakSelf;
        
        NSMutableArray *array = [NSMutableArray array];
        
        va_list argsList;
        
        va_start(argsList, sel);
        
        id arg;
        
        while ((arg = va_arg(argsList, id))) {
            
            [array addObject:arg];
        }
        
        va_end(argsList);
        
        return weakSelf.LeeAddSelectorAndValueArray(tag, sel, array);
    };
    
}

- (LEEConfigThemeToT_SelectorAndValueArray)LeeAddSelectorAndValueArray{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag, SEL sel , NSArray *values){
      
        if (!tag) return weakSelf;
        
        if (!sel) return weakSelf;
        
        [LEETheme addTagToAllTags:tag];
        
        NSString *key = NSStringFromSelector(sel);
        
        NSMutableDictionary *info = weakSelf.modelThemeSelectorConfigInfo[key];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        NSMutableArray *valuesArray = info[tag];
        
        if (!valuesArray) valuesArray = [NSMutableArray array];
        
        [[valuesArray copy] enumerateObjectsUsingBlock:^(NSArray *valueArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([valueArray isEqualToArray:values]) [valuesArray removeObject:valueArray]; // 过滤相同参数值的数组
        }];
        
        if (values && values.count) [valuesArray addObject:values];
        
        [info setObject:valuesArray forKey:tag];
        
        [weakSelf.modelThemeSelectorConfigInfo setObject:info forKey:key];
        
        [weakSelf updateCurrentThemeConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToT_KeyPath)LeeRemoveKeyPath{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *keyPath){
        
        NSMutableDictionary *info = weakSelf.modelThemeKeyPathConfigInfo[keyPath];
        
        if (info) {
            
            [info removeObjectForKey:tag];
            
            [weakSelf.modelThemeKeyPathConfigInfo setObject:info forKey:keyPath];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToT_Selector)LeeRemoveSelector{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , SEL sel){
        
        NSMutableDictionary *info = weakSelf.modelThemeSelectorConfigInfo[NSStringFromSelector(sel)];
        
        if (info) {
            
            [info removeObjectForKey:tag];
            
            [weakSelf.modelThemeSelectorConfigInfo setObject:info forKey:NSStringFromSelector(sel)];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigTheme)LeeClearAllConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        weakSelf.modelChangingBlock = nil;
        
        [weakSelf.modelThemeBlockConfigInfo removeAllObjects];
        
        [weakSelf.modelThemeKeyPathConfigInfo removeAllObjects];
        
        [weakSelf.modelThemeSelectorConfigInfo removeAllObjects];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToTag)LeeClearAllConfig_Tag{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag){
        
        [weakSelf.modelThemeBlockConfigInfo removeObjectForKey:tag];
        
        for (id keyPath in [weakSelf.modelThemeKeyPathConfigInfo copy]) {
            
            weakSelf.LeeRemoveKeyPath(tag, keyPath);
        }
        
        for (id selector in [weakSelf.modelThemeSelectorConfigInfo copy]) {
            
            weakSelf.LeeRemoveSelector(tag, NSSelectorFromString(selector));
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToKeyPath)LeeClearAllConfig_KeyPath{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *keyPath){
        
        [weakSelf.modelThemeKeyPathConfigInfo removeObjectForKey:keyPath];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToSelector)LeeClearAllConfig_Selector{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(SEL selector){
        
        [weakSelf.modelThemeSelectorConfigInfo removeObjectForKey:NSStringFromSelector(selector)];
        
        return weakSelf;
    };
    
}

#pragma mark - LazyLoading

- (NSMutableDictionary *)modelThemeBlockConfigInfo{
    
    if (!_modelThemeBlockConfigInfo) _modelThemeBlockConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBlockConfigInfo;
}

- (NSMutableDictionary *)modelThemeKeyPathConfigInfo{
    
    if (!_modelThemeKeyPathConfigInfo) _modelThemeKeyPathConfigInfo = [NSMutableDictionary dictionary];

    return _modelThemeKeyPathConfigInfo;
}

- (NSMutableDictionary *)modelThemeSelectorConfigInfo{
    
    if (!_modelThemeSelectorConfigInfo) _modelThemeSelectorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeSelectorConfigInfo;
}

@end

typedef NS_ENUM(NSInteger, LEEThemeIdentifierConfigType) {
    
    /** 标识符设置类型 - Block */
    
    LEEThemeIdentifierConfigTypeBlock,
    
    /** 标识符设置类型 - 路径,方法 */
    
    LEEThemeIdentifierConfigTypeKeyPath,
    LEEThemeIdentifierConfigTypeSelector
};

@implementation LEEThemeConfigModel (IdentifierModeExtend)

- (LEEConfigThemeToIdentifierAndBlock)LeeCustomConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , LEEThemeConfigBlockToValue configBlock){
        
        if (configBlock) {
            
            for (NSString *tag in [LEETheme shareTheme].allTags) {
                
                id value = [LEETheme getValueWithTag:tag Identifier:identifier];
                
                if (value) {
                    
                    NSMutableDictionary *info = weakSelf.modelThemeBlockConfigInfo[tag];
                    
                    if (!info) info = [NSMutableDictionary dictionary];
                    
                    [info setObject:value forKey:configBlock];
                    
                    [weakSelf.modelThemeBlockConfigInfo setObject:info forKey:tag];
                    
                    [weakSelf updateCurrentThemeConfigHandleWithTag:tag];
                }
                
            }
            
            NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeBlock)];
            
            if (!info) info = [NSMutableDictionary dictionary];
            
            [info setObject:identifier forKey:configBlock];
            
            [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:@(LEEThemeIdentifierConfigTypeBlock)];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setTintColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setTextColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigFillColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setFillColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigStrokeColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setStrokeColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBorderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setBorderColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setShadowColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigOnTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setOnTintColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigThumbTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setThumbTintColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigSeparatorColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setSeparatorColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBarTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setBarTintColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackgroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setBackgroundColor:), identifier);
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
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setTrackTintColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigProgressTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setProgressTintColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigHighlightedTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setHighlightedTextColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigPageIndicatorTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setPageIndicatorTintColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigCurrentPageIndicatorTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setCurrentPageIndicatorTintColor:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifierAndState)LeeConfigButtonTitleColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , UIControlState state){
        
        return weakSelf.LeeConfigSelectorAndValueArray(@selector(setTitleColor:forState:), @[[LEEThemeIdentifier ident:identifier], @(state)]);
    };
    
}

- (LEEConfigThemeToIdentifierAndState)LeeConfigButtonTitleShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , UIControlState state){
        
        return weakSelf.LeeConfigSelectorAndValueArray(@selector(setTitleShadowColor:forState:), @[[LEEThemeIdentifier ident:identifier], @(state)]);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigTrackImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setTrackImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigProgressImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setProgressImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigShadowImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setShadowImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigSelectedImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setSelectedImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setBackgroundImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setBackIndicatorImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigBackIndicatorTransitionMaskImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setBackIndicatorTransitionMaskImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigSelectionIndicatorImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setSelectionIndicatorImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifier)LeeConfigScopeBarBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setScopeBarBackgroundImage:), identifier);
    };
    
}

- (LEEConfigThemeToIdentifierAndState)LeeConfigButtonImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , UIControlState state){
        
        return weakSelf.LeeConfigSelectorAndValueArray(@selector(setImage:forState:), @[[LEEThemeIdentifier ident:identifier], @(state)]);
    };
    
}

- (LEEConfigThemeToIdentifierAndState)LeeConfigButtonBackgroundImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier , UIControlState state){
        
        weakSelf.LeeConfigSelectorAndValueArray(@selector(setBackgroundImage:forState:), @[[LEEThemeIdentifier ident:identifier], @(state)]);
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToKeyPathAndIdentifier)LeeConfigKeyPathAndIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *keyPath , NSString *identifier){
        
        for (NSString *tag in [LEETheme shareTheme].allTags) {
            
            id value = [LEETheme getValueWithTag:tag Identifier:identifier];
            
            if (value) weakSelf.LeeAddKeyPathAndValue(tag, keyPath, value);
        }
        
        NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeKeyPath)];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:identifier forKey:keyPath];
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:@(LEEThemeIdentifierConfigTypeKeyPath)];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToSelectorAndIdentifier)LeeConfigSelectorAndIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(SEL sel , NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndValueArray(sel , @[[LEEThemeIdentifier ident:identifier]]);
    };
    
}

- (LEEConfigThemeToSelectorAndValues)LeeConfigSelectorAndValueArray{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(SEL sel , NSArray *values){
        
        for (NSString *tag in [LEETheme shareTheme].allTags) {
            
            NSMutableArray *valueArray = [NSMutableArray array];
            
            for (id value in values) {

                id v = value;
                
                if ([value isKindOfClass:LEEThemeIdentifier.class]) {
                    
                    v = [LEETheme getValueWithTag:tag Identifier:value];
                }
                
                if (v) [valueArray addObject:v];
            }
            
            if (valueArray.count == values.count && valueArray.count) weakSelf.LeeAddSelectorAndValueArray(tag, sel, valueArray);
        }
        
        NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[@(LEEThemeIdentifierConfigTypeSelector)];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        if (values) [info setObject:NSStringFromSelector(sel) forKey:values];
        
        [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:@(LEEThemeIdentifierConfigTypeSelector)];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToKeyPath)LeeRemoveKeyPathIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *keyPath){
        
        id type = @(LEEThemeIdentifierConfigTypeKeyPath);
        
        NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[type];
        
        for (id key in [info copy]) {
            
            if ([key isEqualToString:keyPath]) {
                
                for (NSString *tag in [LEETheme shareTheme].allTags) {
                    
                    if ([LEETheme getValueWithTag:tag Identifier:info[key]]) weakSelf.LeeRemoveKeyPath(tag, keyPath);
                }
                
                [info removeObjectForKey:key];
            }
            
        }
        
        if (info) [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:type];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToSelector)LeeRemoveSelectorIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(SEL sel){
        
        id type = @(LEEThemeIdentifierConfigTypeSelector);
        
        NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[type];
        
        for (id key in [info copy]) {
            
            if ([info[key] isEqualToString:NSStringFromSelector(sel)]) {
                
                NSArray *values = key;
                
                for (id value in values) {
                    
                    if ([value isKindOfClass:LEEThemeIdentifier.class]) {
                        
                        for (NSString *tag in [LEETheme shareTheme].allTags) {
                            
                            if ([LEETheme getValueWithTag:tag Identifier:value]) weakSelf.LeeRemoveSelector(tag, NSSelectorFromString(info[key]));
                        }

                    }
                    
                }
                
                [info removeObjectForKey:key];
            }
            
        }
        
        if (info) [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:type];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToIdentifier)LeeRemoveIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier){
      
        for (id type in [weakSelf.modelThemeIdentifierConfigInfo copy]) {
         
            NSMutableDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[type];
            
            for (id key in [info copy]) {
                
                switch ([type integerValue]) {
                        
                    case LEEThemeIdentifierConfigTypeBlock:
                    {
                        if ([info[key] isEqualToString:identifier]) {
                        
                            for (NSString *tag in [LEETheme shareTheme].allTags) {
                                
                                id value = [LEETheme getValueWithTag:tag Identifier:identifier];
                                
                                if (!value) continue;
                                
                                NSMutableDictionary *info = weakSelf.modelThemeBlockConfigInfo[tag];
                                
                                if (info) {
                                    
                                    [info removeObjectForKey:key];
                                    
                                    [weakSelf.modelThemeBlockConfigInfo setObject:info forKey:tag];
                                }
                                
                            }
                        
                            [info removeObjectForKey:key];
                        }
                        
                    }
                        break;
                        
                    case LEEThemeIdentifierConfigTypeKeyPath:
                    {
                        if ([info[key] isEqualToString:identifier]) {
                            
                            for (NSString *tag in [LEETheme shareTheme].allTags) {
                                
                                id value = [LEETheme getValueWithTag:tag Identifier:identifier];
                                
                                if (!value) continue;
                                
                                weakSelf.LeeRemoveKeyPath(tag, key);
                            }
                            
                            [info removeObjectForKey:key];
                        }
                        
                    }
                        break;
                        
                    case LEEThemeIdentifierConfigTypeSelector:
                    {
                        BOOL remove = NO;
                        
                        NSArray *values = key;
                        
                        for (id value in values) {
                            
                            if ([value isKindOfClass:LEEThemeIdentifier.class]) {
                                
                                if ([value isEqualToString:identifier]) {
                                    
                                    for (NSString *tag in [LEETheme shareTheme].allTags) {
                                        
                                        if ([LEETheme getValueWithTag:tag Identifier:value]) weakSelf.LeeRemoveSelector(tag, NSSelectorFromString(info[key]));
                                    }
                                    
                                    remove = YES;
                                }
                                
                            }
                            
                        }
                        
                        if (remove) [info removeObjectForKey:key];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            if (info) [weakSelf.modelThemeIdentifierConfigInfo setObject:info forKey:type];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigTheme)LeeClearAllConfigOnIdentifierMode{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        for (NSNumber *type in weakSelf.modelThemeIdentifierConfigInfo) {
            
            NSDictionary *info = weakSelf.modelThemeIdentifierConfigInfo[type];
            
            for (id key in info) {
                
                switch ([type integerValue]) {
                        
                    case LEEThemeIdentifierConfigTypeBlock:
                    {   
                        for (NSString *tag in [LEETheme allThemeTag]) {
                            
                            NSMutableDictionary *blockInfo = weakSelf.modelThemeBlockConfigInfo[tag];
                            
                            if (!blockInfo) blockInfo = [NSMutableDictionary dictionary];
                            
                            for (id key in [blockInfo copy]) {
                                
                                if (![blockInfo[key] isKindOfClass:NSNull.class]) [blockInfo removeObjectForKey:key];
                            }
                            
                            [weakSelf.modelThemeBlockConfigInfo setObject:blockInfo forKey:tag];
                        }
                        
                    }
                        break;
                        
                    case LEEThemeIdentifierConfigTypeKeyPath:
                    {
                        NSString *identifier = info[key];
                        
                        for (NSString *tag in [LEETheme allThemeTag]) {
                            
                            id value = [LEETheme getValueWithTag:tag Identifier:identifier];
                            
                            if (!value) continue;
                            
                            weakSelf.LeeRemoveKeyPath(tag, key);
                        }
                        
                    }
                        break;
                        
                    case LEEThemeIdentifierConfigTypeSelector:
                    {
                        NSArray *values = key;
                        
                        for (NSString *tag in [LEETheme shareTheme].allTags) {
                            
                            BOOL remove = NO;
                            
                            for (id value in values) {
                                
                                if ([value isKindOfClass:LEEThemeIdentifier.class]) {
                                    
                                    if ([LEETheme getValueWithTag:tag Identifier:value]) remove = YES;
                                }
                                
                            }
                            
                            if (remove) weakSelf.LeeRemoveSelector(tag, NSSelectorFromString(info[key]));
                        }
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
            
        }
        
        [weakSelf.modelThemeIdentifierConfigInfo removeAllObjects];
        
        return weakSelf;
    };
    
}

- (void)leeTheme_AddThemeTagNotify:(NSNotification *)notify{
    
    NSString *tag = notify.userInfo[@"tag"];
    
    NSDictionary *configInfo = self.modelThemeIdentifierConfigInfo;
    
    for (NSNumber *type in configInfo) {
        
        NSDictionary *info = configInfo[type];
        
        for (id key in info) {
            
            switch ([type integerValue]) {
                    
                case LEEThemeIdentifierConfigTypeBlock:
                {
                    NSString *identifier = info[key];
                    
                    id value = [LEETheme getValueWithTag:tag Identifier:identifier];
                    
                    if (value) {
                        
                        NSMutableDictionary *blockInfo = self.modelThemeBlockConfigInfo[tag];
                        
                        if (!blockInfo) blockInfo = [NSMutableDictionary dictionary];
                        
                        [blockInfo setObject:value forKey:key];
                        
                        [self.modelThemeBlockConfigInfo setObject:blockInfo forKey:tag];
                    }
                }
                    break;
                    
                case LEEThemeIdentifierConfigTypeKeyPath:
                {
                    NSString *identifier = info[key];
                    
                    id value = [LEETheme getValueWithTag:tag Identifier:identifier];
                    
                    if (value) self.LeeAddKeyPathAndValue(tag, key, value);
                }
                    break;
                    
                case LEEThemeIdentifierConfigTypeSelector:
                {
                    NSArray *values = key;
                    
                    NSMutableArray *valueArray = [NSMutableArray array];
                    
                    for (id value in values) {
                        
                        id v = value;
                        
                        if ([value isKindOfClass:LEEThemeIdentifier.class]) {
                            
                            v = [LEETheme getValueWithTag:tag Identifier:value];
                        }
                        
                        if (v) [valueArray addObject:v];
                    }
                    
                    if (valueArray.count == values.count && valueArray.count) self.LeeAddSelectorAndValueArray(tag, NSSelectorFromString(info[key]), valueArray);
                }
                    break;
                    
                default:
                    break;
            }

        }
        
    }
    
}

- (NSMutableDictionary *)modelThemeIdentifierConfigInfo{
    
    /**
     *  @{type : @{(keypath or block) : identifier}}
     *  
     *  @{type : @{values : selector}}
     */
    NSMutableDictionary *dic = objc_getAssociatedObject(self, _cmd);
    
    if (!dic) {
        
        dic = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self, _cmd, dic , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leeTheme_AddThemeTagNotify:) name:LEEThemeAddTagNotificaiton object:nil];
    }
    
    return dic;
}

- (void)setModelThemeIdentifierConfigInfo:(NSMutableDictionary *)modelThemeIdentifierConfigInfo{
    
    objc_setAssociatedObject(self, @selector(modelThemeIdentifierConfigInfo), modelThemeIdentifierConfigInfo , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation LEEThemeIdentifier
{
    NSString *_backingStore;
}

+ (LEEThemeIdentifier *)ident:(NSString *)ident{
    
    return [[LEEThemeIdentifier alloc] initWithString:ident];
}

- (id)initWithString:(NSString *)aString
{
    if (self = [self init]) {
        
        _backingStore = [[NSString stringWithString:aString] copy];
    }
    return self;
}

- (NSUInteger)length{
    
    return [_backingStore length];
}

- (unichar)characterAtIndex:(NSUInteger)index{
    
    return [_backingStore characterAtIndex:index];
}

@end

#pragma mark - ----------------主题设置----------------

@implementation NSObject (LEEThemeConfigObject)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"dealloc"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *leeSelString = [@"lee_theme_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            
            BOOL isAddedMethod = class_addMethod(self, NSSelectorFromString(selString), method_getImplementation(leeMethod), method_getTypeEncoding(leeMethod));
            
            if (isAddedMethod) {
                
                class_replaceMethod(self, NSSelectorFromString(leeSelString), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
                
            } else {
                
                method_exchangeImplementations(originalMethod, leeMethod);
            }
            
        }];
        
    });
    
}

- (void)lee_theme_dealloc{
    
    if ([self isLeeTheme]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:LEEThemeChangingNotificaiton object:nil];
        
        objc_removeAssociatedObjects(self);
    }

    [self lee_theme_dealloc];
}

- (BOOL)isChangeTheme{
    
    return (!self.lee_theme.modelCurrentThemeTag || ![self.lee_theme.modelCurrentThemeTag isEqualToString:[LEETheme currentThemeTag]]) ? YES : NO;
}

- (void)leeTheme_ChangeThemeConfigNotify:(NSNotification *)notify{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self isChangeTheme]) {
            
            if (self.lee_theme.modelChangingBlock) self.lee_theme.modelChangingBlock([LEETheme currentThemeTag] , self);
            
            [CATransaction begin];
            
            [CATransaction setDisableActions:YES];
            
            [self changeThemeConfig]; 
            
            [CATransaction commit];
        }
        
    });
    
}

- (void)setInv:(NSInvocation *)inv Sig:(NSMethodSignature *)sig Obj:(id)obj Index:(NSInteger)index{
    
    if (sig.numberOfArguments <= index) return;
    
    char *type = (char *)[sig getArgumentTypeAtIndex:index];
    
    while (*type == 'r' || // const
           *type == 'n' || // in
           *type == 'N' || // inout
           *type == 'o' || // out
           *type == 'O' || // bycopy
           *type == 'R' || // byref
           *type == 'V') { // oneway
        type++; // cutoff useless prefix
    }
    
    BOOL unsupportedType = NO;
    
    switch (*type) {
        case 'v': // 1: void
        case 'B': // 1: bool
        case 'c': // 1: char / BOOL
        case 'C': // 1: unsigned char
        case 's': // 2: short
        case 'S': // 2: unsigned short
        case 'i': // 4: int / NSInteger(32bit)
        case 'I': // 4: unsigned int / NSUInteger(32bit)
        case 'l': // 4: long(32bit)
        case 'L': // 4: unsigned long(32bit)
        { // 'char' and 'short' will be promoted to 'int'.
            int value = [obj intValue];
            [inv setArgument:&value atIndex:index];
        } break;
            
        case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
        case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
        {
            long long value = [obj longLongValue];
            [inv setArgument:&value atIndex:index];
        } break;
            
        case 'f': // 4: float / CGFloat(32bit)
        { // 'float' will be promoted to 'double'.
            double value = [obj doubleValue];
            float valuef = value;
            [inv setArgument:&valuef atIndex:index];
        } break;
            
        case 'd': // 8: double / CGFloat(64bit)
        {
            double value = [obj doubleValue];
            [inv setArgument:&value atIndex:index];
        } break;
            
        case '*': // char *
        case '^': // pointer
        {
            if ([obj isKindOfClass:UIColor.class]) obj = (id)[obj CGColor]; //CGColor转换
            if ([obj isKindOfClass:UIImage.class]) obj = (id)[obj CGImage]; //CGImage转换
            void *value = (__bridge void *)obj;
            [inv setArgument:&value atIndex:index];
        } break;
            
        case '@': // id
        {
            id value = obj;
            [inv setArgument:&value atIndex:index];
        } break;
            
        case '{': // struct
        {
            if (strcmp(type, @encode(CGPoint)) == 0) {
                CGPoint value = [obj CGPointValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGSize)) == 0) {
                CGSize value = [obj CGSizeValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGRect)) == 0) {
                CGRect value = [obj CGRectValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGVector)) == 0) {
                CGVector value = [obj CGVectorValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                CGAffineTransform value = [obj CGAffineTransformValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                CATransform3D value = [obj CATransform3DValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(NSRange)) == 0) {
                NSRange value = [obj rangeValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(UIOffset)) == 0) {
                UIOffset value = [obj UIOffsetValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                UIEdgeInsets value = [obj UIEdgeInsetsValue];
                [inv setArgument:&value atIndex:index];
            } else {
                unsupportedType = YES;
            }
        } break;
            
        case '(': // union
        {
            unsupportedType = YES;
        } break;
            
        case '[': // array
        {
            unsupportedType = YES;
        } break;
            
        default: // what?!
        {
            unsupportedType = YES;
        } break;
    }
    
    NSAssert(unsupportedType == NO, @"方法的参数类型暂不支持");
}

- (void)changeThemeConfig{
    
    self.lee_theme.modelCurrentThemeTag = [LEETheme currentThemeTag];
    
    NSString *tag = [LEETheme currentThemeTag];
    
    // Block
    
    for (id blockKey in self.lee_theme.modelThemeBlockConfigInfo[tag]) {
        
        id value = self.lee_theme.modelThemeBlockConfigInfo[tag][blockKey];
        
        if ([value isKindOfClass:NSNull.class]) {
            
            LEEThemeConfigBlock block = (LEEThemeConfigBlock)blockKey;
            
            if (block) block(self);
            
        } else {
            
            LEEThemeConfigBlockToValue block = (LEEThemeConfigBlockToValue)blockKey;
            
            if (block) block(self , value);
        }
        
    }
    
    // KeyPath
    
    for (id keyPath in self.lee_theme.modelThemeKeyPathConfigInfo) {
        
        NSDictionary *info = self.lee_theme.modelThemeKeyPathConfigInfo[keyPath];
        
        id value = info[tag];
        
        if ([keyPath isKindOfClass:NSString.class]) {
            
            [self setValue:value forKeyPath:keyPath];
        }
        
    }
    
    // Selector
    
    for (NSString *selector in self.lee_theme.modelThemeSelectorConfigInfo) {
        
        NSDictionary *info = self.lee_theme.modelThemeSelectorConfigInfo[selector];
        
        NSArray *valuesArray = info[tag];
        
        for (NSArray *values in valuesArray) {
            
            SEL sel = NSSelectorFromString(selector);
            
            NSMethodSignature * sig = [self methodSignatureForSelector:sel];
            
            if (!sig) [self doesNotRecognizeSelector:sel];
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
            
            if (!inv) [self doesNotRecognizeSelector:sel];
            
            [inv setTarget:self];
            
            [inv setSelector:sel];
            
            if (sig.numberOfArguments == values.count + 2) {
                
                [values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSInteger index = idx + 2;
                    
                    [self setInv:inv Sig:sig Obj:obj Index:index];
                }];
                
                [inv invoke];
                
            } else {
                
                NSAssert(YES, @"参数个数与方法参数个数不匹配");
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
        
        model.modelUpdateCurrentThemeConfig = ^{
            
            if (weakSelf) [weakSelf changeThemeConfig];
        };
        
        model.modelConfigThemeChangingBlock = ^{
            
            if (weakSelf) weakSelf.lee_theme.modelChangingBlock([LEETheme currentThemeTag], weakSelf);
        };
        
    }
    
    return model;
}

- (void)setLee_theme:(LEEThemeConfigModel *)lee_theme{
    
    if(self) objc_setAssociatedObject(self, @selector(lee_theme), lee_theme , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLeeTheme{
    
    return self ? [objc_getAssociatedObject(self, _cmd) boolValue] : NO;
}

- (void)setIsLeeTheme:(BOOL)isLeeTheme{
    
    if (self) objc_setAssociatedObject(self, @selector(isLeeTheme), @(isLeeTheme) , OBJC_ASSOCIATION_ASSIGN);
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
            red   = [self colorComponentFrom:colorString start: 0 length: 1];
            green = [self colorComponentFrom:colorString start: 1 length: 1];
            blue  = [self colorComponentFrom:colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start: 0 length: 1];
            red   = [self colorComponentFrom:colorString start: 1 length: 1];
            green = [self colorComponentFrom:colorString start: 2 length: 1];
            blue  = [self colorComponentFrom:colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start: 0 length: 2];
            green = [self colorComponentFrom:colorString start: 2 length: 2];
            blue  = [self colorComponentFrom:colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start: 0 length: 2];
            red   = [self colorComponentFrom:colorString start: 2 length: 2];
            green = [self colorComponentFrom:colorString start: 4 length: 2];
            blue  = [self colorComponentFrom:colorString start: 6 length: 2];
            break;
        default:
            alpha = 0;
            red = 0;
            blue = 0;
            green = 0;
            break;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *) string start:(NSUInteger)start length:(NSUInteger) length{
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0f;
}

@end
