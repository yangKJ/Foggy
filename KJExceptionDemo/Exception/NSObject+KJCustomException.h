//
//  NSObject+KJCustomException.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/15.
//  https://github.com/yangKJ/KJExceptionDemo
//  公共类，存放公共部分
#import <Foundation/Foundation.h>
#import "KJCrashProtocol.h"
#import <objc/message.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KJCustomException)<KJCrashProtocol>
/// 交换实例方法
void kExceptionMethodSwizzling(Class clazz, SEL original, SEL swizzled);
/// 交换类方法
void kExceptionClassMethodSwizzling(Class clazz, SEL original, SEL swizzled);

@end

NS_ASSUME_NONNULL_END
