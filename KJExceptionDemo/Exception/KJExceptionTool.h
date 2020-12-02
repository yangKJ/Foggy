//
//  KJExceptionTool.h
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/10.
//  https://github.com/yangKJ/KJExceptionDemo
//  异常捕获处理

#import <Foundation/Foundation.h>
#import "_KJExceptionHeader.h"
NS_ASSUME_NONNULL_BEGIN
/// 简单崩溃日志收集，AppDelegate里注册函数 kUncaughtException
NS_INLINE void kUncaughtExceptionHandler(NSException *exception);
NS_INLINE void kUncaughtException(void){
    NSSetUncaughtExceptionHandler(&kUncaughtExceptionHandler);
}
NS_INLINE void kUncaughtExceptionHandler(NSException *exception) {
    NSLog(@"**************** 崩溃日志收集器 ****************");
    NSLog(@"%@",exception);
    NSLog(@"%@",exception.callStackReturnAddresses);
    NSLog(@"%@",exception.callStackSymbols);
    NSLog(@"*********************************************");
}
typedef BOOL (^kExceptionBlock)(NSDictionary *dict);
@interface KJExceptionTool : NSObject
/// 开启全部方法交换，只需要开启单个则使用 [NSArray kj_openExchangeMethod];
+ (void)kj_openAllExchangeMethod;
/// 异常回调处理，只需要在最开始的地方调用
+ (void)kj_crashBlock:(kExceptionBlock)block;
/// 异常获取
+ (void)kj_crashDealWithException:(NSException*)exception CrashTitle:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
