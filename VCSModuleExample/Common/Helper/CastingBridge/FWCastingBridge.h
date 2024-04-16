//
//  FWCastingBridge.h
//  AnyMeeting
//
//  Created by SailorGa on 2023/4/20.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 投屏状态通知回调
typedef void(^FWCastingBridgeScreenStatusBlock)(VCSScreenRecordStatus status);
/// 发送延时通知回调
typedef void(^FWCastingBridgeDelayedBlock)(NSInteger timestamp);
/// 发送信息通知回调
typedef void(^FWCastingBridgeSendBlock)(NSString *sendInfo);

@interface FWCastingBridge : NSObject

#pragma mark - 获取投屏单例
/// 获取投屏单例
+ (FWCastingBridge *)sharedManager;

#pragma mark - 配置投屏参数
/// 配置投屏参数
/// - Parameters:
///   - castingConfig: 配置参数
- (void)setupCastingConfig:(VCSScreenCastingConfig *)castingConfig;

#pragma mark - 启动投射音频
/// 启动投射音频
/// - Parameter enable: YES-启用 NO-关闭
- (void)enableCastingAudio:(BOOL)enable;

#pragma mark - 投屏状态通知回调
/// 投屏状态通知回调
/// @param screenStatusBlock 投屏状态通知回调
- (void)screenStatusBlock:(FWCastingBridgeScreenStatusBlock)screenStatusBlock;

#pragma mark - 发送延时通知回调
/// 发送延时通知回调
/// @param delayedBlock 发送延时通知回调
- (void)delayedBlock:(FWCastingBridgeDelayedBlock)delayedBlock;

#pragma mark - 发送信息通知回调
/// 发送信息通知回调
/// @param sendBlock 发送信息通知回调
- (void)sendBlock:(FWCastingBridgeSendBlock)sendBlock;

@end

NS_ASSUME_NONNULL_END
