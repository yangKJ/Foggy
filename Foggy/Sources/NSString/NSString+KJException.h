//
//  NSString+KJException.h
//  Foggy
//
//  Created by Condy on 2020/12/14.
//  https://github.com/yangKJ/Foggy

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
