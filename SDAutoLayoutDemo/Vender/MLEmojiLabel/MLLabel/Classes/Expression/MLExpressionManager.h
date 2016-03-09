//
//  MLExpressionManager.h
//  Pods
//
//  Created by molon on 15/6/18.
//
//

#import <Foundation/Foundation.h>

@interface MLExpression : NSObject

@property (readonly, nonatomic, copy) NSString *regex;
@property (readonly, nonatomic, copy) NSString *plistName;
@property (readonly, nonatomic, copy) NSString *bundleName;

+ (instancetype)expressionWithRegex:(NSString*)regex plistName:(NSString*)plistName bundleName:(NSString*)bundleName;

@end

@interface MLExpressionManager : NSObject

+ (instancetype)sharedInstance;

//获取对应的表情attrStr
+ (NSAttributedString*)expressionAttributedStringWithString:(id)string expression:(MLExpression*)expression;
//给一个str数组，返回其对应的表情attrStr数组，顺序一致
+ (NSArray *)expressionAttributedStringsWithStrings:(NSArray*)strings expression:(MLExpression*)expression;
//同上，但是以回调方式返回
+ (void)expressionAttributedStringsWithStrings:(NSArray*)strings expression:(MLExpression*)expression callback:(void(^)(NSArray *result))callback;

@end
