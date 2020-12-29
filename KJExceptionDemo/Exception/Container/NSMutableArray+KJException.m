//
//  NSMutableArray+KJException.m
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/10.
//  https://github.com/yangKJ/KJExceptionDemo

#import "NSMutableArray+KJException.h"

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
        NSString *string = @"🍉🍉 crash：";
        if (self.count <= 0) {
            string = [string stringByAppendingString:@"数组个数为零"];
        }else if (self.count <= index) {
            string = [string stringByAppendingString:@"数组移出索引越界"];
        }
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        
    }
}
- (void)kj_insertObject:(id)anObject atIndex:(NSUInteger)index{
    @try {
        [self kj_insertObject:anObject atIndex:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (anObject == nil) {
            string = [string stringByAppendingString:@"数组插入数据为空"];
        }else {        
            if (self.count <= 0) {
                string = [string stringByAppendingString:@"数组个数为零"];
            }else if (self.count <= index) {
                string = [string stringByAppendingString:@"数组插入索引越界"];
            }
        }
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        
    }
}
- (void)kj_setObject:(id)anObject atIndexedSubscript:(NSUInteger)index{
    @try {
        [self kj_setObject:anObject atIndexedSubscript:index];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：";
        if (anObject == nil) {
            string = [string stringByAppendingString:@"数组更改数据为空"];
        }else{
            if (self.count <= 0) {
                string = [string stringByAppendingString:@"数组个数为零"];
            }else if (self.count <= index) {
                string = [string stringByAppendingString:@"数组更改索引越界"];
            }
        }
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
    }@finally {
        
    }
}

- (instancetype)kj_objectAtIndex:(NSUInteger)index{
    NSMutableArray *temp = nil;
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
    NSMutableArray *temp = nil;
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

- (instancetype)kj_initWithObjects:(const id _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt{
    id instance = nil;
    @try {
        instance = [self kj_initWithObjects:objects count:cnt];
    }@catch (NSException *exception) {
        NSString *string = @"🍉🍉 crash：添加的数据中有空对象";
        [KJCrashManager kj_crashDealWithException:exception CrashTitle:string];
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
