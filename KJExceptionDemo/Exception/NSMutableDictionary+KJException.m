//
//  NSMutableDictionary+KJException.m
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/10.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSMutableDictionary+KJException.h"

@implementation NSMutableDictionary (KJException)
+ (void)kj_openExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling(objc_getClass("__NSDictionaryM"), @selector(setObject:forKey:), @selector(kj_setObject:forKey:));
        kExceptionMethodSwizzling(objc_getClass("__NSDictionaryM"), @selector(setValue:forKey:), @selector(kj_setValue:forKey:));
        kExceptionMethodSwizzling(objc_getClass("__NSDictionaryM"), @selector(removeObjectForKey:), @selector(kj_removeObjectForKey:));
    });
}
- (void)kj_setObject:(id)object forKey:(id)key{
    @try {
        [self kj_setObject:object forKey:key];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：字典赋值";
        if (key == nil && object  == nil) {
            string = [string stringByAppendingFormat:@"键值均为空，"];
        }else if (key == nil) {
            string = [string stringByAppendingFormat:@"值为(%@)的key为空，",object];
        }else if (object  == nil) {
            string = [string stringByAppendingFormat:@"键为(%@)的value为空，",key];
        }
        [KJExceptionTool kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        
    }
}
- (void)kj_setValue:(id)object forKey:(id)key{
    @try {
        [self kj_setValue:object forKey:key];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：字典赋值";
        if (key == nil && object  == nil) {
            string = [string stringByAppendingFormat:@"键值均为空，"];
        }else if (key == nil) {
            string = [string stringByAppendingFormat:@"值为(%@)的key为空，",object];
        }else if (object  == nil) {
            string = [string stringByAppendingFormat:@"键为(%@)的value为空，",key];
        }
        [KJExceptionTool kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        
    }
}
- (void)kj_removeObjectForKey:(id)key{
    @try {
        [self kj_removeObjectForKey:key];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (key == nil) {
            string = [string stringByAppendingString:@"字典移除键为空"];
        }
        [KJExceptionTool kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        
    }
}

@end

