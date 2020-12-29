//
//  NSNull+KJException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/16.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSNull+KJException.h"

@implementation NSNull (KJException)
+ (void)kj_openNullExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling(self, @selector(methodSignatureForSelector:), @selector(kj_null_methodSignatureForSelector:));
        kExceptionMethodSwizzling(self, @selector(forwardInvocation:), @selector(kj_null_forwardInvocation:));
    });
}
- (NSMethodSignature*)kj_null_methodSignatureForSelector:(SEL)selector{
    NSMethodSignature *signature = [self kj_null_methodSignatureForSelector:selector];
    if (signature == nil){
        NSArray *classTemp = @[[NSMutableArray class],
                               [NSMutableDictionary class],
                               [NSMutableString class],
                               [NSNumber class],
                               [NSDate class],
                               [NSData class]];
        for (Class someClass in classTemp) {
            @try {
                if ([someClass instancesRespondToSelector:selector]) {
                    signature = [someClass instanceMethodSignatureForSelector:selector];
                    break;
                }
            }@catch (NSException *exception) {
                NSString *string = @"🍉🍉 crash：后台返回NSNull导致的崩溃";
                [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
            }@finally {
                
            }
        }
    }
    return signature;
}
- (void)kj_null_forwardInvocation:(NSInvocation*)invocation{
    invocation.target = nil;
    [invocation invoke];
}

@end
