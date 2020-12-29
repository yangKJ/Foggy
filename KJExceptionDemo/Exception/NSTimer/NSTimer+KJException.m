//
//  NSTimer+KJException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/17.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSTimer+KJException.h"
@interface KJNSTimerProtector : NSObject
@property(nonatomic,weak) id target;
@property(nonatomic,weak) NSTimer *timer;
@property(nonatomic,assign) NSTimeInterval timeInterval;
@property(nonatomic,assign) SEL selector;
@property(nonatomic,assign) id userInfo;
@property(nonatomic,strong) NSString *className;
@property(nonatomic,strong) NSString *methodName;
@end
@implementation KJNSTimerProtector
- (void)kj_fireTimer{
    if (self.target == nil) {
        [self.timer invalidate];
        self.timer = nil;
        NSString *string = [NSString stringWithFormat:@"🍉🍉 crash：%@ 类出现计时器内存泄漏",self.className];
        NSString *reason = [self.methodName stringByAppendingString:@" 🚗🚗方法出现强引用造成内存泄漏🚗🚗"];
        NSException *exception = [NSException exceptionWithName:@"NSTimer抛错" reason:reason userInfo:@{}];
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
        return;
    }
    if ([self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.timer];
#pragma clang diagnostic pop
    }
}
@end

@implementation NSTimer (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionClassMethodSwizzling([NSTimer class], @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:), @selector(kj_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
    });
}
+ (NSTimer*)kj_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats{
    if (repeats == NO) {
        return [self kj_scheduledTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats];
    }
    KJNSTimerProtector * protector = [KJNSTimerProtector new];
    protector.timeInterval = timeInterval;
    protector.target = target;
    protector.selector = selector;
    protector.userInfo = userInfo;
    protector.className = [NSString stringWithCString:object_getClassName(target) encoding:NSASCIIStringEncoding];
    protector.methodName = NSStringFromSelector(selector);
    NSTimer *timer = [NSTimer kj_scheduledTimerWithTimeInterval:timeInterval target:protector selector:@selector(kj_fireTimer) userInfo:userInfo repeats:repeats];
    protector.timer = timer;
    return timer;
}

@end
