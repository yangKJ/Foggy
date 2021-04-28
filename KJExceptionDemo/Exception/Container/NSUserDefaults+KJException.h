//
//  NSUserDefaults+KJException.h
//  KJExceptionDemo
//
//  Created by yangkejun on 2021/4/26.
//  https://github.com/yangKJ/KJExceptionDemo

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (KJException)<KJCrashProtocol>

@end

NS_ASSUME_NONNULL_END
