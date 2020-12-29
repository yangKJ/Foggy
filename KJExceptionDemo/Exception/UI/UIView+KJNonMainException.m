//
//  UIView+KJNonMainException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/29.
//  https://github.com/yangKJ/KJExceptionDemo

#import "UIView+KJNonMainException.h"

@implementation UIView (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling(self, @selector(setNeedsLayout), @selector(kj_setNeedsLayout));
        kExceptionMethodSwizzling(self, @selector(layoutIfNeeded), @selector(kj_layoutIfNeeded));
        kExceptionMethodSwizzling(self, @selector(layoutSubviews), @selector(kj_layoutSubviews));
        kExceptionMethodSwizzling(self, @selector(setNeedsUpdateConstraints), @selector(kj_setNeedsUpdateConstraints));
    });
}
- (void)kj_setNeedsLayout{
    if ([NSThread isMainThread]) {
        [self kj_setNeedsLayout];
    }else{
        kGCD_Exception_main(^{
            [self kj_setNeedsLayout];
            [self kj_setSelector:_cmd];
        });
    }
}

- (void)kj_layoutIfNeeded{
    if ([NSThread isMainThread]) {
        [self kj_layoutIfNeeded];
    }else{
        kGCD_Exception_main(^{
            [self kj_layoutIfNeeded];
            [self kj_setSelector:_cmd];
        });
    }
}

- (void)kj_layoutSubviews{
    if ([NSThread isMainThread]) {
        [self kj_layoutSubviews];
    }else{
        kGCD_Exception_main(^{
            [self kj_layoutSubviews];
            [self kj_setSelector:_cmd];
        });
    }
}

- (void)kj_setNeedsUpdateConstraints{
    if ([NSThread isMainThread]) {
        [self kj_setNeedsUpdateConstraints];
    }else{
        kGCD_Exception_main(^{
            [self kj_setNeedsUpdateConstraints];
            [self kj_setSelector:_cmd];
        });
    }
}
/// 主线程
static void kGCD_Exception_main(dispatch_block_t block) {
    dispatch_queue_t queue = dispatch_get_main_queue();
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    }else{
        if ([[NSThread currentThread] isMainThread]) {
            dispatch_async(queue, block);
        }else{
            dispatch_sync(queue, block);
        }
    }
}
- (void)kj_setSelector:(SEL)selector{
    NSString *string = [NSString stringWithFormat:@"🍉🍉 crash：%@ 类未在主线程当时刷新UI",NSStringFromClass([self class])];
    NSString *reason = [NSStringFromSelector(selector) stringByAppendingString:@" 🚗🚗未在主线程当时刷新UI🚗🚗"];
    NSException *exception = [NSException exceptionWithName:@"UIKit Called on Non-Main Thread" reason:reason userInfo:@{}];
    [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
}

@end
