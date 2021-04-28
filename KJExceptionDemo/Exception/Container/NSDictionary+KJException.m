//
//  NSDictionary+KJException.m
//  MoLiao
//
//  Created by 杨科军 on 2018/7/31.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSDictionary+KJException.h"

@implementation NSDictionary (KJException)

+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSPlaceholderDictionary = objc_getClass("__NSPlaceholderDictionary");
        /// 处理这种方式异常：NSDictionary *dict = @{@"key":nil};
        kExceptionMethodSwizzling(__NSPlaceholderDictionary, @selector(initWithObjects:forKeys:count:), @selector(kj_initWithObjects:forKeys:count:));
        kExceptionMethodSwizzling(__NSPlaceholderDictionary, @selector(dictionaryWithObjects:forKeys:count:), @selector(kj_dictionaryWithObjects:forKeys:count:));
    });
}
- (instancetype)kj_initWithObjects:(const id [])objects forKeys:(const id<NSCopying>[])keys count:(NSUInteger)cnt{
    id instance = nil;
    @try {
        instance = [self kj_initWithObjects:objects forKeys:keys count:cnt];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：字典";
        id _Nonnull __unsafe_unretained safeObjects[cnt],safeKeys[cnt];
        int index = 0;
        for (int i = 0; i < cnt; i++) {
            id _Nonnull __unsafe_unretained key = keys[i],obj = objects[i];
            if (key == nil && obj  == nil) {
                string = [string stringByAppendingFormat:@"第(%d)条数据键值均为空剔除，",i];
                continue;
            }else if (key == nil) {
                string = [string stringByAppendingFormat:@"值为(%@)的key为空，",obj];
                continue;
            }else if (obj  == nil) {
                string = [string stringByAppendingFormat:@"键为(%@)的value为空，",key];
                continue;
            }
            safeKeys[index] = key;
            safeObjects[index] = obj;
            index++;
        }
        kExceptionCrashAnalysis(exception, string);
        instance = [self kj_initWithObjects:safeObjects forKeys:safeKeys count:index];
    }@finally {
        return instance;
    }
}
+ (instancetype)kj_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying>[])keys count:(NSUInteger)cnt{
    id instance = nil;
    @try {
        instance = [self kj_dictionaryWithObjects:objects forKeys:keys count:cnt];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：字典";
        id _Nonnull __unsafe_unretained safeObjects[cnt],safeKeys[cnt];
        int index = 0;
        for (int i = 0; i < cnt; i++) {
            id _Nonnull __unsafe_unretained key = keys[i],obj = objects[i];
            if (key == nil && obj  == nil) {
                string = [string stringByAppendingFormat:@"第(%d)条数据键值均为空剔除，",i];
                continue;
            }else if (key == nil) {
                string = [string stringByAppendingFormat:@"值为(%@)的key为空，",obj];
                continue;
            }else if (obj  == nil) {
                string = [string stringByAppendingFormat:@"键为(%@)的value为空，",key];
                continue;
            }
            safeKeys[index] = key;
            safeObjects[index] = obj;
            index++;
        }
        kExceptionCrashAnalysis(exception, string);
        instance = [self kj_dictionaryWithObjects:safeObjects forKeys:safeKeys count:index];
    }@finally {
        return instance;
    }
}

@end

@implementation NSMutableDictionary (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSDictionaryM = objc_getClass("__NSDictionaryM");
        kExceptionMethodSwizzling(__NSDictionaryM, @selector(setObject:forKey:), @selector(kj_setObject:forKey:));
        kExceptionMethodSwizzling(__NSDictionaryM, @selector(setObject:forKeyedSubscript:), @selector(kj_setObject:forKeyedSubscript:));
        kExceptionMethodSwizzling(__NSDictionaryM, @selector(setValue:forKey:), @selector(kj_setValue:forKey:));
        kExceptionMethodSwizzling(__NSDictionaryM, @selector(removeObjectForKey:), @selector(kj_removeObjectForKey:));
    });
}
- (void)kj_setObject:(id)object forKey:(id<NSCopying>)key{
    @try {
        [self kj_setObject:object forKey:key];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：字典赋值";
        if (key == nil && object  == nil) {
            string = [string stringByAppendingFormat:@"键值均为空，"];
        }else if (key == nil) {
            string = [string stringByAppendingFormat:@"值为(%@)的key为空，",object];
        }else if (object  == nil) {
            string = [string stringByAppendingFormat:@"键为(%@)的value为空，",key];
        }
        kExceptionCrashAnalysis(exception, string);
    }
}
/// iOS11
- (void)kj_setObject:(id)object forKeyedSubscript:(id<NSCopying>)key{
    @try {
        [self kj_setObject:object forKeyedSubscript:key];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：字典赋值";
        if (key == nil && object  == nil) {
            string = [string stringByAppendingFormat:@"键值均为空，"];
        }else if (key == nil) {
            string = [string stringByAppendingFormat:@"值为(%@)的key为空，",object];
        }else if (object  == nil) {
            string = [string stringByAppendingFormat:@"键为(%@)的value为空，",key];
        }
        kExceptionCrashAnalysis(exception, string);
    }
}
- (void)kj_setValue:(id)object forKey:(id<NSCopying>)key{
    @try {
        [self kj_setValue:object forKey:key];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：字典赋值";
        if (key == nil && object  == nil) {
            string = [string stringByAppendingFormat:@"键值均为空，"];
        }else if (key == nil) {
            string = [string stringByAppendingFormat:@"值为(%@)的key为空，",object];
        }else if (object  == nil) {
            string = [string stringByAppendingFormat:@"键为(%@)的value为空，",key];
        }
        kExceptionCrashAnalysis(exception, string);
    }
}
- (void)kj_removeObjectForKey:(id<NSCopying>)key{
    @try {
        [self kj_removeObjectForKey:key];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (key == nil) {
            string = [string stringByAppendingString:@"字典移除键为空"];
        }
        kExceptionCrashAnalysis(exception, string);
    }
}

@end

