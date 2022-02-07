//
//  NSArray+KJException.m
//  MoLiao
//
//  Created by Condy on 2018/8/28.
//  Copyright © 2018年 Condy. All rights reserved.
//  https://github.com/yangKJ/Foggy

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
        NSString *string = @"🍉🍉 异常标题：";
        if (self.count == 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组索引越界"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}

- (instancetype)kj_objectAtIndexedSubscript:(NSUInteger)index{
    NSArray *temp = nil;
    @try {
        temp = [self kj_objectAtIndexedSubscript:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (self.count == 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组索引越界"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}
- (id)kj_objectAtIndexedNullarray:(NSUInteger)index{
    id object = nil;
    @try {
        object = [self kj_objectAtIndexedNullarray:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (self.count == 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组索引越界"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return object;
    }
}
@end


@implementation NSMutableArray (KJException)
+ (void)kj_openCrashExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSArrayM = objc_getClass("__NSArrayM");
        /// 移除数据越界
        kExceptionMethodSwizzling(__NSArrayM, @selector(removeObjectAtIndex:), @selector(kj_removeObjectAtIndex:));
        /// 插入数据越界
        kExceptionMethodSwizzling(__NSArrayM, @selector(insertObject:atIndex:), @selector(kj_insertObject:atIndex:));
        /// 更改数据越界
        kExceptionMethodSwizzling(__NSArrayM, @selector(setObject:atIndexedSubscript:), @selector(kj_setObject:atIndexedSubscript:));
        /// 越界崩溃：[array objectAtIndex:0]
        kExceptionMethodSwizzling(__NSArrayM, @selector(objectAtIndex:), @selector(kj_objectAtIndex:));
        /// 越界崩溃：array[0]
        kExceptionMethodSwizzling(__NSArrayM, @selector(objectAtIndexedSubscript:), @selector(kj_objectAtIndexedSubscript:));
        /// 添加的数据中有空对象，剔除掉nil
        kExceptionMethodSwizzling(objc_getClass("__NSPlaceholderArray"), @selector(initWithObjects:count:), @selector(kj_initWithObjects:count:));
    });
}

- (void)kj_removeObjectAtIndex:(NSUInteger)index{
    @try {
        [self kj_removeObjectAtIndex:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (self.count <= 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组移出索引越界"];
        }
        kExceptionCrashAnalysis(exception, string);
    }
}
- (void)kj_insertObject:(id)anObject atIndex:(NSUInteger)index{
    @try {
        [self kj_insertObject:anObject atIndex:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (anObject == nil) {
            string = [string stringByAppendingString:@"数组插入数据为空"];
        }else {
            if (self.count <= 0) {
                string = [string stringByAppendingString:@"数组个数为零"];
            }else if (self.count <= index) {
                string = [string stringByAppendingString:@"数组插入索引越界"];
            }
        }
        kExceptionCrashAnalysis(exception, string);
    }
}
- (void)kj_setObject:(id)anObject atIndexedSubscript:(NSUInteger)index{
    @try {
        [self kj_setObject:anObject atIndexedSubscript:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (anObject == nil) {
            string = [string stringByAppendingString:@"数组更改数据为空"];
        }else{
            if (self.count <= 0) {
                string = [string stringByAppendingString:@"数组个数为零"];
            }else if (self.count <= index) {
                string = [string stringByAppendingString:@"数组更改索引越界"];
            }
        }
        kExceptionCrashAnalysis(exception, string);
    }
}

- (instancetype)kj_objectAtIndex:(NSUInteger)index{
    NSMutableArray *temp = nil;
    @try {
        temp = [self kj_objectAtIndex:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (self.count == 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组索引越界"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}

- (instancetype)kj_objectAtIndexedSubscript:(NSUInteger)index{
    NSMutableArray *temp = nil;
    @try {
        temp = [self kj_objectAtIndexedSubscript:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：";
        if (self.count == 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组索引越界"];
        }
        kExceptionCrashAnalysis(exception, string);
    }@finally {
        return temp;
    }
}

- (instancetype)kj_initWithObjects:(const id _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt{
    id instance = nil;
    @try {
        instance = [self kj_initWithObjects:objects count:cnt];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 异常标题：添加的数据中有空对象";
        kExceptionCrashAnalysis(exception, string);
        NSInteger newIndex = 0;
        id _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newIndex] = objects[i];
                newIndex++;
            }
        }
        instance = [self kj_initWithObjects:newObjects count:newIndex];
    }@finally {
        return instance;
    }
}

@end
