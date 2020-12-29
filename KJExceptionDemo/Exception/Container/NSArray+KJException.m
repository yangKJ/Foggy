//
//  NSArray+KJException.m
//  MoLiao
//
//  Created by 杨科军 on 2018/8/28.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSArray+KJException.h"

@implementation NSArray (KJException)

+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSArrayI = objc_getClass("__NSArrayI");
        /// 越界崩溃方式一：[array objectAtIndex:0];
        kExceptionMethodSwizzling(__NSArrayI, @selector(objectAtIndex:), @selector(kj_objectAtIndex:));
        /// 越界崩溃方式二：array[0];
        kExceptionMethodSwizzling(__NSArrayI, @selector(objectAtIndexedSubscript:), @selector(kj_objectAtIndexedSubscript:));
        /// 数组为空
        kExceptionMethodSwizzling(objc_getClass("__NSArray0"), @selector(objectAtIndex:), @selector(kj_objectAtIndexedNullarray:));
    });
}
- (instancetype)kj_objectAtIndex:(NSUInteger)index{
    NSArray *temp = nil;
    @try {
        temp = [self kj_objectAtIndex:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (self.count == 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组索引越界"];
        }
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}

- (instancetype)kj_objectAtIndexedSubscript:(NSUInteger)index{
    NSArray *temp = nil;
    @try {
        temp = [self kj_objectAtIndexedSubscript:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (self.count == 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组索引越界"];
        }
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return temp;
    }
}
- (id)kj_objectAtIndexedNullarray:(NSUInteger)index{
    id object = nil;
    @try {
        object = [self kj_objectAtIndexedNullarray:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (self.count == 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组索引越界"];
        }
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        return object;
    }
}
@end
