//
//  KJCrashProtectorManager.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo
//  建议在开发的时候关闭该组件以便及时发现，上架再开启防护组件

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, KJCrashProtectorType) {
    KJCrashProtectorTypeContainer = 1 << 0,// 数组和字典
    KJCrashProtectorTypeString = 1 << 1,// 字符串
    KJCrashProtectorTypeUnrecognizedSelector = 1 << 2,// 没找到对应的函数
    KJCrashProtectorTypeNSNull = 1 << 3,// 后台返回NSNull导致的崩溃
    KJCrashProtectorTypeTimer = 1 << 4,// 计时器
    KJCrashProtectorTypeKVO = 1 << 5,// kvo
    KJCrashProtectorTypeUINonMain = 1 << 6,// 不在主线程中刷新UI
};
@interface KJCrashProtectorManager : NSObject
/// 开启全部防护
+ (void)kj_openAllCrashProtectorManager:(kExceptionBlock)block;
/// 开启指定类型防护
+ (void)kj_openCrashProtectorType:(KJCrashProtectorType)type;

@end

NS_ASSUME_NONNULL_END
