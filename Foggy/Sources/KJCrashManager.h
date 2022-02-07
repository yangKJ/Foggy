//
//  KJCrashManager.h
//  KJExtensionHandler
//
//  Created by Condy on 2020/10/10.
//  https://github.com/yangKJ/Foggy
//  异常捕获处理

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJCrashManager : NSObject
/// 异常回调处理，只需要在最开始的地方调用
extern void kExceptionCrashCallBack(void(^block)(NSDictionary * userInfo));
/// 异常获取解析
extern void kExceptionCrashAnalysis(NSException * exception, NSString * title);
/// 交换实例方法
extern void kExceptionMethodSwizzling(Class clazz, SEL original, SEL swizzled);
/// 交换类方法
extern void kExceptionClassMethodSwizzling(Class clazz, SEL original, SEL swizzled);
/// 是否开启开发模式强制提醒
extern void kExceptionThrowOpen(BOOL open);

@end

@protocol KJCrashProtocol <NSObject>

@optional
+ (void)kj_openCrashExchangeMethod;

@end

NS_ASSUME_NONNULL_END
