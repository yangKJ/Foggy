//
//  NSTimer+KJException.m
//  Foggy
//
//  Created by Condy on 2020/12/17.
//  https://github.com/yangKJ/Foggy

#import "NSTimer+KJException.h"
// 抽象类，抽象类中弱引用target
@interface KJProxyProtector : NSProxy
+ (instancetype)kj_proxyWithTarget:(id)target selector:(SEL)selector;
@property(nonatomic,weak)id target;
@end
@implementation KJProxyProtector
+ (instancetype)kj_proxyWithTarget:(id)target selector:(SEL)selector{
    if (target == nil) {
        NSString *name = [NSString stringWithCString:object_getClassName(target) encoding:NSASCIIStringEncoding];
        NSString *string = [NSString stringWithFormat:@"🍉🍉 异常标题：%@ 类出现计时器强引用内存泄漏", name];
        NSString *reason = [NSString stringWithFormat:@"*** +[%@ %@]: Strong references cause memory leaks.", name, NSStringFromSelector(selector)];
        NSException *exception = [NSException exceptionWithName:@"NSTimer抛错" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    KJProxyProtector *proxy = [KJProxyProtector alloc];
    proxy.target = target;
    return proxy;
}
- (NSMethodSignature*)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}
- (void)forwardInvocation:(NSInvocation*)invocation{
    [invocation invokeWithTarget:self.target];
}
@end
@implementation NSTimer (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 创建定时器并把它指定到默认的runloop模式中，并且在TimeInterval时间后启动定时器
        kExceptionClassMethodSwizzling([NSTimer class], @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:), @selector(kj_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
        // 创建定时器，但是么有添加到运行循环，需要在创建定时器后手动调用NSRunLoop对象的addTimer:forMode:方法
        kExceptionClassMethodSwizzling([NSTimer class], @selector(timerWithTimeInterval:target:selector:userInfo:repeats:), @selector(kj_timerWithTimeInterval:target:selector:userInfo:repeats:));
    });
}
+ (NSTimer*)kj_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats{
    return [self kj_scheduledTimerWithTimeInterval:timeInterval target:[KJProxyProtector kj_proxyWithTarget:target selector:selector] selector:selector userInfo:userInfo repeats:repeats];
}
+ (NSTimer*)kj_timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats{
    return [self kj_timerWithTimeInterval:timeInterval target:[KJProxyProtector kj_proxyWithTarget:target selector:selector] selector:selector userInfo:userInfo repeats:repeats];
}

@end
