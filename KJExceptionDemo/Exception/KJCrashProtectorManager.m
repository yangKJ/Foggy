//
//  KJCrashProtectorManager.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/14.
//  https://github.com/yangKJ/KJExceptionDemo

#import "KJCrashProtectorManager.h"
#import "NSArray+KJException.h"
#import "NSDictionary+KJException.h"
#import "NSMutableArray+KJException.h"
#import "NSMutableDictionary+KJException.h"
#import "NSMutableString+KJException.h"
#import "NSMutableAttributedString+KJException.h"
#import "NSString+KJException.h"
#import "NSAttributedString+KJException.h"
#import "NSObject+KJUnrecognizedSelectorException.h"
#import "NSNull+KJException.h"
#import "NSTimer+KJException.h"
#import "NSObject+KJKVOException.h"
#import "UIView+KJNonMainException.h"

@implementation KJCrashProtectorManager
/// 开启全部防护
+ (void)kj_openAllCrashProtectorManager:(kExceptionBlock)block{
    if (block) [KJCrashManager kj_crashBlock:block];
    [self kj_openCrashProtectorType:
     KJCrashProtectorTypeContainer |
     KJCrashProtectorTypeString |
     KJCrashProtectorTypeUnrecognizedSelector |
     KJCrashProtectorTypeNSNull |
     KJCrashProtectorTypeTimer |
//     KJCrashProtectorTypeUINonMain |
     KJCrashProtectorTypeKVO];
}
/// 开启指定类型防护
+ (void)kj_openCrashProtectorType:(KJCrashProtectorType)type{
    if (type & KJCrashProtectorTypeContainer) {
        [NSArray kj_openCrashExchangeMethod];
        [NSMutableArray kj_openCrashExchangeMethod];
        [NSDictionary kj_openCrashExchangeMethod];
        [NSMutableDictionary kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeString) {
        [NSString kj_openCrashExchangeMethod];
        [NSMutableString kj_openCrashExchangeMethod];
        [NSAttributedString kj_openCrashExchangeMethod];
        [NSMutableAttributedString kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeUnrecognizedSelector) {
        [NSObject kj_openUnrecognizedSelectorExchangeMethod];
    }
    if (type & KJCrashProtectorTypeNSNull) {
        [NSNull kj_openNullExchangeMethod];
    }
    if (type & KJCrashProtectorTypeTimer) {
        [NSTimer kj_openCrashExchangeMethod];
    }
    if (type & KJCrashProtectorTypeKVO) {
        [NSObject kj_openKVOExchangeMethod];
    }
    if (type & KJCrashProtectorTypeUINonMain) {
        [UIView kj_openCrashExchangeMethod];
    }
}

@end
