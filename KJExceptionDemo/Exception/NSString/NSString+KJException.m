//
//  NSString+KJException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSString+KJException.h"

#pragma mark - ******************************** NSString ********************************
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
        NSString *string = @"🍉🍉 异常标题：";
        if (from > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}
- (NSString*)kj_substringToIndex:(NSUInteger)to{
    NSString *temp = nil;
    @try {
        temp = [self kj_substringToIndex:to];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (to > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}
- (NSString*)kj_substringWithRange:(NSRange)range{
    NSString *temp = nil;
    @try {
        temp = [self kj_substringWithRange:range];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (range.location > self.length || range.length > self.length || (range.location + range.length) > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}
- (unichar)kj_characterAtIndex:(NSUInteger)index{
    unichar temp;
    @try {
        temp = [self kj_characterAtIndex:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (index > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}

@end


#pragma mark - ******************************** NSMutableString ********************************
@implementation NSMutableString (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSCFString = objc_getClass("__NSCFString");
        kExceptionMethodSwizzling(__NSCFString, @selector(appendString:), @selector(kj_appendString:));
        kExceptionMethodSwizzling(__NSCFString, @selector(substringFromIndex:), @selector(kj_substringFromIndex:));
        kExceptionMethodSwizzling(__NSCFString, @selector(substringToIndex:), @selector(kj_substringToIndex:));
        kExceptionMethodSwizzling(__NSCFString, @selector(substringWithRange:), @selector(kj_substringWithRange:));
    });
}
- (void)kj_appendString:(NSString*)appendString{
    @try {
        [self kj_appendString:appendString];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (appendString == nil) {
            string = [string stringByAppendingString:@"追加字符串为空"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        
    }
}
- (NSString*)kj_substringFromIndex:(NSUInteger)from{
    NSString *temp = nil;
    @try {
        temp = [self kj_substringFromIndex:from];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (from > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}

- (NSString*)kj_substringToIndex:(NSUInteger)to{
    NSString *temp = nil;
    @try {
        temp = [self kj_substringToIndex:to];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (to > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}

- (NSString*)kj_substringWithRange:(NSRange)range{
    NSString *temp = nil;
    @try {
        temp = [self kj_substringWithRange:range];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (range.location > self.length || range.length > self.length || (range.location + range.length) > self.length) {
            string = [string stringByAppendingString:@"字符串长度不够"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}

@end


#pragma mark - ******************************** NSAttributedString ********************************
@implementation NSAttributedString (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteAttributedString = objc_getClass("NSConcreteAttributedString");
        kExceptionMethodSwizzling(NSConcreteAttributedString, @selector(initWithString:), @selector(kj_initWithString:));
        kExceptionMethodSwizzling(NSConcreteAttributedString, @selector(initWithAttributedString:), @selector(kj_initWithAttributedString:));
        kExceptionMethodSwizzling(NSConcreteAttributedString, @selector(initWithString:attributes:), @selector(kj_initWithString:attributes:));
    });
}
- (instancetype)kj_initWithString:(NSString*)str{
    id object = nil;
    @try {
        object = [self kj_initWithString:str];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (str == nil) string = [string stringByAppendingString:@"字符串为空"];
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return object;
    }
}
- (instancetype)kj_initWithAttributedString:(NSAttributedString*)attrStr{
    id object = nil;
    @try {
        object = [self kj_initWithAttributedString:attrStr];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (attrStr == nil) string = [string stringByAppendingString:@"字符串为空"];
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return object;
    }
}
- (instancetype)kj_initWithString:(NSString*)str attributes:(NSDictionary<NSString*,id>*)attrs {
    id object = nil;
    @try {
        object = [self kj_initWithString:str attributes:attrs];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (str == nil) string = [string stringByAppendingString:@"字符串为空"];
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return object;
    }
}

@end

#pragma mark - ******************************** NSMutableAttributedString ********************************
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
        NSString *string = @"🍉🍉 异常标题：";
        if (str == nil) string = [string stringByAppendingString:@"字符串为空"];
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}
- (instancetype)kj_initWithString:(NSString*)str attributes:(NSDictionary<NSString*,id>*)attrs{
    id temp = nil;
    @try {
        temp = [self kj_initWithString:str attributes:attrs];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (str == nil) string = [string stringByAppendingString:@"字符串为空"];
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}

@end
