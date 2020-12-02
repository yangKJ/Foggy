//
//  KJExceptionProtocol.h
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/12.
//  https://github.com/yangKJ/KJExceptionDemo

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KJExceptionProtocol <NSObject>
@required
/// 开启方法交换
+ (void)kj_openExchangeMethod;

@end

NS_ASSUME_NONNULL_END
