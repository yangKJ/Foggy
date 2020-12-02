//
//  KJExceptionTool.m
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/10.
//  https://github.com/yangKJ/KJExceptionDemo

#import "KJExceptionTool.h"

@interface KJExceptionTool ()
@property(nonatomic,copy,readwrite,class) kExceptionBlock exceptionblock;
@end

@implementation KJExceptionTool
static kExceptionBlock _exceptionblock = nil;
+ (kExceptionBlock)exceptionblock{return _exceptionblock;}
+ (void)setExceptionblock:(kExceptionBlock)exceptionblock{
    _exceptionblock = exceptionblock;
}
/// 异常回调处理
+ (void)kj_crashBlock:(kExceptionBlock)block{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSArray kj_openExchangeMethod];
        [NSMutableArray kj_openExchangeMethod];
        [NSDictionary kj_openExchangeMethod];
        [NSMutableDictionary kj_openExchangeMethod];
        [NSMutableString kj_openExchangeMethod];
    });
    self.exceptionblock = block;
}

/// 异常获取
+ (void)kj_crashDealWithException:(NSException*)exception CrashTitle:(NSString*)title{
    NSString *crashMessage = [self kj_analysisCallStackSymbols:[NSThread callStackSymbols]];
    if (crashMessage == nil) crashMessage = @"崩溃方法定位失败,请查看函数调用栈来排查错误原因";
    NSString *crashReason = exception.reason;
    crashReason = [crashReason stringByReplacingOccurrencesOfString:@"avoidCrash" withString:@""];
    NSLog(@"\n************ crash 日志 ************\n标题：%@\n异常原因：%@\n异常地址：%@",title,crashReason,crashMessage);
    if (self.exceptionblock) {
        NSDictionary *dict = @{@"crashTitle":title,
                               @"crashReason":crashReason,
                               @"crashMessage":crashMessage,
                               @"exception":exception
        };
        __weak __typeof(&*self) weakself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.exceptionblock(dict);
        });
    }
}
/// 解析异常消息
+ (NSString*)kj_analysisCallStackSymbols:(NSArray<NSString*>*)callStackSymbols{
    __block NSString *msg = nil;
    NSString *pattern = @"[-\\+]\\[.+\\]";// 匹配出来的格式为 +[类名 方法名] 或者 -[类名 方法名]
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    for (NSInteger i = 2; i < callStackSymbols.count; i++) {
        NSString *matchesString = callStackSymbols[i];
        [regularExp enumerateMatchesInString:matchesString options:NSMatchingReportProgress range:NSMakeRange(0, matchesString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString *tempMsg = [matchesString substringWithRange:result.range];
                NSString *className = [tempMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                if (![className hasSuffix:@")"] && [NSBundle bundleForClass:NSClassFromString(className)] == [NSBundle mainBundle]) {
                    msg = tempMsg;
                }
                *stop = YES;
            }
        }];
        if (msg.length) break;
    }
    return msg;
}

@end
