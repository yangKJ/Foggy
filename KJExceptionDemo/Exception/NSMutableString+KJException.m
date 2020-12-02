//
//  NSMutableString+KJException.m
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/10.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSMutableString+KJException.h"

@implementation NSMutableString (KJException)
+ (void)kj_openExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling(objc_getClass("__NSCFString"), @selector(appendString:), @selector(kj_appendString:));
        kExceptionMethodSwizzling(objc_getClass("__NSCFString"), @selector(substringFromIndex:), @selector(kj_substringFromIndex:));
        kExceptionMethodSwizzling(objc_getClass("__NSCFString"), @selector(substringToIndex:), @selector(kj_substringToIndex:));
        kExceptionMethodSwizzling(objc_getClass("__NSCFString"), @selector(substringWithRange:), @selector(kj_substringWithRange:));
    });
}
- (void)kj_appendString:(NSString*)appendString{
    @try {
        [self kj_appendString:appendString];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (string == nil) {
            string = [string stringByAppendingString:@"追加字符串为空"];
        }
        [KJExceptionTool kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        
    }
}
- (NSString*)kj_substringFromIndex:(NSUInteger)from{
    NSString *temp = nil;
    @try {
        temp = [self kj_substringFromIndex:from];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (from > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        [KJExceptionTool kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}

- (NSString*)kj_substringToIndex:(NSUInteger)to{
    NSString *temp = nil;
    @try {
        temp = [self kj_substringToIndex:to];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (to > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        [KJExceptionTool kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}

- (NSString*)kj_substringWithRange:(NSRange)range{
    NSString *temp = nil;
    @try {
        temp = [self kj_substringWithRange:range];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (range.location > self.length || range.length > self.length || (range.location + range.length) > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        [KJExceptionTool kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}

@end
