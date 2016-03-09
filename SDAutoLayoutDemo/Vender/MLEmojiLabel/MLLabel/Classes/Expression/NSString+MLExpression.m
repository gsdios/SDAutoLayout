//
//  NSString+MLExpression.m
//  Pods
//
//  Created by molon on 15/6/18.
//
//

#import "NSString+MLExpression.h"

@implementation NSString (MLExpression)

- (NSAttributedString*)expressionAttributedStringWithExpression:(MLExpression*)expression;
{
    return [MLExpressionManager expressionAttributedStringWithString:self expression:expression];
}

@end
