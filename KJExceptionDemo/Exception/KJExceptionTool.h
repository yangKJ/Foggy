//
//  KJExceptionTool.h
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/10.
//  https://github.com/yangKJ/KJExceptionDemo
//  异常捕获处理

#import <Foundation/Foundation.h>
#import "_KJExceptionHeader.h"

NS_ASSUME_NONNULL_BEGIN
typedef BOOL (^kExceptionBlock)(NSDictionary *dict);
@interface KJExceptionTool : NSObject
/// 异常回调处理，只需要在最开始的地方调用
+ (void)kj_crashBlock:(kExceptionBlock)block;


//************************** 内部调用 ******************************
/// 异常获取
+ (void)kj_crashDealWithException:(NSException*)exception CrashTitle:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
