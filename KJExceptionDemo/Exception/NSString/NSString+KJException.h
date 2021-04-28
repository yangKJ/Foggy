//
//  NSString+KJException.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (KJException)<KJCrashProtocol>

@end

@interface NSMutableString (KJException)<KJCrashProtocol>

@end

@interface NSAttributedString (KJException)<KJCrashProtocol>

@end

@interface NSMutableAttributedString (KJException)<KJCrashProtocol>

@end

NS_ASSUME_NONNULL_END
