//
//  NSArray+KJException.h
//  MoLiao
//
//  Created by Condy on 2018/8/28.
//  Copyright © 2018年 Condy. All rights reserved.
//  https://github.com/yangKJ/Foggy
//  解决数组越界异常崩溃问题

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (KJException)<KJCrashProtocol>

@end

@interface NSMutableArray (KJException)<KJCrashProtocol>

@end

NS_ASSUME_NONNULL_END
