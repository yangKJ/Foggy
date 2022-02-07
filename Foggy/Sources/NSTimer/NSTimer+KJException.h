//
//  NSTimer+KJException.h
//  Foggy
//
//  Created by Condy on 2020/12/17.
//  https://github.com/yangKJ/Foggy
//  NStimer 与 target 强引用，内存泄漏

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (KJException)<KJCrashProtocol>

@end

NS_ASSUME_NONNULL_END
