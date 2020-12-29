//
//  NSObject+KJKVOException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/29.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSObject+KJKVOException.h"

@implementation NSObject (KJKVOException)
+ (void)kj_openKVOExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling(self, @selector(removeObserver:forKeyPath:), @selector(kj_removeObserver:forKeyPath:));
    });
}
- (void)kj_removeObserver:(NSObject*)observer forKeyPath:(NSString *)keyPath{
    @try {
        [self kj_removeObserver:observer forKeyPath:keyPath];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：添加观察者后没有移除观察者导致";
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        
    }
}

@end
