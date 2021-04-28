//
//  KJRunloopCatonMonitor.h
//  KJExceptionDemo
//
//  Created by yangkejun on 2020/12/29.
//  https://github.com/yangKJ/KJExceptionDemo

#import <Foundation/Foundation.h>
#import "KJCrashManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface KJRunloopCatonMonitor : NSObject
/// 开启卡顿监测
- (instancetype)initOpenRunloopCatonMonitorWithContinuousNumber:(NSUInteger)continuousNumber;
/// 结束监控卡顿操作
- (void)kj_endRunloopCatonMonitor;

@end

NS_ASSUME_NONNULL_END
