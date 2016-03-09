//
//  MLLinkLabel.m
//  MLLabel
//
//  Created by molon on 15/6/6.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLLinkLabel.h"
#import "MLLabel+Override.h"
#import "NSMutableAttributedString+MLLabel.h"
#import "MLLabelLayoutManager.h"

#define REGULAREXPRESSION_OPTION(regularExpression,regex,option) \
\
static NSRegularExpression * k##regularExpression() { \
static NSRegularExpression *_##regularExpression = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_##regularExpression = [[NSRegularExpression alloc] initWithPattern:(regex) options:(option) error:nil];\
});\
\
return _##regularExpression;\
}\

#define REGULAREXPRESSION(regularExpression,regex) REGULAREXPRESSION_OPTION(regularExpression,regex,NSRegularExpressionCaseInsensitive)


REGULAREXPRESSION(URLRegularExpression,@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)")
REGULAREXPRESSION(PhoneNumerRegularExpression, @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}")
REGULAREXPRESSION(EmailRegularExpression, @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}")
REGULAREXPRESSION(UserHandleRegularExpression, @"@[\\u4e00-\\u9fa5\\w\\-]+")
REGULAREXPRESSION(HashtagRegularExpression, @"#([\\u4e00-\\u9fa5\\w\\-]+)")

@interface MLLink()

@property (nonatomic, assign) NSRange linkRange;

@end

@implementation MLLink

+ (instancetype)linkWithType:(MLLinkType)type value:(NSString*)value range:(NSRange)range
{
    return [MLLink linkWithType:type value:value range:range linkTextAttributes:nil activeLinkTextAttributes:nil];
}

+ (instancetype)linkWithType:(MLLinkType)type value:(NSString*)value range:(NSRange)range linkTextAttributes:(NSDictionary*)linkTextAttributes activeLinkTextAttributes:(NSDictionary*)activeLinkTextAttributes
{
    MLLink *link = [MLLink new];
    link.linkType = type;
    link.linkValue = value;
    link.linkRange = range;
    link.linkTextAttributes = linkTextAttributes;
    link.activeLinkTextAttributes = activeLinkTextAttributes;
    return link;
}

@end


@interface MLLinkLabel()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *links;
@property (nonatomic, strong) MLLink *activeLink;
@property (nonatomic, assign) BOOL dontReCreateLinks;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation MLLinkLabel

#pragma mark - getter
- (NSMutableArray *)links
{
    if (!_links) {
        _links = [NSMutableArray array];
    }
    return _links;
}

- (UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    if (!_longPressGestureRecognizer) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureDidFire:)];
        _longPressGestureRecognizer.delegate = self;
    }
    return _longPressGestureRecognizer;
}


#pragma mark - setter
- (void)setActiveLink:(MLLink *)activeLink
{
    BOOL isUnChanged = (!activeLink&&!_activeLink)||[activeLink isEqual:_activeLink];
    
    _activeLink = activeLink;
    
    if (isUnChanged) {
        return;
    }
    
    [self reSetText];
    
    [CATransaction flush];
}

- (void)setAllowLineBreakInsideLinks:(BOOL)allowLineBreakInsideLinks
{
    if (allowLineBreakInsideLinks==_allowLineBreakInsideLinks) return;
    
    _allowLineBreakInsideLinks = allowLineBreakInsideLinks;
    [self reSetText];
}

- (void)setLinkTextAttributes:(NSDictionary *)linkTextAttributes
{
    _linkTextAttributes = linkTextAttributes;
    [self reSetText];
}

- (void)setActiveLinkTextAttributes:(NSDictionary *)activeLinkTextAttributes
{
    _activeLinkTextAttributes = activeLinkTextAttributes;
    [self reSetText];
}

- (void)setDataDetectorTypes:(MLDataDetectorTypes)dataDetectorTypes
{
    _dataDetectorTypes = dataDetectorTypes;
    [super reSetText];
}

- (void)setDataDetectorTypesOfAttributedLinkValue:(MLDataDetectorTypes)dataDetectorTypesOfAttributedLinkValue
{
    _dataDetectorTypesOfAttributedLinkValue = dataDetectorTypesOfAttributedLinkValue;
    [super reSetText];
}

#pragma mark - override
- (void)reSetText
{
    //标记不重新生成链接，因为修改label的样式，例如字体啊什么的，父类会调用reSetText方法。而这时候如果依然重新生成link的话，会引起addLink方式后添加的link丢失。
    //然后此类内部所有需要重新生成链接的都是调用[super reSetText]，否则只是需要重绘的调用[self reSetText]
    self.dontReCreateLinks = YES;
    [super reSetText];
    self.dontReCreateLinks = NO;
}

- (void)commonInit
{
    [super commonInit];
    
    self.exclusiveTouch = YES;
    self.userInteractionEnabled = YES;
    
    self.activeLinkToNilDelay = 0.3f;
    
    //默认除了话题和@都检测
    _dataDetectorTypes = MLDataDetectorTypeURL|MLDataDetectorTypePhoneNumber|MLDataDetectorTypeEmail|MLDataDetectorTypeAttributedLink;
    _dataDetectorTypesOfAttributedLinkValue = MLDataDetectorTypeNone;
    _allowLineBreakInsideLinks = YES;
    
    [self addGestureRecognizer:self.longPressGestureRecognizer];
}

- (void)setText:(NSString *)text
{
    //先提取出来links
    if (!self.dontReCreateLinks) {
        self.links = [self linksWithString:text];
        _activeLink = nil; //这里不能走setter
    }
    
    [super setText:text];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    //先提取出来links
    if (!self.dontReCreateLinks) {
        self.links = [self linksWithString:attributedText];
        _activeLink = nil; //这里不能走setter
    }
    
    [super setAttributedText:attributedText];
}

- (NSMutableAttributedString*)attributedTextForTextStorageFromLabelProperties
{
    NSMutableAttributedString *attributedString = [super attributedTextForTextStorageFromLabelProperties];
    
    //默认的链接样式不是我们想要的，去除它
    [attributedString removeAttribute:NSLinkAttributeName range:NSMakeRange(0, attributedString.length)];
    
    //检测是否有链接，有的话就直接给设置链接样式
    for (MLLink *link in self.links) {
        NSDictionary *attributes = nil;
        if ([link isEqual:self.activeLink]) {
            attributes = link.activeLinkTextAttributes?link.activeLinkTextAttributes:self.activeLinkTextAttributes;
            if (!attributes) {
                attributes = @{NSForegroundColorAttributeName:kDefaultLinkColorForMLLinkLabel,NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
            }
        }else{
            attributes = link.linkTextAttributes?link.linkTextAttributes:self.linkTextAttributes;
            if (!attributes) {
                attributes = @{NSForegroundColorAttributeName:kDefaultLinkColorForMLLinkLabel};
            }
        }
        //        [attributedString removeAttributes:[attributes allKeys] range:link.linkRange];
        [attributedString addAttributes:attributes range:link.linkRange];
    }
    
    return attributedString;
    
}

#pragma mark - 正则匹配相关
static NSArray * kAllRegexps() {
    static NSArray *_allRegexps = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _allRegexps = @[kURLRegularExpression(),kPhoneNumerRegularExpression(),kEmailRegularExpression(),kUserHandleRegularExpression(),kHashtagRegularExpression()];
    });
    return _allRegexps;
}

- (NSArray*)regexpsWithDataDetectorTypes:(MLDataDetectorTypes)dataDetectorTypes
{
    MLDataDetectorTypes const allDataDetectorTypes[] = {MLDataDetectorTypeURL,MLDataDetectorTypePhoneNumber,MLDataDetectorTypeEmail,MLDataDetectorTypeUserHandle,MLDataDetectorTypeHashtag};
    NSArray *allRegexps = kAllRegexps();
    
    NSMutableArray *regexps = [NSMutableArray array];
    for (NSInteger i=0; i<allRegexps.count; i++) {
        if (dataDetectorTypes&(allDataDetectorTypes[i])) {
            [regexps addObject:allRegexps[i]];
        }
    }
    return regexps.count>0?regexps:nil;
}

//根据dataDetectorTypes和string获取其linkType
- (MLLinkType)linkTypeOfString:(NSString*)string withDataDetectorTypes:(MLDataDetectorTypes)dataDetectorTypes
{
    if (dataDetectorTypes == MLDataDetectorTypeNone) {
        return MLLinkTypeOther;
    }
    
    NSArray *allRegexps = kAllRegexps();
    NSArray *regexps = [self regexpsWithDataDetectorTypes:dataDetectorTypes];
    
    NSRange textRange = NSMakeRange(0, string.length);
    for (NSRegularExpression *regexp in regexps) {
        NSTextCheckingResult *result = [regexp firstMatchInString:string options:NSMatchingAnchored range:textRange];
        if (result&&NSEqualRanges(result.range, textRange)) {
            //这个type确定
            MLLinkType linkType = [allRegexps indexOfObject:regexp]+1;
            return linkType;
        }
    }
    
    return MLLinkTypeOther;
}

- (NSMutableArray*)linksWithString:(id)string
{
    if (self.dataDetectorTypes == MLDataDetectorTypeNone||!string) {
        return nil;
    }
    
    NSString *plainText = [string isKindOfClass:[NSAttributedString class]]?((NSAttributedString*)string).string:string;
    if (plainText.length<=0) {
        return nil;
    }
    
    NSMutableArray *links = [NSMutableArray array];
    
    if ((self.dataDetectorTypes&MLDataDetectorTypeAttributedLink)&&[string isKindOfClass:[NSAttributedString class]]) {
        NSAttributedString *attributedString = ((NSAttributedString*)string);
        [attributedString enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            if (value) {
                NSString *linkValue = nil;
                if ([value isKindOfClass:[NSURL class]]) {
                    linkValue = [value absoluteString];
                }else if ([value isKindOfClass:[NSString class]]) {
                    linkValue = value;
                }else if ([value isKindOfClass:[NSAttributedString class]]) {
                    linkValue = [value string];
                }
                if (linkValue.length>0) {
                    MLLink *link = [MLLink linkWithType:[self linkTypeOfString:linkValue withDataDetectorTypes:self.dataDetectorTypesOfAttributedLinkValue] value:linkValue range:range];
                    if (self.beforeAddLinkBlock) {
                        self.beforeAddLinkBlock(link);
                    }
                    [links addObject:link];
                }
            }
        }];
    }
    
    NSArray *allRegexps = kAllRegexps();
    NSArray *regexps = [self regexpsWithDataDetectorTypes:self.dataDetectorTypes];
    NSRange textRange = NSMakeRange(0, plainText.length);
    for (NSRegularExpression *regexp in regexps) {
        [regexp enumerateMatchesInString:plainText options:0 range:textRange usingBlock:^(NSTextCheckingResult *result, __unused NSMatchingFlags flags, __unused BOOL *stop) {
            //去重处理
            for (MLLink *link in links){
                if (NSMaxRange(NSIntersectionRange(link.linkRange, result.range))>0){
                    return;
                }
            }
            
            //这个刚好和MLLinkType对应
            MLLinkType linkType = [allRegexps indexOfObject:regexp]+1;
            
            if (linkType!=MLLinkTypeNone) {
                MLLink *link = [MLLink linkWithType:linkType value:[plainText substringWithRange:result.range] range:result.range];
                if (self.beforeAddLinkBlock) {
                    self.beforeAddLinkBlock(link);
                }
                [links addObject:link];
            }
        }];
    }
    
    return links.count>0?links:nil;
    
}

#pragma mark - 链接点击交互相关
- (MLLink *)linkAtPoint:(CGPoint)location
{
    if (self.links.count<=0||self.textStorage.string.length == 0||self.textContainer.size.width<=0||self.textContainer.size.height<=0)
    {
        return nil;
    }
    
    CGPoint textOffset;
    //在执行usedRectForTextContainer之前最好还是执行下glyphRangeForTextContainer relayout
    [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self textOffsetWithTextSize:[self.layoutManager usedRectForTextContainer:self.textContainer].size];
    
    //location转换成在textContainer的绘制区域的坐标
    location.x -= textOffset.x;
    location.y -= textOffset.y;
    
    //获取触摸的字形
    NSUInteger glyphIdx = [self.layoutManager glyphIndexForPoint:location inTextContainer:self.textContainer];
    
    //apple文档上写有说 如果location的区域没字形，可能返回的是最近的字形index，所以我们再找到这个字形所处于的rect来确认
    CGRect glyphRect = [self.layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIdx, 1)
                                                     inTextContainer:self.textContainer];
    if (!CGRectContainsPoint(glyphRect, location))
        return nil;
    
    NSUInteger charIndex = [self.layoutManager characterIndexForGlyphAtIndex:glyphIdx];
    
    //找到了charIndex，然后去寻找是否这个字处于链接内部
    for (MLLink *link in self.links) {
        if (NSLocationInRange(charIndex,link.linkRange)) {
            return link;
        }
    }
    
    return nil;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    self.activeLink = [self linkAtPoint:[touch locationInView:self]];
    
    //如果已经触发了链接，就不朝上传递消息了
    if (!self.activeLink) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //如果当前位置和之前的active的不一样的话，就认为不选那个链接了
    if (self.activeLink) {
        UITouch *touch = [touches anyObject];
        
        if (![self.activeLink isEqual:[self linkAtPoint:[touch locationInView:self]]]) {
            self.activeLink = nil;
        }
    } else {
        [super touchesMoved:touches withEvent:event];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.activeLink) {
        NSString *linkText = [self.textStorage.string substringWithRange:self.activeLink.linkRange];
        
        //告诉外面已经点击了某链接
        if (self.activeLink.didClickLinkBlock) {
            self.activeLink.didClickLinkBlock(self.activeLink,linkText,self);
        }else if (self.didClickLinkBlock) {
            self.didClickLinkBlock(self.activeLink,linkText,self);
        }else if(self.delegate&&[self.delegate respondsToSelector:@selector(didClickLink:linkText:linkLabel:)]){
            [self.delegate didClickLink:self.activeLink linkText:linkText linkLabel:self];
        }
        
        [self performSelector:@selector(setActiveLink:) withObject:nil afterDelay:self.activeLinkToNilDelay];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.activeLink) {
        self.activeLink = nil;
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
}

#pragma mark - 长按相关
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    MLLink *link = [self linkAtPoint:[touch locationInView:self]];
    if (link) {
        //检测是否有长按回调，没的话就不继续
        if ((self.delegate&&[self.delegate respondsToSelector:@selector(didLongPressLink:linkText:linkLabel:)])
            ||self.didLongPressLinkBlock
            ||link.didLongPressLinkBlock) {
            return YES;
        }
    }
    
    return NO;
}

- (void)longPressGestureDidFire:(UILongPressGestureRecognizer *)sender {
    if (sender.state==UIGestureRecognizerStateBegan) {
        MLLink *link = [self linkAtPoint:[sender locationInView:self]];
        if (link) {
            NSString *linkText = [self.textStorage.string substringWithRange:link.linkRange];
            
            //告诉外面已经长按了某链接
            if (link.didLongPressLinkBlock) {
                link.didLongPressLinkBlock(link,linkText,self);
            }else if (self.didLongPressLinkBlock) {
                self.didLongPressLinkBlock(link,linkText,self);
            }else if (self.delegate&&[self.delegate respondsToSelector:@selector(didLongPressLink:linkText:linkLabel:)]){
                [self.delegate didLongPressLink:link linkText:linkText linkLabel:self];
            }
        }
    }
}


#pragma mark - 外部调用相关
- (BOOL)addLink:(MLLink*)link
{
    return [self addLinks:@[link]].count>0;
}

- (MLLink*)addLinkWithType:(MLLinkType)type value:(NSString*)value range:(NSRange)range
{
    MLLink *link = [MLLink linkWithType:type value:value range:range];
    return [self addLink:link]?link:nil;
}

- (NSArray*)addLinks:(NSArray*)links
{
    NSMutableArray *validLinks = [NSMutableArray arrayWithCapacity:links.count];
    for (MLLink *link in links) {
        if (!link||NSMaxRange(link.linkRange)>self.textStorage.length) {
            continue;
        }
        
        //检测是否此位置已经有东西占用
        for (MLLink *aLink in self.links){
            if (NSMaxRange(NSIntersectionRange(aLink.linkRange, link.linkRange))>0){
                continue;
            }
        }
        
        if (self.beforeAddLinkBlock) {
            self.beforeAddLinkBlock(link);
        }
        
        //加入它
        [self.links addObject:link];
        
        [validLinks addObject:link];
    }
    
    //重绘
    [self reSetText];
    
    return validLinks;
}

- (void)invalidateDisplayForLinks
{
    [self reSetText];
}

#pragma mark - 布局相关
-(BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldBreakLineByWordBeforeCharacterAtIndex:(NSUInteger)charIndex
{
    if (self.lineBreakMode == NSLineBreakByCharWrapping) {
        return NO;
    }
    
    if (self.allowLineBreakInsideLinks) {
        return YES;
    }
    
    //让在链接区间下，尽量不break
    for (MLLink *link in self.links) {
        if (NSLocationInRange(charIndex,link.linkRange)) {
            return NO;
        }
    }
    return YES;
}

@end
