//
//  UINavigationController+KJException.h
//  KJExceptionDemo
//
//  Created by yangkejun on 2021/4/26.
//  https://github.com/yangKJ/KJExceptionDemo
//  防护重复跳转

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (KJException)

/// 允许重复跳转push
- (void)kj_canRepetitionPushViewController:(UIViewController*)viewController animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
