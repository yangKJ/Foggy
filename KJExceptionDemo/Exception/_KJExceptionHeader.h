//
//  _KJExceptionHeader.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/2.
//  https://github.com/yangKJ/KJExceptionDemo

#ifndef _KJExceptionHeader_h
#define _KJExceptionHeader_h

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

#import "KJExceptionProtocol.h"
#import "KJExceptionTool.h"

#import "NSArray+KJException.h"
#import "NSDictionary+KJException.h"
#import "NSMutableArray+KJException.h"
#import "NSMutableDictionary+KJException.h"
#import "NSMutableString+KJException.h"

/// 这里只适合放简单的函数
NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

/// 交换方法的实现
NS_INLINE void kExceptionMethodSwizzling(Class clazz, SEL original, SEL swizzled) {
    Method method   = class_getInstanceMethod(clazz, original);
    Method swmethod = class_getInstanceMethod(clazz, swizzled);
    if (class_addMethod(clazz, original, method_getImplementation(swmethod), method_getTypeEncoding(swmethod))) {
        class_replaceMethod(clazz, swizzled, method_getImplementation(method), method_getTypeEncoding(method));
    }else{
        method_exchangeImplementations(method, swmethod);
    }
}

/// 简单崩溃日志收集，AppDelegate里注册函数 kUncaughtException
NS_INLINE void kUncaughtExceptionHandler(NSException *exception);
NS_INLINE void kUncaughtException(void){
    NSSetUncaughtExceptionHandler(&kUncaughtExceptionHandler);
}
NS_INLINE void kUncaughtExceptionHandler(NSException *exception) {
    NSLog(@"**************** 崩溃日志收集器 ****************");
    NSLog(@"%@",exception);
    NSLog(@"%@",exception.callStackReturnAddresses);
    NSLog(@"%@",exception.callStackSymbols);
    NSLog(@"*********************************************");
}


#pragma clang diagnostic pop
NS_ASSUME_NONNULL_END
#endif

#endif /* _KJExceptionHeader_h */
