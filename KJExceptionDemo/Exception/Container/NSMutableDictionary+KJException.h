//
//  NSMutableDictionary+KJException.h
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/10.
//  https://github.com/yangKJ/KJExceptionDemo

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (KJException)<KJCrashProtocol>

@end

NS_ASSUME_NONNULL_END
