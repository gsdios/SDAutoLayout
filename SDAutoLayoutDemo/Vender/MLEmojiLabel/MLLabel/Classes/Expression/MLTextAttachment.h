//
//  MLTextAttachment.h
//  MLLabel
//
//  Created by molon on 15/6/11.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLTextAttachment : NSTextAttachment

@property (readonly, nonatomic, assign) CGFloat width;
@property (readonly, nonatomic, assign) CGFloat height;

/**
 *  优先级比上面的高，以lineHeight为根据来决定高度
 *  宽度根据imageAspectRatio来定
 */
@property (readonly, nonatomic, assign) CGFloat lineHeightMultiple;

/**
 *  image.size.width/image.size.height
 */
@property (readonly, nonatomic, assign) CGFloat imageAspectRatio;

+ (instancetype)textAttachmentWithWidth:(CGFloat)width height:(CGFloat)height imageBlock:(UIImage * (^)(CGRect imageBounds,NSTextContainer *textContainer,NSUInteger charIndex,MLTextAttachment *textAttachment))imageBlock;

+ (instancetype)textAttachmentWithLineHeightMultiple:(CGFloat)lineHeightMultiple imageBlock:(UIImage * (^)(CGRect imageBounds,NSTextContainer *textContainer,NSUInteger charIndex,MLTextAttachment *textAttachment))imageBlock
                                    imageAspectRatio:(CGFloat)imageAspectRatio;

@end
