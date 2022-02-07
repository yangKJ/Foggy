//
//  KJCrashManager.m
//  KJExtensionHandler
//
//  Created by Condy on 2020/10/10.
//  https://github.com/yangKJ/Foggy

#import "KJCrashManager.h"

@implementation KJCrashManager
/// 异常回调处理
static void (^_exceptionblock)(NSDictionary * userInfo) = nil;
void kExceptionCrashCallBack(void(^block)(NSDictionary *userInfo)){
    _exceptionblock = block;
}
/// 是否开启开发模式强制提醒
static BOOL _throwOpen = NO;
void kExceptionThrowOpen(BOOL open){
    _throwOpen = open;
}
/// 异常获取解析
void kExceptionCrashAnalysis(NSException *exception, NSString *title){
    NSArray *stacks = [NSThread callStackSymbols];
    NSString *selector = [KJCrashManager kj_analysisCallStackSymbols:stacks];
    if (selector == nil) selector = @"The crash method failed to locate, Check the function call stack to find the cause of the error";
    if (_exceptionblock) {
        NSDictionary *dict = @{
            @"title":title,
            @"selector":selector,
            @"exception":exception,
            @"stacks":stacks
        };
        _exceptionblock(dict);
    }
#ifdef DEBUG
    if (_throwOpen) {
        NSLog(@"\n******************** crash 日志 ********************\
              \n%@\n异常方法：%@\n异常信息：%@\n堆栈信息：%@\n",
              title, selector, exception, stacks);
        @throw exception;//调试模式时，强制抛出异常，提醒开发者代码有问题
    }
#endif
}
/// 解析异常消息
+ (NSString *)kj_analysisCallStackSymbols:(NSArray<NSString *> *)callStackSymbols{
    __block NSString *msg = nil;
    NSString *pattern = @"[-\\+]\\[.+\\]";// 匹配出来的格式为 +[类名 方法名] 或者 -[类名 方法名]
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    for (NSInteger i = 2; i < callStackSymbols.count; i++) {
        NSString *matchesString = callStackSymbols[i];
        NSRange range = NSMakeRange(0, matchesString.length);
        [regularExp enumerateMatchesInString:matchesString options:NSMatchingReportProgress range:range usingBlock:^(NSTextCheckingResult * result, NSMatchingFlags flags, BOOL * stop) {
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

/// 交换方法的实现
void kExceptionMethodSwizzling(Class clazz, SEL original, SEL swizzled){
    Method originalMethod = class_getInstanceMethod(clazz, original);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzled);
    if (class_addMethod(clazz, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(clazz, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
/// 交换类方法
void kExceptionClassMethodSwizzling(Class clazz, SEL original, SEL swizzled){
    Method originalMethod = class_getClassMethod(clazz, original);
    Method swizzledMethod = class_getClassMethod(clazz, swizzled);
    Class metaclass = objc_getMetaClass(NSStringFromClass(clazz).UTF8String);
    if (class_addMethod(metaclass, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(metaclass, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

