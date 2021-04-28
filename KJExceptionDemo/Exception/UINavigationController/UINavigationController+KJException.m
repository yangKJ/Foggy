//
//  UINavigationController+KJException.m
//  KJExceptionDemo
//
//  Created by yangkejun on 2021/4/26.
//  https://github.com/yangKJ/KJExceptionDemo

#import "UINavigationController+KJException.h"
#import "KJCrashManager.h"

@interface UINavigationController ()<KJCrashProtocol>
@property (nonatomic, assign) BOOL repetition;
@end
@implementation UINavigationController (KJException)
- (BOOL)repetition{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setRepetition:(BOOL)repetition{
    objc_setAssociatedObject(self, @selector(repetition), @(repetition), OBJC_ASSOCIATION_RETAIN);
}
+ (void)kj_openCrashExchangeMethod{
    kExceptionMethodSwizzling(self, @selector(pushViewController:animated:), @selector(kj_pushViewController:animated:));
}
- (void)kj_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.repetition) {
        self.repetition = NO;
        [self kj_pushViewController:viewController animated:animated];
        return;
    }
    if ([[self.viewControllers lastObject] isKindOfClass:viewController.class]) {
        NSString *string = [NSString stringWithFormat:@"🍉🍉 异常标题：%@ 重复跳转",NSStringFromClass([self class])];
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@]: Repeat the push.", NSStringFromClass([viewController class]), NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"重复跳转" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
        return;
    }
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self kj_pushViewController:viewController animated:animated];
}
/// 允许重复跳转push
- (void)kj_canRepetitionPushViewController:(UIViewController*)viewController animated:(BOOL)animated{
    self.repetition = YES;
    [self pushViewController:viewController animated:animated];
}

@end
