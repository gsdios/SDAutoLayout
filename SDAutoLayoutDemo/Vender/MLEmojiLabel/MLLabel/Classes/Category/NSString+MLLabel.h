//
//  NSString+MLLabel.h
//  Pods
//
//  Created by molon on 15/6/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MLLabel)

//这个只是由于换行符的原因所必须有的行数
- (NSUInteger)lineCount;

//拿到某行之前的字符串
- (NSString*)subStringToLineIndex:(NSUInteger)lineIndex;

//拿到某行之前的字符串的长度
- (NSUInteger)lengthToLineIndex:(NSUInteger)lineIndex;

//是否最后字符属于换行符
- (BOOL)isNewlineCharacterAtEnd;
@end
