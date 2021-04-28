//
//  NSObject+KJException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/29.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSObject+KJException.h"

@implementation NSObject (KJException)
#pragma mark - ************************ kvo ************************
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling(self, @selector(removeObserver:forKeyPath:), @selector(kj_removeObserver:forKeyPath:));
    });
}
- (void)kj_removeObserver:(NSObject*)observer forKeyPath:(NSString *)keyPath{
    @try {
        [self kj_removeObserver:observer forKeyPath:keyPath];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：添加观察者后没有移除观察者导致";
        kExceptionCrashAnalysis(exception, string);
    }
}

#pragma mark - ************************ kvc ************************
+ (void)kj_openKVCExchangeMethod{
    kExceptionMethodSwizzling(self, @selector(setValue:forKey:), @selector(kj_setValue:forKey:));
}
- (void)kj_setValue:(id)value forKey:(NSString *)key{
    @try {
        [self kj_setValue:value forKey:key];
    }@catch (NSException *exception) {
        NSString *string = [@"🍉🍉 异常标题：使用 KVC 时崩溃 " stringByAppendingFormat:@"key = %@, value = %@",key, value];
        kExceptionCrashAnalysis(exception, string);
    }
}
- (void)setNilValueForKey:(NSString *)key{
    NSString *string = [NSString stringWithFormat:@"🍉🍉 异常标题：%@ KVC设置存在空值",NSStringFromClass([self class])];
    NSString *reason = [NSString stringWithFormat:@"*** -[%@ setNilValueForKey:]: %@ is nil", NSStringFromClass([self class]), key];
    NSException *exception = [NSException exceptionWithName:@"KVC设置异常" reason:reason userInfo:@{}];
    kExceptionCrashAnalysis(exception, string);
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSString *string = [NSString stringWithFormat:@"🍉🍉 异常标题：%@ KVC设置存在空值",NSStringFromClass([self class])];
    NSString *reason;
    if (value != nil) {
        reason = [NSString stringWithFormat:@"*** -[%@ setValue:forUndefinedKey:]: There is no corresponding property '%@', value = %@", NSStringFromClass([self class]), key, value];
    }else{
        reason = [NSString stringWithFormat:@"*** -[%@ setValue:forUndefinedKey:]: key = %@, value = %@", NSStringFromClass([self class]), key, value];
    }
    NSException *exception = [NSException exceptionWithName:@"KVC设置异常" reason:reason userInfo:@{}];
    kExceptionCrashAnalysis(exception, string);
}
- (nullable id)valueForUndefinedKey:(NSString *)key{
    NSString *string = [NSString stringWithFormat:@"🍉🍉 异常标题：%@ KVC设置存在空值",NSStringFromClass([self class])];
    NSString *reason = [NSString stringWithFormat:@"*** -[%@ valueForUndefinedKey:]: %@ is nil", NSStringFromClass([self class]), key];
    NSException *exception = [NSException exceptionWithName:@"KVC设置异常" reason:reason userInfo:@{}];
    kExceptionCrashAnalysis(exception, string);
    return self;
}

#pragma mark - ************************ UnrecognizedSelector ************************
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
    NSString *string = [NSString stringWithFormat:@"🍉🍉 异常标题：%@ 类出现未找到实例方法",NSStringFromClass([self class])];
    NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@]: Instance method not found.", NSStringFromClass([self class]), NSStringFromSelector(anInvocation.selector)];
    NSException *exception = [NSException exceptionWithName:@"没找到实例方法" reason:reason userInfo:@{}];
    kExceptionCrashAnalysis(exception, string);
}

+ (NSMethodSignature*)kj_methodSignatureForSelector:(SEL)aSelector{
    if ([self respondsToSelector:aSelector]) {
        return [self kj_methodSignatureForSelector:aSelector];
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}
+ (void)kj_forwardInvocation:(NSInvocation*)anInvocation{
    NSString *string = [NSString stringWithFormat:@"🍉🍉 异常标题：%@ 类出现未找到类方法",NSStringFromClass([self class])];
    NSString *reason = [NSString stringWithFormat:@"*** +[%@ %@]: Class method not found.", NSStringFromClass([self class]), NSStringFromSelector(anInvocation.selector)];
    NSException *exception = [NSException exceptionWithName:@"没找到类方法" reason:reason userInfo:@{}];
    kExceptionCrashAnalysis(exception, string);
}

@end
