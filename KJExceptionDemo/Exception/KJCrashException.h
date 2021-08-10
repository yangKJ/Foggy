//
//  KJCrashException.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo
//  建议在开发的时候关闭该组件以便及时发现，上架再开启防护组件

#import <Foundation/Foundation.h>
#import "KJExceptionInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface KJCrashException : NSObject

/// 是否开启开发模式强制提醒，默认开启
@property (nonatomic, assign, class) BOOL openThrow;

/// 开启指定类型防护
/// @param type 防护类型，支持多枚举
/// @param exception 崩溃回调
+ (void)kj_openCrashProtectorType:(KJCrashProtectorType)type
                        exception:(void(^)(KJExceptionInfo * userInfo))exception;

/// 兼容第三方的崩溃防护必须先开启此代码，再开启防护
+ (void)kj_compatibilityOtherExceptionHandler;

@end

NS_ASSUME_NONNULL_END
