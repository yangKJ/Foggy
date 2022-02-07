//
//  _Foggy.h
//  Foggy
//
//  Created by yangkejun on 2020/12/14.
//  https://github.com/yangKJ/Foggy
//  崩溃异常信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, FoggyType) {
    FoggyTypeSignal = 1 << 0,// 信号相关崩溃
    FoggyTypeKartunMonitor = 1 << 1,// 卡顿监听
    FoggyTypeNavigation = 1 << 2,// Navigation防护重复跳转push
    FoggyTypeUINonMain = 1 << 3,// 不在主线程中刷新UI
    FoggyTypeNSNull = 1 << 4,// 后台返回NSNull导致的崩溃
    FoggyTypeTimer = 1 << 5,// 计时器
    FoggyTypeKVO = 1 << 6,// kvo
    FoggyTypeKVC = 1 << 7,// kvc
    FoggyTypeString = 1 << 8,// 字符串
    FoggyTypeUnrecognizedSelector = 1 << 9,// 没找到对应的函数
    FoggyTypeUserDefaults = 1 << 10,// NSUserDefaults空键防护
    FoggyTypeContainer = 1 << 11,// 数组和字典
    
    // 常用OC防护
    FoggyTypeCustomObeject =
    FoggyTypeContainer | FoggyTypeUserDefaults | FoggyTypeString |
    FoggyTypeTimer | FoggyTypeUnrecognizedSelector | FoggyTypeKVC | FoggyTypeKVO,
    
    // 全部防护
    FoggyTypeAll =
    FoggyTypeCustomObeject | FoggyTypeSignal | FoggyTypeKartunMonitor |
    FoggyTypeNavigation | FoggyTypeUINonMain | FoggyTypeNSNull,
};

@interface _Foggy : NSObject

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
