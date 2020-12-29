//
//  KJCrashProtocol.h
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/12.
//  https://github.com/yangKJ/KJExceptionDemo

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KJCrashProtocol <NSObject>
@optional
+ (void)kj_openCrashExchangeMethod;
+ (void)kj_openUnrecognizedSelectorExchangeMethod;
+ (void)kj_openKVOExchangeMethod;
+ (void)kj_openNullExchangeMethod;
@end

NS_ASSUME_NONNULL_END
