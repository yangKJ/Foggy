//
//  KJCrashException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo

#import "KJCrashException.h"
#import "NSArray+KJException.h"
#import "NSDictionary+KJException.h"
#import "NSString+KJException.h"
#import "NSNull+KJException.h"
#import "NSTimer+KJException.h"
#import "UIView+KJException.h"
#import "NSObject+KJException.h"
#import "UINavigationController+KJException.h"
#import "NSUserDefaults+KJException.h"
#import "KJRunloopCatonMonitor.h"

@implementation KJCrashException
static BOOL __open = YES;
static NSUInteger __continuous = 5;
@dynamic openThrow,continuousNumber;
+ (void)setOpenThrow:(BOOL)openThrow{
    __open = openThrow;
    kExceptionThrowOpen(__open);
}
+ (void)setContinuousNumber:(NSUInteger)continuousNumber{
    __continuous = continuousNumber;
}
/// 开启指定类型防护
+ (void)kj_openCrashProtectorType:(KJCrashProtectorType)type exception:(void(^)(KJExceptionInfo *userInfo))exception{
    kExceptionThrowOpen(__open);
    if (exception) {
        kExceptionCrashCallBack(^(NSDictionary * _Nonnull userInfo) {
            KJExceptionInfo *info = [KJExceptionInfo new];
            info.title = userInfo[@"title"];
            info.selector = userInfo[@"selector"];
            info.exception = userInfo[@"exception"];
            info.stacks = userInfo[@"stacks"];
            exception(info);
        });
    }
    if (type & KJCrashProtectorTypeSignal) {
        kSetSignalCrashException();
    }
    if (type & KJCrashProtectorTypeRunloopCatonMonitor) {
#ifdef DEBUG
        KJRunloopCatonMonitor *monitor = [[KJRunloopCatonMonitor alloc] initOpenRunloopCatonMonitorWithContinuousNumber:__continuous];
#endif
    }
    if (type & KJCrashProtectorTypeContainer) {
        [NSArray kj_openCrashExchangeMethod];
        [NSMutableArray kj_openCrashExchangeMethod];
        [NSDictionary kj_openCrashExchangeMethod];
        [NSMutableDictionary kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeUserDefaults) {
        [NSUserDefaults kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeString) {// 切记顺序别乱改，否则会出问题
        [NSString kj_openCrashExchangeMethod];
        [NSMutableString kj_openCrashExchangeMethod];
        [NSAttributedString kj_openCrashExchangeMethod];
        [NSMutableAttributedString kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeUnrecognizedSelector) {
        [NSObject kj_openUnrecognizedSelectorExchangeMethod];
    }
    if (type & KJCrashProtectorTypeNSNull) {
        [NSNull kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeTimer) {
        [NSTimer kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeKVO) {
        [NSObject kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeUINonMain) {
        [UIView kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeNavigation) {
        [UINavigationController kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeKVC) {
        [NSObject kj_openKVCExchangeMethod];
    }
}
NS_INLINE void kSetSignalCrashException(void){
    // 默认信号量方式处理程序
    signal(SIGABRT, kSignalCrashException); // abort()函数调用发生的程序终止信号(对象方法不存在、数组越界、内存失败等回调)
    signal(SIGILL,  kSignalCrashException); // 非法指令产生的程序终止信号
    signal(SIGSEGV, kSignalCrashException); // 无效内存的引用导致程序终止信号(野指针错误)
    signal(SIGFPE,  kSignalCrashException); // 浮点数异常导致程序终止信号
    signal(SIGBUS,  kSignalCrashException); // 内存地址未对齐导致程序终止信号
    signal(SIGPIPE, kSignalCrashException); // 端口发送消息失败导致程序终止信号
    signal(SIGKILL, kSignalCrashException); // 进程内无法拦截
    signal(SIGTRAP, kSignalCrashException); // 由断点指令或其它trap指令产生
}
///异常信号处理回调
NS_INLINE void kSignalCrashException(int signal) {
    NSString *signalString = @"UNKNOWN";
    NSString *reason = @" 🚗🚗未知信号类型错误🚗🚗";
    switch (signal) {
        case SIGABRT:{
            signalString = @"SIGABRT";
            reason = @" 🚗🚗abort()函数调用发生的程序终止信号(对象方法不存在、数组越界、内存失败等回调)类型错误🚗🚗";
        }break;
        case SIGILL:{
            signalString = @"SIGILL";
            reason = @" 🚗🚗非法指令产生的程序终止信号类型错误🚗🚗";
        }break;
        case SIGSEGV:{
            signalString = @"SIGSEGV";
            reason = @" 🚗🚗无效内存的引用导致程序终止信号(野指针错误)类型错误🚗🚗";
        }break;
        case SIGFPE:{
            signalString = @"SIGFPE";
            reason = @" 🚗🚗浮点数异常导致程序终止信号类型错误🚗🚗";
        }break;
        case SIGBUS:{
            signalString = @"SIGBUS";
            reason = @" 🚗🚗内存地址未对齐导致程序终止信号类型错误🚗🚗";
        }break;
        case SIGPIPE:{
            signalString = @"SIGPIPE";
            reason = @" 🚗🚗端口发送消息失败导致程序终止信号类型错误🚗🚗";
        }break;
        case SIGKILL:{
            signalString = @"SIGKILL";
            reason = @" 🚗🚗进程内无法拦截类型错误🚗🚗";
        }break;
        case SIGTRAP:{
            signalString = @"SIGTRAP";
            reason = @" 🚗🚗由断点指令或其它trap指令产生类型错误🚗🚗";
        }break;
    }
    NSString *string = [NSString stringWithFormat:@"🍉🍉 异常信号：%@",signalString];
    NSException *exception = [NSException exceptionWithName:@"信号类型异常" reason:reason userInfo:@{}];
    kExceptionCrashAnalysis(exception, string);
}

#pragma mark - NSException捕获
/// 其他三方注册的异常处理
static NSUncaughtExceptionHandler *otherCrashException = NULL;
+ (void)kj_compatibilityOtherExceptionHandler{
    otherCrashException = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(kOtherCrashException);
}
/// 异常捕获处理
NS_INLINE void kOtherCrashException(NSException *exception) {
    if (otherCrashException) otherCrashException(exception);
    NSString *string = @"🍉🍉 异常：其他三方注册的异常处理";
    kExceptionCrashAnalysis(exception, string);
}

@end

@implementation KJExceptionInfo

@end
