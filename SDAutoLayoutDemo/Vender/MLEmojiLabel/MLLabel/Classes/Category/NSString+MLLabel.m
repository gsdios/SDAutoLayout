//
//  NSString+MLLabel.m
//  Pods
//
//  Created by molon on 15/6/13.
//
//

#import "NSString+MLLabel.h"

@implementation NSString (MLLabel)

- (NSUInteger)lineCount
{
    if (self.length<=0) { return 0; }
    
    NSUInteger numberOfLines, index, stringLength = [self length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        index = NSMaxRange([self lineRangeForRange:NSMakeRange(index, 0)]);
    }
    
    if ([self isNewlineCharacterAtEnd]) {
        return numberOfLines+1;
    }
    
    return numberOfLines;
}

- (BOOL)isNewlineCharacterAtEnd
{
    if (self.length<=0) {
        return NO;
    }
    //检查最后是否有一个换行符
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSRange lastRange = [self rangeOfCharacterFromSet:separator options:NSBackwardsSearch];
    return (NSMaxRange(lastRange) == self.length);
}

- (NSString*)subStringToLineIndex:(NSUInteger)lineIndex
{
    NSUInteger index = [self lengthToLineIndex:lineIndex];
    
    return [self substringToIndex:index];
}

- (NSUInteger)lengthToLineIndex:(NSUInteger)lineIndex
{
    if (self.length<=0) {
        return 0;
    }
    
    NSUInteger numberOfLines, index, stringLength = [self length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        NSRange lineRange = [self lineRangeForRange:NSMakeRange(index, 0)];
        index = NSMaxRange(lineRange);
        
        if (numberOfLines==lineIndex) {
            NSString *lineString = [self substringWithRange:lineRange];
            if (![lineString isNewlineCharacterAtEnd]) {
                return index;
            }
            //把这行对应的换行符给忽略
            if (NSMaxRange([lineString rangeOfString:@"\r\n"])==lineString.length) {
                return index-2;
            }
            
            return index - 1;
        }
    }
    
    return 0;
}


@end
