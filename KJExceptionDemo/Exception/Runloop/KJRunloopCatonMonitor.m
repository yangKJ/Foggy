//
//  KJRunloopCatonMonitor.m
//  KJExceptionDemo
//
//  Created by yangkejun on 2020/12/29.
//  https://github.com/yangKJ/KJExceptionDemo

#import "KJRunloopCatonMonitor.h"

@interface KJRunloopCatonMonitor (){
    CFRunLoopActivity __runLoopActivity;
    CFRunLoopObserverRef runLoopObserver;
    dispatch_semaphore_t dispatchSemaphore;
}
@property (nonatomic, assign) int timeoutCount;
@property (nonatomic, assign) NSUInteger continuousNumber;
@end

@implementation KJRunloopCatonMonitor
/// 开启卡顿监测
- (instancetype)initOpenRunloopCatonMonitorWithContinuousNumber:(NSUInteger)continuousNumber{
    if (self = [super init]) {
        self.continuousNumber = continuousNumber;
        [self beginRunloopCatonMonitor];
    }
    return self;
}

- (void)beginRunloopCatonMonitor{
    if (runLoopObserver) return;
    dispatchSemaphore = dispatch_semaphore_create(0);
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                              kCFRunLoopAllActivities,
                                              YES,
                                              0,
                                              &kRunLoopObserverCallBack,
                                              &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    __weak __typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            // 监控卡顿的时间阀值设置为20ms
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->runLoopObserver) {
                    weakself.timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->__runLoopActivity = kCFRunLoopEntry;
                    return;
                }
                if (self->__runLoopActivity == kCFRunLoopBeforeSources || self->__runLoopActivity == kCFRunLoopAfterWaiting) {
                    if (++weakself.timeoutCount < weakself.continuousNumber) {
                        continue;
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        NSString *string = @"🍉🍉 异常标题：存在卡顿页面";
                        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@]: Runloop caton.", NSStringFromClass([weakself class]), NSStringFromSelector(_cmd)];
                        NSException *exception = [NSException exceptionWithName:@"卡顿" reason:reason userInfo:@{}];
                        kExceptionCrashAnalysis(exception, string);
                    });
                }
            }
            weakself.timeoutCount = 0;
        }
    });
}
//结束监控卡顿操作
- (void)kj_endRunloopCatonMonitor{
    if (!runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}
/*
 kCFRunLoopEntry = (1UL << 0),         // 进入 loop
 kCFRunLoopBeforeTimers = (1UL << 1),  // 触发 Timer 回调
 kCFRunLoopBeforeSources = (1UL << 2), // 触发 Source0 回调
 kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠状态，休眠时等待 mach_port 消息
 kCFRunLoopAfterWaiting = (1UL << 6),  // 唤醒后接收 mach_port 消息（唤醒线程后的状态）
 kCFRunLoopExit = (1UL << 7),          // 退出 loop
 kCFRunLoopAllActivities = 0x0FFFFFFFU // loop 所有状态改变
 */
static void kRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    KJRunloopCatonMonitor *monitor = (__bridge KJRunloopCatonMonitor*)info;
    monitor->__runLoopActivity = activity;
    dispatch_semaphore_t semaphore = monitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

@end
