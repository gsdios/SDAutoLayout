//
//  MLTextAttachment.m
//  MLLabel
//
//  Created by molon on 15/6/11.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLTextAttachment.h"

@interface MLTextAttachment()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat lineHeightMultiple;
@property (nonatomic, assign) CGFloat imageAspectRatio;

@property (nonatomic, copy) UIImage * (^imageBlock)(CGRect imageBounds,NSTextContainer *textContainer,NSUInteger charIndex,MLTextAttachment *textAttachment);

@end

@implementation MLTextAttachment

+ (instancetype)textAttachmentWithWidth:(CGFloat)width height:(CGFloat)height imageBlock:(UIImage * (^)(CGRect imageBounds,NSTextContainer *textContainer,NSUInteger charIndex,MLTextAttachment *textAttachment))imageBlock
{
    MLTextAttachment *textAttachment = [MLTextAttachment new];
    textAttachment.width = width;
    textAttachment.height = height;
    textAttachment.imageBlock = imageBlock;
    return textAttachment;
}

+ (instancetype)textAttachmentWithLineHeightMultiple:(CGFloat)lineHeightMultiple imageBlock:(UIImage * (^)(CGRect imageBounds,NSTextContainer *textContainer,NSUInteger charIndex,MLTextAttachment *textAttachment))imageBlock
                                    imageAspectRatio:(CGFloat)imageAspectRatio
{
    MLTextAttachment *textAttachment = [MLTextAttachment new];
    textAttachment.lineHeightMultiple = lineHeightMultiple;
    textAttachment.imageBlock = imageBlock;
    textAttachment.imageAspectRatio = imageAspectRatio;
    return textAttachment;
}

//重写以绘制
- (UIImage *)imageForBounds:(CGRect)imageBounds textContainer:(NSTextContainer *)textContainer characterIndex:(NSUInteger)charIndex
{
    if (self.imageBlock)
    {
        return self.imageBlock(imageBounds,textContainer,charIndex,self);
    }
    
    return [super imageForBounds:imageBounds textContainer:textContainer characterIndex:charIndex];
}

//重写以返回附件的大小
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    if (self.imageBlock)
    {
        CGFloat width = self.width;
        CGFloat height = self.height;
        
        // 找到其是否有设置字体，如果有，就根据字体的descender调整下位置,以及lineHeight调整大小
        UIFont *font = [textContainer.layoutManager.textStorage attribute:NSFontAttributeName
                                                                  atIndex:charIndex
                                                           effectiveRange:nil];
        CGFloat baseLineHeight = (font?font.lineHeight:lineFrag.size.height);
        
        if (self.lineHeightMultiple>0) {
            width = height = baseLineHeight*self.lineHeightMultiple;
            if (self.imageAspectRatio>0) {
                width = height*self.imageAspectRatio;
            }
        }else{
            if (width==0&&height==0) {
                width = height = lineFrag.size.height;
            }else if (width==0&&height!=0) {
                width = height;
            }else if (height==0&&width!=0) {
                height = width;
            }
        }
        
        CGFloat y = font.descender;
        y -= (height-baseLineHeight)/2;
        
        return CGRectMake(0, y, width, height);
        
    }
    
    return [super attachmentBoundsForTextContainer:textContainer proposedLineFragment:lineFrag glyphPosition:position characterIndex:charIndex];
}

#pragma mark - setter
- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple
{
    NSAssert(lineHeightMultiple>0, @"lineHeightMultiple必须大于0");
    
    _lineHeightMultiple = lineHeightMultiple;
}
@end
