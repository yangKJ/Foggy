//
//  NSNull+KJException.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/16.
//  https://github.com/yangKJ/KJExceptionDemo
//  后台返回NSNull导致的崩溃，利用消息转发

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSNull (KJException)<KJCrashProtocol>

@end

NS_ASSUME_NONNULL_END
