//
//  NSArray+KJException.h
//  MoLiao
//
//  Created by 杨科军 on 2018/8/28.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExceptionDemo
//  解决数组越界异常崩溃问题

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (KJException)<KJCrashProtocol>

@end

NS_ASSUME_NONNULL_END
