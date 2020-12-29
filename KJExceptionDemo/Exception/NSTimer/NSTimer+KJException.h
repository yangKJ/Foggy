//
//  NSTimer+KJException.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/17.
//  https://github.com/yangKJ/KJExceptionDemo
//  NStimer 与 target 强引用，内存泄漏

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (KJException)

@end

NS_ASSUME_NONNULL_END
