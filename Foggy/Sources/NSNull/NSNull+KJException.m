//
//  NSNull+KJException.m
//  _Foggy
//
//  Created by Condy on 2020/12/16.
//  https://github.com/yangKJ/Foggy

#import "NSNull+KJException.h"
#import "KJCrashManager.h"

@implementation NSNull (KJException)
static NSString *kSaveDataKey = @"kSaveDataKey";
- (NSMutableDictionary *)data{
    NSMutableDictionary *data = objc_getAssociatedObject(self, &kSaveDataKey);
    if (data == nil) {
        data = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &kSaveDataKey, data, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return data;
}

+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling(self, @selector(methodSignatureForSelector:), @selector(kj_null_methodSignatureForSelector:));
        kExceptionMethodSwizzling(self, @selector(forwardInvocation:), @selector(kj_null_forwardInvocation:));
    });
}

- (NSMethodSignature *)kj_null_methodSignatureForSelector:(SEL)selector{
    @synchronized ([self class]) {
        NSString *selString = NSStringFromSelector(selector);
        NSMethodSignature *signature = nil;
        NSRange range = [selString rangeOfString:@"set"];
        if (range.length) {
            signature = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
        } else {
            signature = [NSMethodSignature signatureWithObjCTypes:"@@:"];
        }
        return signature;
    }
}

- (void)kj_null_forwardInvocation:(NSInvocation *)invocation{
    NSString *key = NSStringFromSelector(invocation.selector);
    NSRange range = [key rangeOfString:@"set"];
    if (range.length) {
        key = [[key substringFromIndex:3] lowercaseString];
        id obj;
        [invocation getArgument:&obj atIndex:2];
        [self.data setObject:obj forKey:key];
    } else {
        id obj = self.data[key];
        [invocation setReturnValue:&obj];
        NSString *string = [@"🍉🍉 异常标题：" stringByAppendingFormat:@"%@ 类型值", invocation.target];
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@]: Have %@.", NSStringFromClass([self class]), key, invocation.target];
        NSException *exception = [NSException exceptionWithName:@"空值" reason:reason userInfo:@{}];
        kExceptionCrashAnalysis(exception, string);
    }
}

@end
