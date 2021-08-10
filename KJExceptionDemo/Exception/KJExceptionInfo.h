//
//  KJExceptionInfo.h
//  KJExceptionDemo
//
//  Created by yangkejun on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo
//  崩溃异常信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, KJCrashProtectorType) {
    KJCrashProtectorTypeSignal = 1 << 0,// 信号相关崩溃
    KJCrashProtectorTypeKartunMonitor = 1 << 1,// 卡顿监听
    KJCrashProtectorTypeNavigation = 1 << 2,// Navigation防护重复跳转push
    KJCrashProtectorTypeUINonMain = 1 << 3,// 不在主线程中刷新UI
    KJCrashProtectorTypeNSNull = 1 << 4,// 后台返回NSNull导致的崩溃
    KJCrashProtectorTypeTimer = 1 << 5,// 计时器
    KJCrashProtectorTypeKVO = 1 << 6,// kvo
    KJCrashProtectorTypeKVC = 1 << 7,// kvc
    KJCrashProtectorTypeString = 1 << 8,// 字符串
    KJCrashProtectorTypeUnrecognizedSelector = 1 << 9,// 没找到对应的函数
    KJCrashProtectorTypeUserDefaults = 1 << 10,// NSUserDefaults空键防护
    KJCrashProtectorTypeContainer = 1 << 11,// 数组和字典
    
    // 常用OC防护
    KJCrashProtectorTypeCustomObeject = KJCrashProtectorTypeContainer | KJCrashProtectorTypeUserDefaults | KJCrashProtectorTypeString | KJCrashProtectorTypeTimer | KJCrashProtectorTypeUnrecognizedSelector | KJCrashProtectorTypeKVC | KJCrashProtectorTypeKVO,
    
    // 全部防护
    KJCrashProtectorTypeAll = KJCrashProtectorTypeCustomObeject | KJCrashProtectorTypeSignal | KJCrashProtectorTypeKartunMonitor | KJCrashProtectorTypeNavigation | KJCrashProtectorTypeUINonMain | KJCrashProtectorTypeNSNull,
};

@interface KJExceptionInfo : NSObject

/// 标题
@property (nonatomic, strong) NSString *title;
/// 产生异常方法
@property (nonatomic, strong) NSString *selector;
/// 异常信息
@property (nonatomic, strong) NSException *exception;
/// 堆栈信息
@property (nonatomic, strong) NSArray *stacks;

@end

NS_ASSUME_NONNULL_END
