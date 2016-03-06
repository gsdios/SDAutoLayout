//
//  MLLabel.m
//  MLLabel
//
//  Created by molon on 15/5/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLLabel.h"
#import "NSMutableAttributedString+MLLabel.h"
#import "MLLabelLayoutManager.h"
#import "NSString+MLLabel.h"

#define kAdjustFontSizeEveryScalingFactor (M_E / M_PI)
//总得有个极限
static CGFloat MLFLOAT_MAX = 100000.0f;
static CGFloat ADJUST_MIN_FONT_SIZE = 1.0f;
static CGFloat ADJUST_MIN_SCALE_FACTOR = 0.01f;

static NSArray * kStylePropertyNames() {
    static NSArray *_stylePropertyNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //TODO: 这个highlighted在tableview滚动到的时候会设置下(即使cell的selectStyle为None)，然后就造成resetText，很鸡巴，耗费性能，这个似乎没辙，实在有必要，后期+个属性来开关
        _stylePropertyNames = @[@"font",@"textAlignment",@"textColor",@"highlighted",
                                @"highlightedTextColor",@"shadowColor",@"shadowOffset",@"enabled",@"lineHeightMultiple",@"lineSpacing"];
    });
    return _stylePropertyNames;
}

@interface MLLabelStylePropertyRecord : NSObject

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, assign) CGFloat lineHeightMultiple; //行高的multiple
@property (nonatomic, assign) CGFloat lineSpacing; //行间距

@end
@implementation MLLabelStylePropertyRecord
@end


@interface MLLabel()<NSLayoutManagerDelegate>

@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) MLLabelLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;

@property (nonatomic, assign) MLLastTextType lastTextType;

@property (nonatomic, strong) MLLabelStylePropertyRecord *styleRecord;

//为什么需要这个，是因为setAttributedText之后内部可能会对其进行了改动，然后例如再次更新style属性，然后更新绘制会出问题。索性都以记录的最原始的为准。
@property (nonatomic, copy) NSAttributedString *lastAttributedText;
//读取的时候需要
@property (nonatomic, copy) NSString *lastText;

@end

@implementation MLLabel

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.lineHeightMultiple = 1.0f;
    
    //设置TextKit初始相关
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    
    //label helper相关
    if ([super attributedText]) {
        self.attributedText = [super attributedText];
    }else{
        self.text = [super text];
    }
    
    //kvo 监视style属性
    for (NSString *key in kStylePropertyNames()) {
        [self.styleRecord setValue:[self valueForKey:key] forKey:key];
        //不直接使用NSKeyValueObservingOptionInitial来初始化赋值record，是防止无用的resettext
        [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)dealloc
{
    //kvo 移除监视style属性
    for (NSString *key in kStylePropertyNames()) {
        [self removeObserver:self forKeyPath:key context:nil];
    }
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([kStylePropertyNames() containsObject:keyPath]) {
        //存到记录对象里
        [_styleRecord setValue:[object valueForKey:keyPath] forKey:keyPath];
        
        id old = change[NSKeyValueChangeOldKey];
        id new = change[NSKeyValueChangeNewKey];
        if ([old isEqual:new]||(!old&&!new)) {
            return;
        }
        
        [self reSetText];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - getter
- (NSTextStorage *)textStorage
{
    if (!_textStorage) {
        _textStorage = [NSTextStorage new];
    }
    return _textStorage;
}

- (MLLabelLayoutManager *)layoutManager
{
    if (!_layoutManager) {
        _layoutManager = [MLLabelLayoutManager new];
        _layoutManager.allowsNonContiguousLayout = NO;
        _layoutManager.delegate = self;
    }
    return _layoutManager;
}

- (NSTextContainer *)textContainer
{
    if (!_textContainer) {
        _textContainer = [NSTextContainer new];
        _textContainer.maximumNumberOfLines = self.numberOfLines;
        _textContainer.lineBreakMode = self.lineBreakMode;
        _textContainer.lineFragmentPadding = 0.0f;
        _textContainer.size = self.frame.size;
    }
    return _textContainer;
}

- (MLLabelStylePropertyRecord *)styleRecord
{
    if (!_styleRecord) {
        _styleRecord = [MLLabelStylePropertyRecord new];
    }
    return _styleRecord;
}

- (NSAttributedString *)attributedText
{
    return _lastTextType==MLLastTextTypeAttributed?_lastAttributedText:[self attributedTextForTextStorageFromLabelProperties];
}

- (NSString*)text
{
    return _lastTextType==MLLastTextTypeAttributed?_lastAttributedText.string:_lastText;
}

#pragma mark - set text
- (void)setLastTextType:(MLLastTextType)lastTextType
{
    _lastTextType = lastTextType;
    //重置下
    self.lastText = nil;
    self.lastAttributedText = nil;
}

- (void)setText:(NSString *)text
{
    NSAssert(!text||[text isKindOfClass:[NSString class]], @"text must be NSString");
    
    self.lastTextType = MLLastTextTypeNormal;
    self.lastText = text;
    
    [self invalidateIntrinsicContentSize];
    //    [super setText:text];
    
    [_textStorage setAttributedString:[self attributedTextForTextStorageFromLabelProperties]];
    
    //如果text和原本的一样的话 super 是不会触发redraw的，但是很遗憾我们的label比较灵活，验证起来很麻烦，所以还是都重绘吧
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    NSAssert(!attributedText||[attributedText isKindOfClass:[NSAttributedString class]], @"text must be NSAttributedString");
    
    self.lastTextType = MLLastTextTypeAttributed;
    self.lastAttributedText = attributedText;
    
    [self invalidateIntrinsicContentSize];
    //    [super setAttributedText:attributedText];
    
    [_textStorage setAttributedString:[self attributedTextForTextStorageFromLabelProperties]];
    
    //如果text和原本的一样的话 super 是不会触发redraw的，但是很遗憾我们的label比较灵活，验证起来很麻烦，所以还是都重绘吧
    [self setNeedsDisplay];
    //    NSLog(@"set attr text %p",self);
}

#pragma mark - common helper
- (CGSize)textContainerSizeWithBoundsSize:(CGSize)size
{
    //bounds改了之后，要相应的改变textContainer的size，但是要根据insets调整
    CGFloat width = fmax(0, size.width-_textInsets.left-_textInsets.right);
    CGFloat height = fmax(0, size.height-_textInsets.top-_textInsets.bottom);
    return CGSizeMake(width, height);
}

- (void)reSetText
{
    if (_lastTextType == MLLastTextTypeNormal) {
        self.text = _lastText;
    }else{
        self.attributedText = _lastAttributedText;
    }
}

/**
 *  根据label的属性来进行处理并返回给textStorage使用的
 */
- (NSMutableAttributedString*)attributedTextForTextStorageFromLabelProperties
{
    if (_lastTextType==MLLastTextTypeNormal) {
        if (!_lastText) {
            return [[NSMutableAttributedString alloc]initWithString:@""];
        }
        
        //根据text和label默认的一些属性得到attributedText
        return [[NSMutableAttributedString alloc] initWithString:_lastText attributes:[self attributesFromLabelProperties]];
    }
    
    if (!_lastAttributedText) {
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
    
    //遍历并且添加Label默认的属性
    NSMutableAttributedString *newAttrStr = [[NSMutableAttributedString alloc]initWithString:_lastAttributedText.string attributes:[self attributesFromLabelProperties]];
    
    [_lastAttributedText enumerateAttributesInRange:NSMakeRange(0, newAttrStr.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (attrs.count>0) {
            //            [newAttrStr removeAttributes:[attrs allKeys] range:range];
            [newAttrStr addAttributes:attrs range:range];
        }
    }];
    return newAttrStr;
}

- (NSDictionary *)attributesFromLabelProperties
{
    //颜色
    UIColor *color = self.styleRecord.textColor;
    if (!_styleRecord.enabled)
    {
        color = [UIColor lightGrayColor];
    }
    else if (_styleRecord.highlighted)
    {
        color = _styleRecord.highlightedTextColor;
    }
    if (!color) {
        color = _styleRecord.textColor;
        if (!color) {
            color = [UIColor darkTextColor];
        }
    }
    
    //阴影
    NSShadow *shadow = shadow = [[NSShadow alloc] init];
    if (_styleRecord.shadowColor)
    {
        shadow.shadowColor = _styleRecord.shadowColor;
        shadow.shadowOffset = _styleRecord.shadowOffset;
    }
    else
    {
        shadow.shadowOffset = CGSizeMake(0, -1);
        shadow.shadowColor = nil;
    }
    
    //水平位置
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = _styleRecord.textAlignment;
    paragraph.lineSpacing = _styleRecord.lineSpacing;
    paragraph.lineHeightMultiple = _styleRecord.lineHeightMultiple;
    
    if (!_styleRecord.font) {
        _styleRecord.font = [UIFont systemFontOfSize:17.0f];
    }
    //最终
    NSDictionary *attributes = @{NSFontAttributeName : _styleRecord.font,
                                 NSForegroundColorAttributeName : color,
                                 NSShadowAttributeName : shadow,
                                 NSParagraphStyleAttributeName : paragraph,
                                 };
    return attributes;
}


- (CGRect)textRectForBounds:(CGRect)bounds attributedString:(NSAttributedString*)attributedString limitedToNumberOfLines:(NSInteger)numberOfLines lineCount:(NSInteger*)lineCount
{
    //这种算是特殊情况，如果为空字符串，那就没必要必要了，也忽略textInset，这样比较合理
    if (attributedString.length<=0) {
        bounds.size = CGSizeZero;
        return bounds;
    }
    
    CGSize newTextContainerSize = [self textContainerSizeWithBoundsSize:bounds.size];
    if (newTextContainerSize.width<=0||newTextContainerSize.height<=0){
        CGRect textBounds = CGRectZero;
        textBounds.origin = bounds.origin;
        textBounds.size = CGSizeMake(fmin(_textInsets.left+_textInsets.right,CGRectGetWidth(bounds)), fmin(_textInsets.top+_textInsets.bottom,CGRectGetHeight(bounds)));
        return textBounds;
    }
    
    CGRect textBounds = CGRectZero;
    @autoreleasepool {
        CGSize savedTextContainerSize = _textContainer.size;
        NSInteger savedTextContainerNumberOfLines = _textContainer.maximumNumberOfLines;
        
        _textContainer.size = newTextContainerSize;
        _textContainer.maximumNumberOfLines = numberOfLines;
        
        NSAttributedString *savedAttributedString = nil;
        if (![_textStorage isEqual:attributedString]) {
            savedAttributedString = [_textStorage copy];
            [_textStorage setAttributedString:attributedString];
        }
        
        NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
        if (lineCount) {
            [_layoutManager enumerateLineFragmentsForGlyphRange:glyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainer, NSRange glyphRange, BOOL *stop) {
                (*lineCount)++;
            }];
            //在最后字符为换行符的情况下，实际绘制出来的是会多那个一行，这里作为AppleBUG修正
            if ([_textStorage.string isNewlineCharacterAtEnd]) {
                (*lineCount)++;
            }
        }
        
        textBounds = [_layoutManager usedRectForTextContainer:_textContainer];
        
        //还原
        if (savedAttributedString) {
            [_textStorage setAttributedString:savedAttributedString];
        }
        _textContainer.size = savedTextContainerSize;
        _textContainer.maximumNumberOfLines = savedTextContainerNumberOfLines;
    }
    //最终修正
    textBounds.size.width =  fmin(ceilf(textBounds.size.width), newTextContainerSize.width);
    textBounds.size.height = fmin(ceilf(textBounds.size.height), newTextContainerSize.height);
    textBounds.origin = bounds.origin;
    
    textBounds.size = CGSizeMake(fmin(CGRectGetWidth(textBounds)+_textInsets.left+_textInsets.right,CGRectGetWidth(bounds)), fmin(CGRectGetHeight(textBounds)+_textInsets.top+_textInsets.bottom,CGRectGetHeight(bounds)));
    
    //    NSLog(@"bounds:%@ result:%@ %p",NSStringFromCGRect(bounds),NSStringFromCGRect(textBounds),self);
    return textBounds;
}

#pragma mark - draw
- (BOOL)adjustsCurrentFontSizeToFitWidthWithScaleFactor:(CGFloat)scaleFactor numberOfLines:(NSInteger)numberOfLines originalAttributedText:(NSAttributedString*)originalAttributedText bounds:(CGRect)bounds resultAttributedString:(NSAttributedString**)resultAttributedString
{
    __block BOOL mustReturnYES = NO;
    if (self.minimumScaleFactor > scaleFactor) {
        scaleFactor = self.minimumScaleFactor; //这个的话 就不能在循环验证了
        mustReturnYES = YES;
    }
    //总得有个极限
    scaleFactor = fmax(scaleFactor, ADJUST_MIN_SCALE_FACTOR);
    
    //遍历并且设置一个新的字体
    NSMutableAttributedString *attrStr = [originalAttributedText mutableCopy];
    
    if (scaleFactor!=1.0f) { //如果是1.0f的话就没有调整font size的必要
        [attrStr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            UIFont *font = (UIFont *)value;
            if (font&&[font isKindOfClass:[UIFont class]]) {
                NSString *fontName = font.fontName;
                CGFloat newSize = font.pointSize*scaleFactor;
                if (newSize<ADJUST_MIN_FONT_SIZE) { //字体的极限
                    mustReturnYES = YES;
                }
                UIFont *newFont = [UIFont fontWithName:fontName size:newSize];
                
                //                [attrStr removeAttribute:NSFontAttributeName range:range];
                [attrStr addAttribute:NSFontAttributeName value:newFont range:range];
            }
        }];
    }
    
    //返回是否需要继续调整字体大小
    if (mustReturnYES) {
        if (resultAttributedString) {
            (*resultAttributedString) = attrStr;
        }
        return YES;
    }
    
    
    CGSize currentTextSize = CGSizeZero;
    if (numberOfLines>0) {
        NSInteger lineCount = 0;
        currentTextSize = [self textRectForBounds:CGRectMake(0, 0, CGRectGetWidth(bounds), MLFLOAT_MAX) attributedString:attrStr limitedToNumberOfLines:0 lineCount:&lineCount].size;
        //如果求行数大于设置行数，也不认为塞满了
        if (lineCount>numberOfLines) {
            return NO;
        }
    }else{
        currentTextSize = [self textRectForBounds:CGRectMake(0, 0, CGRectGetWidth(bounds), MLFLOAT_MAX) attributedString:attrStr limitedToNumberOfLines:0 lineCount:NULL].size;
    }
    
    //大小已经足够就认作OK
    if (currentTextSize.width<=CGRectGetWidth(bounds)&&currentTextSize.height<=CGRectGetHeight(bounds)) {
        if (resultAttributedString) {
            (*resultAttributedString) = attrStr;
        }
        return YES;
    }
    
    return NO;
}

- (void)drawTextInRect:(CGRect)rect
{
    //    NSLog(@"draw text %p",self);
    //不调用super方法
    //            [super drawTextInRect:rect]; //这里调用可以查看是否绘制和原来的不一致
    
    //如果绘制区域本身就为0，就应该直接返回，不做多余操作。
    if (_textContainer.size.width<=0||_textContainer.size.height<=0){
        return;
    }
    
    if (self.adjustsFontSizeToFitWidth) {
        //初始scale，每次adjust都需要从头开始，因为也可能有当前font被adjust小过需要还原。
        CGFloat scaleFactor = 1.0f;
        BOOL mustContinueAdjust = YES;
        NSAttributedString *attributedString = [self attributedTextForTextStorageFromLabelProperties];
        
        //numberOfLine>0时候可以直接尝试找寻一个preferredScale
        if (self.numberOfLines>0) {
            //一点点矫正,以使得内容能放到当前的size里
            
            //找到当前text绘制在一行时候需要占用的宽度，其实这个值很可能不够，因为多行时候可能会因为wordwrap的关系多行+起的总宽度会多。但是这个能找到一个合适的矫正过程的开始值，大大减少矫正次数。
            
            //还有一种情况就是，有可能由于字符串里带换行符的关系造成压根不可能绘制到一行，这时候应该取会显示的最长的那一行。所以这里需要先截除必然不会显示的部分。
            NSUInteger stringlineCount = [attributedString.string lineCount];
            if (stringlineCount>self.numberOfLines) {
                //这里说明必然要截取
                attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, [attributedString.string lengthToLineIndex:self.numberOfLines-1])];
            }
            
            CGFloat textWidth = [self textRectForBounds:CGRectMake(0, 0, MLFLOAT_MAX, MLFLOAT_MAX) attributedString:attributedString limitedToNumberOfLines:0 lineCount:NULL].size.width;
            textWidth = fmax(0, textWidth-_textInsets.left-_textInsets.right);
            if (textWidth>0) {
                CGFloat availableWidth = _textContainer.size.width*self.numberOfLines;
                if (textWidth > availableWidth) {
                    //这里得到的scaleFactor肯定是大于这个的是必然不满足的,目的就是找这个，以能减少下面的矫正次数。
                    scaleFactor = availableWidth / textWidth;
                }
            }else{
                mustContinueAdjust = NO;
            }
        }
        
        if (mustContinueAdjust) {
            //一点点矫正,以使得内容能放到当前的size里
            NSAttributedString *resultAttributedString = attributedString;
            while (![self adjustsCurrentFontSizeToFitWidthWithScaleFactor:scaleFactor numberOfLines:self.numberOfLines originalAttributedText:attributedString bounds:self.bounds resultAttributedString:&resultAttributedString]){
                scaleFactor *=  kAdjustFontSizeEveryScalingFactor;
            };
            [_textStorage setAttributedString:resultAttributedString];
        }
    }
    
    
    CGPoint textOffset;
    //这里根据container的size和manager布局属性以及字符串来得到实际绘制的range区间
    NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
    
    //获取绘制区域大小
    CGRect drawBounds = [_layoutManager usedRectForTextContainer:_textContainer];
    
    //因为label是默认垂直居中的，所以需要根据实际绘制区域的bounds来调整出居中的offset
    textOffset = [self textOffsetWithTextSize:drawBounds.size];
    
    if (_doBeforeDrawingTextBlock) {
        //而实际上drawBounds的宽度可能不是我们想要的，我们想要的是_textContainer的宽度，但是高度需要是真实绘制高度
        CGSize drawSize = CGSizeMake(_textContainer.size.width, drawBounds.size.height);
        _doBeforeDrawingTextBlock(rect,textOffset,drawSize);
    }
    
    //绘制文字
    [_layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];
    [_layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];
}

//这个计算出来的是绘制起点
- (CGPoint)textOffsetWithTextSize:(CGSize)textSize
{
    CGPoint textOffset = CGPointZero;
    //根据insets和默认垂直居中来计算出偏移
    textOffset.x = _textInsets.left;
    CGFloat paddingHeight = (_textContainer.size.height - textSize.height) / 2.0f;
    textOffset.y = paddingHeight+_textInsets.top;
    
    return textOffset;
}


//- (NSUInteger)layoutManager:(NSLayoutManager *)layoutManager
//       shouldGenerateGlyphs:(const CGGlyph *)glyphs
//                 properties:(const NSGlyphProperty *)props
//           characterIndexes:(const NSUInteger *)charIndexes
//                       font:(UIFont *)aFont
//              forGlyphRange:(NSRange)glyphRange
//{
//    NSLog(@"shouldGenerateGlyphs:  start:%ld end:%ld",*charIndexes,charIndexes[glyphRange.length-1]);
////    if (*charIndexes>=100) {
////        return 0;
////    }
//    [layoutManager setGlyphs:glyphs properties:props characterIndexes:charIndexes font:aFont forGlyphRange:glyphRange];
//    return glyphRange.length;
//}

#pragma mark - sizeThatsFit
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    //fit实现与drawTextInRect大部分一个屌样，所以不写注释了。
    if (numberOfLines>1&&self.adjustsFontSizeToFitWidth) {
        CGFloat scaleFactor = 1.0f;
        NSAttributedString *attributedString = [self attributedTextForTextStorageFromLabelProperties];
        
        NSUInteger stringlineCount = [attributedString.string lineCount];
        if (stringlineCount>self.numberOfLines) {
            //这里说明必然要截取
            attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, [attributedString.string lengthToLineIndex:self.numberOfLines-1])];
        }
        
        CGFloat textWidth = [self textRectForBounds:CGRectMake(0, 0, MLFLOAT_MAX, MLFLOAT_MAX) attributedString:attributedString limitedToNumberOfLines:0 lineCount:NULL].size.width;
        textWidth = fmax(0, textWidth-_textInsets.left-_textInsets.right);
        if (textWidth>0) {
            CGFloat availableWidth = _textContainer.size.width*numberOfLines;
            if (textWidth > availableWidth) {
                //这里得到的scaleFactor肯定是大于这个的是必然不满足的,目的就是找这个，以能减少下面的矫正次数。
                scaleFactor = availableWidth / textWidth;
            }
            //一点点矫正,以使得内容能放到当前的size里
            NSAttributedString *resultAttributedString = attributedString;
            while (![self adjustsCurrentFontSizeToFitWidthWithScaleFactor:scaleFactor numberOfLines:numberOfLines originalAttributedText:attributedString bounds:bounds resultAttributedString:&resultAttributedString]){
                scaleFactor *=  kAdjustFontSizeEveryScalingFactor;
            };
            
            //计算当前adjust之后的合适大小,为什么不用adjust里面的 因为也可能有异常情况，例如压根adjust就没走到计算大小那一步啊什么的。
            CGRect textBounds = [self textRectForBounds:bounds attributedString:resultAttributedString limitedToNumberOfLines:numberOfLines lineCount:NULL];
            
            return textBounds;
        }
    }
    return  [self textRectForBounds:bounds attributedString:_textStorage limitedToNumberOfLines:numberOfLines lineCount:NULL];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    size = [super sizeThatFits:size];
    if (size.height>0) {
        size.height++;
    }
    return size;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    if (size.height>0) {
        size.height++;
    }
    return size;
}

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth
{
    CGSize size = [self sizeThatFits:CGSizeMake(maxWidth, MLFLOAT_MAX)];
    size.width = fmin(size.width, maxWidth); //在numberOfLine为1模式下返回的可能会比maxWidth大，所以这里我们限制下
    return size;
}

#pragma mark - set 修改container size相关
- (void)resizeTextContainerSize
{
    if (_textContainer) {
        _textContainer.size = [self textContainerSizeWithBoundsSize:self.bounds.size];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resizeTextContainerSize];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self resizeTextContainerSize];
}

- (void)setTextInsets:(UIEdgeInsets)insets
{
    _textInsets = insets;
    [self resizeTextContainerSize];
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - set container相关属性
- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    BOOL isChanged = (numberOfLines!=_textContainer.maximumNumberOfLines);
    
    [super setNumberOfLines:numberOfLines];
    
    _textContainer.maximumNumberOfLines = numberOfLines;
    
    if (isChanged) {
        [self invalidateIntrinsicContentSize];
        [self setNeedsDisplay];
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [super setLineBreakMode:lineBreakMode];
    
    _textContainer.lineBreakMode = lineBreakMode;
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - set 其他
- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor
{
    [super setMinimumScaleFactor:minimumScaleFactor];
    
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (void)setDoBeforeDrawingTextBlock:(void (^)(CGRect rect,CGPoint beginOffset,CGSize drawSize))doBeforeDrawingTextBlock
{
    _doBeforeDrawingTextBlock = doBeforeDrawingTextBlock;
    
    [self setNeedsDisplay];
}

#pragma mark - UIResponder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(__unused id)sender
{
    return (action == @selector(copy:));
}

#pragma mark - UIResponderStandardEditActions
- (void)copy:(__unused id)sender {
    [[UIPasteboard generalPasteboard] setString:self.text];
}

@end
