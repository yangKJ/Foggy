//
//  NSObject+KJUnrecognizedSelectorException.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo
//  没找到对应的函数，其实就是消息转发的最后一步返回函数签名

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KJUnrecognizedSelectorException)

@end

NS_ASSUME_NONNULL_END
