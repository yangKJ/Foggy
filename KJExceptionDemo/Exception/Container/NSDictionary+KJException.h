//
//  NSDictionary+KJException.h
//  MoLiao
//
//  Created by 杨科军 on 2018/7/31.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExceptionDemo
//  防止键和值为空的时候崩溃

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (KJException)<KJCrashProtocol>

@end

@interface NSMutableDictionary (KJException)<KJCrashProtocol>

@end

NS_ASSUME_NONNULL_END
