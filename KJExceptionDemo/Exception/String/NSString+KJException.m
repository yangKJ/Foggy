//
//  NSString+KJException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSString+KJException.h"

@implementation NSString (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSCFConstantString = objc_getClass("__NSCFConstantString");
        kExceptionMethodSwizzling(__NSCFConstantString, @selector(substringFromIndex:), @selector(kj_substringFromIndex:));
        kExceptionMethodSwizzling(__NSCFConstantString, @selector(substringToIndex:), @selector(kj_substringToIndex:));
        kExceptionMethodSwizzling(__NSCFConstantString, @selector(substringWithRange:), @selector(kj_substringWithRange:));
        kExceptionMethodSwizzling(__NSCFConstantString, @selector(characterAtIndex:), @selector(kj_characterAtIndex:));
    });
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
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
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
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
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
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}
- (unichar)kj_characterAtIndex:(NSUInteger)index{
    unichar temp;
    @try {
        temp = [self kj_characterAtIndex:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (index > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}

@end
