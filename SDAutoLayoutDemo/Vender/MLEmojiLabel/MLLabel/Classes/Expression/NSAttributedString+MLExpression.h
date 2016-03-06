//
//  NSAttributedString+MLExpression.h
//  Pods
//
//  Created by molon on 15/6/18.
//
//

#import <Foundation/Foundation.h>
#import "MLExpressionManager.h"

@interface NSAttributedString (MLExpression)

- (NSAttributedString*)expressionAttributedStringWithExpression:(MLExpression*)expression;
@end
