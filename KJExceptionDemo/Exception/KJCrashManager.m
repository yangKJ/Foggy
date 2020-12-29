//
//  KJCrashManager.m
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/10.
//  https://github.com/yangKJ/KJExceptionDemo

#import "KJCrashManager.h"

@interface KJCrashManager ()
@property(nonatomic,copy,readwrite,class) kExceptionBlock exceptionblock;
@end

@implementation KJCrashManager
/// 简单崩溃日志收集，AppDelegate里注册函数 kUncaughtException
NS_INLINE void kUncaughtExceptionHandler(NSException *exception);
void kUncaughtException(void){
    NSSetUncaughtExceptionHandler(&kUncaughtExceptionHandler);
}
NS_INLINE void kUncaughtExceptionHandler(NSException *exception) {
    NSLog(@"**************** 崩溃日志收集器 ****************");
    NSLog(@"%@",exception);
    NSLog(@"%@",exception.callStackReturnAddresses);
    NSLog(@"%@",exception.callStackSymbols);
    NSLog(@"*********************************************");
    
    // 默认信号量方式处理程序
    signal(SIGABRT, SIG_DFL); // abort()函数调用发生的程序终止信号(对象方法不存在、数组越界、内存失败等回调)
    signal(SIGILL, SIG_DFL);  // 非法指令产生的程序终止信号
    signal(SIGSEGV, SIG_DFL); // 无效内存的引用导致程序终止信号(野指针错误)
    signal(SIGFPE, SIG_DFL);  // 浮点数异常导致程序终止信号
    signal(SIGBUS, SIG_DFL);  // 内存地址未对齐导致程序终止信号
    signal(SIGPIPE, SIG_DFL); // 端口发送消息失败导致程序终止信号
}
static kExceptionBlock _exceptionblock = nil;
+ (kExceptionBlock)exceptionblock{return _exceptionblock;}
+ (void)setExceptionblock:(kExceptionBlock)exceptionblock{
    _exceptionblock = exceptionblock;
}
/// 异常回调处理
+ (void)kj_crashBlock:(kExceptionBlock)block{
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
