//
//  MLExpressionManager.m
//  Pods
//
//  Created by molon on 15/6/18.
//
//

#import "MLExpressionManager.h"
#import "MLTextAttachment.h"

/*
 如果设置高于1.00f的话，会引起 有表情行的行距 显得比 没表情行的行距 多，显得不工整
 https://github.com/molon/MLLabel/issues/1
 所以我们还是设置为1.00f，至于怎么解决这个问题，请参考Demo里的ClipExpressionViewController
 */
#define kExpressionLineHeightMultiple 1.00f

@interface MLExpression()

@property (nonatomic, copy) NSString *regex;
@property (nonatomic, copy) NSString *plistName;
@property (nonatomic, copy) NSString *bundleName;

@property (nonatomic, strong) NSRegularExpression *expressionRegularExpression;
@property (nonatomic, strong) NSDictionary *expressionMap;

- (BOOL)isValid;

@end

@interface MLExpressionManager()

@property (nonatomic, strong) NSMutableDictionary *expressionMapRecords;
@property (nonatomic, strong) NSMutableDictionary *expressionRegularExpressionRecords;

@end

@implementation MLExpressionManager

+ (instancetype)sharedInstance {
    static MLExpressionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc]init];
    });
    return _sharedInstance;
}

#pragma mark - getter
- (NSMutableDictionary *)expressionMapRecords
{
    if (!_expressionMapRecords) {
        _expressionMapRecords = [NSMutableDictionary new];
    }
    return _expressionMapRecords;
}

- (NSMutableDictionary *)expressionRegularExpressionRecords
{
    if (!_expressionRegularExpressionRecords) {
        _expressionRegularExpressionRecords = [NSMutableDictionary new];
    }
    return _expressionRegularExpressionRecords;
}

#pragma mark - common
- (NSDictionary*)expressionMapWithPlistName:(NSString*)plistName
{
    NSAssert(plistName&&plistName.length>0, @"expressionMapWithRegex:参数不得为空");
    
    if (self.expressionMapRecords[plistName]) {
        return self.expressionMapRecords[plistName];
    }
    
    NSString *plistPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plistName];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSAssert(dict,@"表情字典%@找不到,请注意大小写",plistName);
    self.expressionMapRecords[plistName] = dict;
    
    return self.expressionMapRecords[plistName];
}

- (NSRegularExpression*)expressionRegularExpressionWithRegex:(NSString*)regex
{
    NSAssert(regex&&regex.length>0, @"expressionRegularExpressionWithRegex:参数不得为空");
    
    if (self.expressionRegularExpressionRecords[regex]) {
        return self.expressionRegularExpressionRecords[regex];
    }
    
    NSRegularExpression *re = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSAssert(re,@"正则%@有误",regex);
    self.expressionRegularExpressionRecords[regex] = re;
    
    return self.expressionRegularExpressionRecords[regex];
}

//多线程转表情attrStr
+ (NSArray *)expressionAttributedStringsWithStrings:(NSArray*)strings expression:(MLExpression*)expression
{
    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:strings.count];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (id str in strings) {
        dispatch_group_async(group, queue, ^{
            NSAttributedString *result = [MLExpressionManager expressionAttributedStringWithString:str expression:expression];
            
            @synchronized(results){
                results[str] = result;
            }
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    //重新排列
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:results.count];
    for (id str in strings) {
        [resultArr addObject:results[str]];
    }

    return resultArr;
}

+ (void)expressionAttributedStringsWithStrings:(NSArray*)strings expression:(MLExpression*)expression callback:(void(^)(NSArray *result))callback
{
    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:strings.count];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (id str in strings) {
        dispatch_group_async(group, queue, ^{
            NSAttributedString *result = [MLExpressionManager expressionAttributedStringWithString:str expression:expression];
            
            @synchronized(results){
                results[str] = result;
            }
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        //重新排列
        NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:results.count];
        for (id str in strings) {
            [resultArr addObject:results[str]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(resultArr);
            }
        });
    });
}

+ (NSAttributedString*)expressionAttributedStringWithString:(id)string expression:(MLExpression*)expression {
    NSAssert(expression&&[expression isValid], @"expression invalid");
    NSAssert([string isKindOfClass:[NSString class]]||[string isKindOfClass:[NSAttributedString class]], @"string非字符串. %@",string);
    
    NSAttributedString *attributedString = nil;
    if ([string isKindOfClass:[NSString class]]) {
        attributedString = [[NSAttributedString alloc]initWithString:string];
    }else{
        attributedString = string;
    }
    
    if (attributedString.length<=0) {
        return attributedString;
    }
    
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    
    //处理表情
    NSArray *results = [expression.expressionRegularExpression matchesInString:attributedString.string
                                                            options:NSMatchingWithTransparentBounds
                                                              range:NSMakeRange(0, [attributedString length])];
    //遍历表情，然后找到对应图像名称，并且处理
    NSUInteger location = 0;
    for (NSTextCheckingResult *result in results) {
        NSRange range = result.range;
        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:NSMakeRange(location, range.location - location)];
        //先把非表情的部分加上去
        [resultAttributedString appendAttributedString:subAttrStr];
        
        //下次循环从表情的下一个位置开始
        location = NSMaxRange(range);
        
        NSAttributedString *expressionAttrStr = [attributedString attributedSubstringFromRange:range];
        NSString *imageName = expression.expressionMap[expressionAttrStr.string];
        if (imageName.length>0) {
            //加个表情到结果中
            NSString *imagePath = [expression.bundleName stringByAppendingPathComponent:imageName];
            UIImage *image = [UIImage imageNamed:imagePath];
            
            MLTextAttachment *textAttachment = [MLTextAttachment textAttachmentWithLineHeightMultiple:kExpressionLineHeightMultiple imageBlock:^UIImage *(CGRect imageBounds, NSTextContainer *textContainer, NSUInteger charIndex, MLTextAttachment *textAttachment) {
                return image;
            } imageAspectRatio:image.size.width/image.size.height];
            [resultAttributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
        }else{
            //找不到对应图像名称就直接加上去
            [resultAttributedString appendAttributedString:expressionAttrStr];
        }
    }
    
    if (location < [attributedString length]) {
        //到这说明最后面还有非表情字符串
        NSRange range = NSMakeRange(location, [attributedString length] - location);
        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:range];
        [resultAttributedString appendAttributedString:subAttrStr];
    }
    
    return resultAttributedString;
}

@end



@implementation MLExpression

- (BOOL)isValid
{
    return self.expressionRegularExpression&&self.expressionMap&&self.bundleName.length>0;
}

+ (instancetype)expressionWithRegex:(NSString*)regex plistName:(NSString*)plistName bundleName:(NSString*)bundleName
{
    MLExpression *expression = [MLExpression new];
    expression.regex = regex;
    expression.plistName = plistName;
    expression.bundleName = bundleName;
    NSAssert([expression isValid], @"此expression无效，请检查参数");
    return expression;
}

#pragma mark - setter
- (void)setRegex:(NSString *)regex
{
    NSAssert(regex.length>0, @"regex length must >0");
    _regex = regex;
    
    self.expressionRegularExpression = [[MLExpressionManager sharedInstance]expressionRegularExpressionWithRegex:regex];
}

- (void)setPlistName:(NSString *)plistName
{
    
    NSAssert(plistName.length>0, @"plistName's length must >0");
    

    if (![[plistName lowercaseString] hasSuffix:@".plist"]) {
        plistName = [plistName stringByAppendingString:@".plist"];
    }
    
    _plistName = plistName;
    
    self.expressionMap = [[MLExpressionManager sharedInstance]expressionMapWithPlistName:plistName];
}

- (void)setBundleName:(NSString *)bundleName
{
    if (![[bundleName lowercaseString] hasSuffix:@".bundle"]) {
        bundleName = [bundleName stringByAppendingString:@".bundle"];
    }
    
    _bundleName = bundleName;
    //TODO: 这个最好验证下存在性，后期搞
}


@end

