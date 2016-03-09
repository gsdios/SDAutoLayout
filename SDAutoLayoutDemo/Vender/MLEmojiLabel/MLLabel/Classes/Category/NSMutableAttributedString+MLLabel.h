//
//  NSMutableAttributedString+MLLabel.h
//  MLLabel
//
//  Created by molon on 15/6/5.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (MLLabel)

- (void)removeAllNSOriginalFontAttributes;

- (void)removeAttributes:(NSArray *)names range:(NSRange)range;

@end
