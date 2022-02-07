//
//  UIView+KJException.m
//  Foggy
//
//  Created by Condy on 2020/12/29.
//  https://github.com/yangKJ/Foggy

#import "UIView+KJException.h"

@implementation UIView (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling(self, @selector(setNeedsLayout), @selector(kj_setNeedsLayout));
        kExceptionMethodSwizzling(self, @selector(setNeedsDisplay), @selector(kj_setNeedsDisplay));
        kExceptionMethodSwizzling(self, @selector(setNeedsDisplayInRect:), @selector(kj_setNeedsDisplayInRect:));
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

- (void)kj_setNeedsDisplay{
    if ([NSThread isMainThread]) {
        [self kj_setNeedsDisplay];
    }else{
        kGCD_Exception_main(^{
            [self kj_setNeedsDisplay];
            [self kj_setSelector:_cmd];
        });
    }
}

- (void)kj_setNeedsDisplayInRect:(CGRect)rect{
    if ([NSThread isMainThread]) {
        [self kj_setNeedsDisplayInRect:rect];
    }else{
        kGCD_Exception_main(^{
            [self kj_setNeedsDisplayInRect:rect];
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
    NSString *string = @"🍉🍉 异常标题：未在主线程当时刷新UI";
    NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@]: UIKit Called on Non-Main Thread.", NSStringFromClass([self class]), NSStringFromSelector(selector)];
    NSException *exception = [NSException exceptionWithName:@"未在主线程当时刷新UI" reason:reason userInfo:@{}];
    kExceptionCrashAnalysis(exception, string);
}

@end
