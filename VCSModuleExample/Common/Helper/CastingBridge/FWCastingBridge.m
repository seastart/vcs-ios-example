//
//  FWCastingBridge.m
//  AnyMeeting
//
//  Created by SailorGa on 2023/4/20.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWCastingBridge.h"

@interface FWCastingBridge () <VCSScreenCastingDelegate>

/// 当前投屏状态
@property (nonatomic, assign) VCSScreenCastingStatus screenCastingStatus;
/// 当前屏幕录制状态
@property (nonatomic, assign) VCSScreenRecordStatus screenRecordStatus;
/// 屏幕录制组件
@property (strong, nonatomic) RPSystemBroadcastPickerView *broadcastPickerView;
/// 投屏状态通知回调
@property (copy, nonatomic) FWCastingBridgeScreenStatusBlock screenStatusBlock;
/// 发送延时通知回调
@property (copy, nonatomic) FWCastingBridgeDelayedBlock delayedBlock;
/// 发送信息通知回调
@property (copy, nonatomic) FWCastingBridgeSendBlock sendBlock;

@end

@implementation FWCastingBridge

#pragma mark - 获取投屏单例
/// 获取投屏单例
+ (FWCastingBridge *)sharedManager {
    
    static FWCastingBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWCastingBridge alloc] init];
    });
    return manager;
}

#pragma mark 对象初始化
/// 对象初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        /// 恢复默认投屏状态
        self.screenCastingStatus = VCSScreenCastingStatusNormal;
        /// 恢复默认屏幕录制状态
        self.screenRecordStatus = VCSScreenRecordStatusNormal;
    }
    return self;
}

#pragma mark - 屏幕录制组件
- (RPSystemBroadcastPickerView *)broadcastPickerView API_AVAILABLE(ios(12.0)) {
    
    if (!_broadcastPickerView) {
        _broadcastPickerView = [[RPSystemBroadcastPickerView alloc] init];
        _broadcastPickerView.preferredExtension = @"cn.seastart.vcsmediakit.replayBroadcastUpload";
        _broadcastPickerView.showsMicrophoneButton = NO;
        _broadcastPickerView.hidden = YES;
    }
    return _broadcastPickerView;
}

#pragma mark - 配置投屏参数
/// 配置投屏参数
/// - Parameters:
///   - castingConfig: 配置参数
- (void)setupCastingConfig:(VCSScreenCastingConfig *)castingConfig {
    
    if (self.screenRecordStatus == VCSScreenRecordStatusStart) {
        /// 停止投屏二次确认
        [self stopCastingAlert];
        /// 结束此次调用
        return;
    }
    
    /// 显示加载框
    [FWToastBridge showToastAction];
    /// 配置投屏参数
    [[VCSScreenCasting sharedInstance] setupCastingConfig:castingConfig appGroup:FWAPPGROUP delegate:self];
}

#pragma mark - 启动投射音频
/// 启动投射音频
/// - Parameter enable: YES-启用 NO-关闭
- (void)enableCastingAudio:(BOOL)enable {
    
    /// 启动投射音频
    [[VCSScreenCasting sharedInstance] enableCastingAudio:enable];
}

#pragma mark - 停止投屏再次确认
/// 停止投屏再次确认
- (void)stopCastingAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要停止投屏吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        /// 停止投屏
        [[VCSScreenCasting sharedInstance] stopCasting];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [[FWEntryBridge sharedManager].appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 显示选择器视图
/// 显示选择器视图
- (void)showBroadcastPicker {
    
    /// 将事件传递给开启录制按钮
    for (UIView *view in self.broadcastPickerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view sendActionsForControlEvents:UIControlEventTouchDown | UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - ------- VCSCastingManagerDelegate代理实现 -------
#pragma mark 投屏检测状态回调
/// 投屏检测状态回调
/// @param screenCasting 投屏实例
/// @param status 状态码
/// @param reason 拒绝原因
- (void)screenCasting:(VCSScreenCasting *)screenCasting onCastingProbesStatus:(VCSScreenCastingStatus)status reason:(nullable NSString *)reason {
    
    /// 隐藏加载框
    [FWToastBridge hiddenToastAction];
    
    /// 提示操作信息
    NSString *toastStr = @"默认状态";
    switch (status) {
        case VCSScreenCastingStatusNormal:
            toastStr = @"默认状态";
            break;
        case VCSScreenCastingStatusAccept:
            toastStr = @"允许投屏";
            break;
        case VCSScreenCastingStatusRefuse:
            toastStr = @"拒绝投屏";
            break;
        case VCSScreenCastingStatusFailed:
            toastStr = @"投屏失败";
            break;
        case VCSScreenCastingStatusWarning:
            toastStr = @"投屏预警";
            break;
        default:
            break;
    }
    SGLOG(@"投屏状态 = %@, 原因 = %@", toastStr, reason);
    
    /// 允许投屏
    if (status == VCSScreenCastingStatusAccept) {
        /// 显示选择器视图
        [self showBroadcastPicker];
    }
    
    /// 拒绝投屏提示
    if (status == VCSScreenCastingStatusRefuse && !kStringIsEmpty(reason)) {
        [FWToastBridge showToastAction:reason];
    }
    
    /// 投屏失败提示
    if (status == VCSScreenCastingStatusFailed) {
        [FWToastBridge showToastAction:@"投屏失败，请稍后重试。"];
    }
    
    /// 投屏预警提示
    if (status == VCSScreenCastingStatusWarning) {
        [FWToastBridge showToastAction:reason];
    }
}

#pragma mark 屏幕录制状态回调
/// 屏幕录制状态回调
/// @param screenCasting 投屏实例
/// @param status 状态码
- (void)screenCasting:(VCSScreenCasting *)screenCasting onScreenRecordStatus:(VCSScreenRecordStatus)status {
    
    /// 记录当前共享屏幕状态
    self.screenRecordStatus = status;
    
    /// 提示操作信息
    NSString *toastStr = @"连接错误";
    switch (status) {
        case VCSScreenRecordStatusError:
            toastStr = @"连接错误";
            break;
        case VCSScreenRecordStatusStop:
            toastStr = @"已经停止";
            break;
        case VCSScreenRecordStatusStart:
            toastStr = @"已经开始";
            break;
        default:
            break;
    }
    SGLOG(@"屏幕录制状态 = %@", toastStr);
    
    /// 投屏状态通知回调
    if (self.screenStatusBlock) {
        self.screenStatusBlock(status);
    }
}

#pragma mark 投屏状态回调
/// 投屏状态回调
/// @param screenCasting 投屏实例
/// @param status 状态码
/// @param reason 拒绝原因
- (void)screenCasting:(VCSScreenCasting *)screenCasting onCastingScreenStatus:(VCSScreenCastingStatus)status reason:(nullable NSString *)reason {
    
    /// 记录当前投屏状态
    self.screenCastingStatus = status;
    
    /// 提示操作信息
    NSString *toastStr = @"默认状态";
    switch (status) {
        case VCSScreenCastingStatusNormal:
            toastStr = @"默认状态";
            break;
        case VCSScreenCastingStatusAccept:
            toastStr = @"允许投屏";
            break;
        case VCSScreenCastingStatusRefuse:
            toastStr = @"拒绝投屏";
            break;
        case VCSScreenCastingStatusFailed:
            toastStr = @"投屏失败";
            break;
        default:
            break;
    }
    SGLOG(@"投屏状态 = %@, 原因 = %@", toastStr, reason);
    
    /// 拒绝投屏提示
    if (status == VCSScreenCastingStatusRefuse && !kStringIsEmpty(reason)) {
        [FWToastBridge showToastAction:reason];
    }
    
    /// 投屏失败提示
    if (status == VCSScreenCastingStatusFailed) {
        [FWToastBridge showToastAction:@"投屏失败，请陪后重试"];
    }
}

#pragma mark 发送状态信息回调
/// 发送状态信息回调
/// @param screenCasting 投屏实例
/// @param sendModel 发送状态数据
- (void)screenCasting:(VCSScreenCasting *)screenCasting onSendStreamModel:(VCSStreamSendModel *)sendModel {
    
    /// 发送信息通知回调
    if (self.sendBlock) {
        self.sendBlock([sendModel yy_modelToJSONString]);
    }
}

#pragma mark 当前服务延时回调
/// 当前服务延时回调
/// @param screenCasting 投屏实例
/// @param timestamp 服务延时
- (void)screenCasting:(VCSScreenCasting *)screenCasting onSignalingDelayed:(NSInteger)timestamp {
    
    /// 发送延时通知回调
    if (self.delayedBlock) {
        self.delayedBlock(timestamp);
    }
}

#pragma mark - 投屏状态通知回调
/// 投屏状态通知回调
/// @param screenStatusBlock 投屏状态通知回调
- (void)screenStatusBlock:(FWCastingBridgeScreenStatusBlock)screenStatusBlock {
    
    self.screenStatusBlock = screenStatusBlock;
}

#pragma mark - 发送延时通知回调
/// 发送延时通知回调
/// @param delayedBlock 发送延时通知回调
- (void)delayedBlock:(FWCastingBridgeDelayedBlock)delayedBlock {
    
    self.delayedBlock = delayedBlock;
}

#pragma mark - 发送信息通知回调
/// 发送信息通知回调
/// @param sendBlock 发送信息通知回调
- (void)sendBlock:(FWCastingBridgeSendBlock)sendBlock {
    
    self.sendBlock = sendBlock;
}

@end
