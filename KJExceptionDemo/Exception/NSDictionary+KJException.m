//
//  NSDictionary+KJException.m
//  MoLiao
//
//  Created by 杨科军 on 2018/7/31.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSDictionary+KJException.h"

@implementation NSDictionary (KJException)

+ (void)kj_openExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /// 处理这种方式异常：NSDictionary *dict = @{@"key":nil};
        kExceptionMethodSwizzling(objc_getClass("__NSPlaceholderDictionary"), @selector(initWithObjects:forKeys:count:), @selector(kj_initWithObjects:forKeys:count:));
        kExceptionMethodSwizzling(objc_getClass("__NSPlaceholderDictionary"), @selector(dictionaryWithObjects:forKeys:count:), @selector(kj_dictionaryWithObjects:forKeys:count:));
    });
}
- (instancetype)kj_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt{
    id instance = nil;
    @try {
        instance = [self kj_initWithObjects:objects forKeys:keys count:cnt];
    }@catch (NSException *exception) {
        NSString *string = @"Exception handling remove nil key-values and instance a dictionary: 字典赋值存在空\n";
        id _Nonnull __unsafe_unretained safeObjects[cnt],safeKeys[cnt];
        int index = 0;
        for (int i = 0; i < cnt; i++) {
            id _Nonnull __unsafe_unretained key = keys[i],obj = objects[i];
            if (key == nil || obj  == nil) {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"key:%@, val:%@\n",key,obj]];
                continue;
            }
            safeKeys[index] = key;
            safeObjects[index] = obj;
            index++;
        }
        [KJExceptionTool kj_crashDealWithException:exception CrashTitle:string];
        instance = [self kj_initWithObjects:safeObjects forKeys:safeKeys count:index];
    }@finally {
        return instance;
    }
}
+ (instancetype)kj_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt{
    id instance = nil;
    @try {
        instance = [self kj_dictionaryWithObjects:objects forKeys:keys count:cnt];
    }@catch (NSException *exception) {
        NSString *string = @"Exception handling remove nil key-values and instance a dictionary: 字典赋值存在空\n";
        id _Nonnull __unsafe_unretained safeObjects[cnt],safeKeys[cnt];
        int index = 0;
        for (int i = 0; i < cnt; i++) {
            id _Nonnull __unsafe_unretained key = keys[i],obj = objects[i];
            if (key == nil || obj  == nil) {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"key:%@, val:%@\n",key,obj]];
                continue;
            }
            safeKeys[index] = key;
            safeObjects[index] = obj;
            index++;
        }
        [KJExceptionTool kj_crashDealWithException:exception CrashTitle:string];
        instance = [self kj_dictionaryWithObjects:safeObjects forKeys:safeKeys count:index];
    }@finally {
        return instance;
    }
}

@end

