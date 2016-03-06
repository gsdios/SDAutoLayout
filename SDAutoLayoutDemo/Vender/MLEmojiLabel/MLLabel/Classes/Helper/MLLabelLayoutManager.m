//
//  MLLabelLayoutManager.m
//  MLLabel
//
//  Created by molon on 15/6/11.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLLabelLayoutManager.h"

@interface MLLabelLayoutManager()

@property (nonatomic, assign) CGPoint lastDrawPoint;

@end

@implementation MLLabelLayoutManager

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin
{
    self.lastDrawPoint = origin;
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
    self.lastDrawPoint = CGPointZero;
}

- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) {
        [super fillBackgroundRectArray:rectArray count:rectCount forCharacterRange:charRange color:color];
        return;
    }
    
    CGContextSaveGState(ctx);
    {
        [color setFill];
        
        NSRange glyphRange = [self glyphRangeForCharacterRange:charRange actualCharacterRange:NULL];
        
        CGPoint textOffset = self.lastDrawPoint;
        
        NSRange lineRange = NSMakeRange(glyphRange.location, 1);
        while (NSMaxRange(lineRange)<=NSMaxRange(glyphRange)) {
            
            //这里可以防止这行没有用到的区域也绘制上背景色，例如收到word wrap，center alignment影响后每行文字没有占满时候
            CGRect lineBounds = [self lineFragmentUsedRectForGlyphAtIndex:lineRange.location effectiveRange:&lineRange];
            lineBounds.origin.x += textOffset.x;
            lineBounds.origin.y += textOffset.y;
            
            //找到这行具有背景色文字区域的位置
            NSRange glyphRangeInLine = NSIntersectionRange(glyphRange,lineRange);
            NSRange truncatedGlyphRange = [self truncatedGlyphRangeInLineFragmentForGlyphAtIndex:glyphRangeInLine.location];
            if (truncatedGlyphRange.location!=NSNotFound) {
                //这里的glyphRangeInLine本身可能会带有被省略的区间，而我们下面计算最大行高和最小drawY的实现是不需要考虑省略的区间的，否则也可能计算有误。所以这里我们给过滤掉
                NSRange sameRange = NSIntersectionRange(glyphRangeInLine, truncatedGlyphRange);
                if (sameRange.length>0&&NSMaxRange(sameRange)==NSMaxRange(glyphRangeInLine)) {
                    //我们这里先只处理tail模式的
                    //而经过测试truncatedGlyphRangeInLineFragmentForGlyphAtIndex暂时只支持NSLineBreakByTruncatingTail模式
                    //其他两种暂时也不会用，即使用，现在通过TextKit的话也没法获取
                    glyphRangeInLine = NSMakeRange(glyphRangeInLine.location, sameRange.location-glyphRangeInLine.location);
                }
            }
            
            if (glyphRangeInLine.length>0) {
                CGFloat startDrawY = CGFLOAT_MAX;
                CGFloat maxLineHeight = 0.0f; //找到这行的 背景色区间 的文字的最小Y值和最大的文字高度
                for (NSInteger glyphIndex = glyphRangeInLine.location; glyphIndex<NSMaxRange(glyphRangeInLine); glyphIndex++) {
                    NSInteger charIndex = [self characterIndexForGlyphAtIndex:glyphIndex];
                    UIFont *font = [self.textStorage attribute:NSFontAttributeName
                                                       atIndex:charIndex
                                                effectiveRange:nil];
                    //找到这个字的绘制位置
                    CGPoint location = [self locationForGlyphAtIndex:glyphIndex];
                    startDrawY = fmin(startDrawY, lineBounds.origin.y+location.y-font.ascender);
                    //                NSLog(@"char:%@ lineHeight:%lf",[self.textStorage.string substringWithRange:[self.textStorage.string rangeOfComposedCharacterSequenceAtIndex:charIndex]],font.lineHeight);
                    maxLineHeight = fmax(maxLineHeight, font.lineHeight);
                }
                
                CGSize size = lineBounds.size;
                CGPoint orgin = lineBounds.origin;
                
                //调整下高度和绘制y值，这样做的目的是为了不会收到lineHeightMultiple和lineSpcing的影响，引起背景色绘制过高不工整
                orgin.y = startDrawY;
                size.height = maxLineHeight;
                
                lineBounds.size = size;
                lineBounds.origin = orgin;
            }
            
            for (NSInteger i=0; i<rectCount; i++) {
                //找到相交的区域并且绘制
                CGRect validRect = CGRectIntersection(lineBounds, rectArray[i]);
                if (!CGRectIsEmpty(validRect)) {
                    CGContextFillRect(ctx, validRect);
                }
            }
            lineRange = NSMakeRange(NSMaxRange(lineRange), 1);
        }
    }
    CGContextRestoreGState(ctx);
}

@end
