//
//  NSObject+KJKVOException.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/29.
//  https://github.com/yangKJ/KJExceptionDemo
//  添加观察者后没有清除、重复添加\移除观察者导致crash

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KJKVOException)

@end

NS_ASSUME_NONNULL_END
