//
//  NSTimer+KJException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/17.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSTimer+KJException.h"
// 抽象类，抽象类中弱引用target
@interface KJProxyProtector : NSProxy
+ (instancetype)kj_proxyWithTarget:(id)target selector:(SEL)selector;
@property(nonatomic,weak)id target;/// 消息转发的对象
@end
@implementation KJProxyProtector
+ (instancetype)kj_proxyWithTarget:(id)target selector:(SEL)selector{
    if (target == nil) {
        NSString *string = [NSString stringWithFormat:@"🍉🍉 crash：%@ 类出现计时器内存泄漏",[NSString stringWithCString:object_getClassName(target) encoding:NSASCIIStringEncoding]];
        NSString *reason = [NSStringFromSelector(selector) stringByAppendingString:@" 🚗🚗方法出现强引用造成内存泄漏🚗🚗"];
        NSException *exception = [NSException exceptionWithName:@"NSTimer抛错" reason:reason userInfo:@{}];
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
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
