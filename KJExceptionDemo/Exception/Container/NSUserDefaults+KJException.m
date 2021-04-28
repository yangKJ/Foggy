//
//  NSUserDefaults+KJException.m
//  KJExceptionDemo
//
//  Created by yangkejun on 2021/4/26.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSUserDefaults+KJException.h"

@implementation NSUserDefaults (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class userDefaults = NSClassFromString(@"NSUserDefaults");
        kExceptionMethodSwizzling(userDefaults,@selector(setObject:forKey:),@selector(kj_setObject:forKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(objectForKey:),@selector(kj_objectForKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(stringForKey:),@selector(kj_stringForKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(arrayForKey:),@selector(kj_arrayForKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(dataForKey:),@selector(kj_dataForKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(URLForKey:),@selector(kj_URLForKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(stringArrayForKey:),@selector(kj_stringArrayForKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(floatForKey:),@selector(kj_floatForKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(doubleForKey:),@selector(kj_doubleForKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(integerForKey:),@selector(kj_integerForKey:));
        kExceptionMethodSwizzling(userDefaults,@selector(boolForKey:),@selector(kj_boolForKey:));
    });
}
- (void)kj_setObject:(id)value forKey:(NSString *)defaultName {
    if(!defaultName){
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults存在空key";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: key = %@, value = %@", NSStringFromSelector(_cmd), defaultName, value];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }else{
        [self kj_setObject:value forKey:defaultName];
    }
}

- (id)kj_objectForKey:(NSString *)defaultName {
    id obj = nil;
    if(defaultName){
        obj = [self kj_objectForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

- (NSString *)kj_stringForKey:(NSString *)defaultName {
    id obj = nil;
    if(defaultName){
        obj = [self kj_stringForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

- (NSArray *)kj_arrayForKey:(NSString *)defaultName {
    id obj = nil;
    if(defaultName){
        obj = [self kj_arrayForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

- (NSData *)kj_dataForKey:(NSString *)defaultName {
    id obj = nil;
    if(defaultName){
        obj = [self kj_dataForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

- (NSURL *)kj_URLForKey:(NSString *)defaultName {
    id obj = nil;
    if(defaultName){
        obj = [self kj_URLForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

- (NSArray<NSString *> *)kj_stringArrayForKey:(NSString *)defaultName {
    id obj = nil;
    if(defaultName){
        obj = [self kj_stringArrayForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

- (float)kj_floatForKey:(NSString *)defaultName {
    float obj = 0;
    if(defaultName){
        obj = [self kj_floatForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

- (double)kj_doubleForKey:(NSString *)defaultName {
    double obj = 0;
    if (defaultName){
        obj = [self kj_doubleForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

- (NSInteger)kj_integerForKey:(NSString *)defaultName {
    NSInteger obj = 0;
    if (defaultName){
        obj = [self kj_integerForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

- (BOOL)kj_boolForKey:(NSString *)defaultName {
    BOOL obj = NO;
    if (defaultName){
        obj = [self kj_boolForKey:defaultName];
    }else{
        NSString *string = @"🍉🍉 异常标题：NSUserDefaults读取key为空";
        NSString *reason = [NSString stringWithFormat:@"*** +[NSUserDefaults %@]: The read key is empty.", NSStringFromSelector(_cmd)];
        NSException *exception = [NSException exceptionWithName:@"NSUserDefaults空键" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
    return obj;
}

@end
