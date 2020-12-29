//
//  NSMutableAttributedString+KJException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSMutableAttributedString+KJException.h"

@implementation NSMutableAttributedString (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteMutableAttributedString = objc_getClass("NSConcreteMutableAttributedString");
        kExceptionMethodSwizzling(NSConcreteMutableAttributedString, @selector(initWithString:), @selector(kj_initWithString:));
        kExceptionMethodSwizzling(NSConcreteMutableAttributedString, @selector(initWithString:attributes:), @selector(kj_initWithString:attributes:));
    });
}
- (instancetype)kj_initWithString:(NSString*)str{
    id temp = nil;
    @try {
        temp = [self kj_initWithString:str];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (str == nil) string = [string stringByAppendingString:@"字符串为空"];
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}
- (instancetype)kj_initWithString:(NSString*)str attributes:(NSDictionary<NSString*,id>*)attrs{
    id temp = nil;
    @try {
        temp = [self kj_initWithString:str attributes:attrs];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (str == nil) string = [string stringByAppendingString:@"字符串为空"];
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}

@end
