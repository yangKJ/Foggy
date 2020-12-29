//
//  NSAttributedString+KJException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSAttributedString+KJException.h"

@implementation NSAttributedString (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteAttributedString = objc_getClass("NSConcreteAttributedString");
        kExceptionMethodSwizzling(NSConcreteAttributedString, @selector(initWithString:), @selector(kj_initWithString:));
        kExceptionMethodSwizzling(NSConcreteAttributedString, @selector(initWithAttributedString:), @selector(kj_initWithAttributedString:));
        kExceptionMethodSwizzling(NSConcreteAttributedString, @selector(initWithString:attributes:), @selector(kj_initWithString:attributes:));
    });
}
- (instancetype)kj_initWithString:(NSString*)str{
    id object = nil;
    @try {
        object = [self kj_initWithString:str];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (str == nil) string = [string stringByAppendingString:@"字符串为空"];
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return object;
    }
}
- (instancetype)kj_initWithAttributedString:(NSAttributedString*)attrStr{
    id object = nil;
    @try {
        object = [self kj_initWithAttributedString:attrStr];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (attrStr == nil) string = [string stringByAppendingString:@"字符串为空"];
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return object;
    }
}
- (instancetype)kj_initWithString:(NSString*)str attributes:(NSDictionary<NSString*,id>*)attrs {
    id object = nil;
    @try {
        object = [self kj_initWithString:str attributes:attrs];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (str == nil) string = [string stringByAppendingString:@"字符串为空"];
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return object;
    }
}

@end
