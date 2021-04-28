//
//  KJCrashException.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo
//  建议在开发的时候关闭该组件以便及时发现，上架再开启防护组件

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, KJCrashProtectorType) {
    KJCrashProtectorTypeSignal = 1 << 0,// 信号相关崩溃
    KJCrashProtectorTypeRunloopCatonMonitor = 1 << 1,// 卡顿监测，开发时刻测试使用
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
    KJCrashProtectorTypeAll = KJCrashProtectorTypeCustomObeject | KJCrashProtectorTypeSignal | KJCrashProtectorTypeRunloopCatonMonitor | KJCrashProtectorTypeNavigation | KJCrashProtectorTypeUINonMain | KJCrashProtectorTypeNSNull,
};
@class KJExceptionInfo;
@interface KJCrashException : NSObject
/// 是否开启开发模式强制提醒，默认开启
@property (nonatomic, assign, class) BOOL openThrow;
/// 卡顿监测达到几次上报防护，默认5次
@property (nonatomic, assign, class) NSUInteger continuousNumber;
/// 开启指定类型防护
+ (void)kj_openCrashProtectorType:(KJCrashProtectorType)type exception:(void(^)(KJExceptionInfo *userInfo))exception;
/// 兼容第三方的崩溃防护必须先开启此代码，再开启防护
+ (void)kj_compatibilityOtherExceptionHandler;

@end
@interface KJExceptionInfo : NSObject
@property(nonatomic,strong)NSString *title;// 标题
@property(nonatomic,strong)NSString *selector;// 产生异常方法
@property(nonatomic,strong)NSException *exception;// 异常信息
@property(nonatomic,strong)NSArray *stacks;// 堆栈信息

@end

NS_ASSUME_NONNULL_END
