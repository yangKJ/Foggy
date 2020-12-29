//
//  NSObject+KJCustomException.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/15.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSObject+KJCustomException.h"
#if OBJC_API_VERSION >= 2
#define kGetClass(obj) object_getClass(obj)
#else
#define kGetClass(obj) (obj ? obj->isa : Nil)
#endif
@implementation NSObject (KJCustomException)
/// 交换方法的实现
void kExceptionMethodSwizzling(Class clazz, SEL original, SEL swizzled){
    Method originalMethod = class_getInstanceMethod(clazz, original);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzled);
    if (class_addMethod(clazz, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(clazz, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
/// 交换类方法
void kExceptionClassMethodSwizzling(Class clazz, SEL original, SEL swizzled){
    Method originalMethod = class_getClassMethod(clazz, original);
    Method swizzledMethod = class_getClassMethod(clazz, swizzled);
    Class metaclass = objc_getMetaClass(NSStringFromClass(clazz).UTF8String);
    if (class_addMethod(metaclass, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(metaclass, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
