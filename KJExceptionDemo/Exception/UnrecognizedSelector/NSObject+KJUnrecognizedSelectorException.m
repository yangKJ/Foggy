//
//  NSObject+KJUnrecognizedSelectorException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSObject+KJUnrecognizedSelectorException.h"

@implementation NSObject (KJUnrecognizedSelectorException)
+ (void)kj_openUnrecognizedSelectorExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling(self, @selector(methodSignatureForSelector:), @selector(kj_methodSignatureForSelector:));
        kExceptionMethodSwizzling(self, @selector(forwardInvocation:), @selector(kj_forwardInvocation:));
        kExceptionClassMethodSwizzling(self, @selector(methodSignatureForSelector:), @selector(kj_methodSignatureForSelector:));
        kExceptionClassMethodSwizzling(self, @selector(forwardInvocation:), @selector(kj_forwardInvocation:));
    });
}
- (NSMethodSignature*)kj_methodSignatureForSelector:(SEL)aSelector{
    if ([self respondsToSelector:aSelector]) {
        return [self kj_methodSignatureForSelector:aSelector];
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}
- (void)kj_forwardInvocation:(NSInvocation*)anInvocation{
    NSString *string = [NSString stringWithFormat:@"🍉🍉 crash：%@ 类出现未找到实例方法",NSStringFromClass([self class])];
    NSString *reason = [NSStringFromSelector(anInvocation.selector) stringByAppendingString:@" 🚗🚗实例方法未找到🚗🚗"];
    NSException *exception = [NSException exceptionWithName:@"没找到方法" reason:reason userInfo:@{}];
    [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
}

+ (NSMethodSignature*)kj_methodSignatureForSelector:(SEL)aSelector{
    if ([self respondsToSelector:aSelector]) {
        return [self kj_methodSignatureForSelector:aSelector];
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}
+ (void)kj_forwardInvocation:(NSInvocation*)anInvocation{
    NSString *string = [NSString stringWithFormat:@"🍉🍉 crash：%@ 类出现未找到类方法",NSStringFromClass([self class])];
    NSString *reason = [NSStringFromSelector(anInvocation.selector) stringByAppendingString:@" 🚗🚗类方法未找到🚗🚗"];
    NSException *exception = [NSException exceptionWithName:@"没找到方法" reason:reason userInfo:@{}];
    [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
}

@end
