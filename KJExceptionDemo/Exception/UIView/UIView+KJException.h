//
//  UIView+KJException.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/29.
//  https://github.com/yangKJ/KJExceptionDemo
//  不在主线程当中执行，导致UIKit Called on Non-Main Thread

#import <UIKit/UIKit.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KJException)

@end

NS_ASSUME_NONNULL_END
