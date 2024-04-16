//
//  SampleHandler.m
//  VCSReplayBroadcastUpload
//
//  Created by SailorGa on 2022/7/22.
//  Copyright © 2022 SailorGa. All rights reserved.
//

#import "SampleHandler.h"
#import <VCSMediaKit/VCSMediaKit.h>

/// Application Group Identifier
#define kAppGroup @"group.cn.seastart.vcsmodule"

@interface SampleHandler() <VCSScreenRecordClientDelegate>

@end

@implementation SampleHandler

#pragma mark - 启动广播
- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    
    /// User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    [[VCSScreenRecordClient sharedInstance] broadcastStartedWithAppGroup:kAppGroup delegate:self];
}

#pragma mark - 暂停广播
- (void)broadcastPaused {
    
    /// User has requested to pause the broadcast. Samples will stop being delivered.
}

#pragma mark - 恢复广播
- (void)broadcastResumed {
    
    /// User has requested to resume the broadcast. Samples delivery will resume.
}

#pragma mark - 完成广播
- (void)broadcastFinished {
    
    /// User has requested to finish the broadcast.
}

#pragma mark - 媒体数据(音视频)
/// 媒体数据(音视频)
/// - Parameters:
///   - sampleBuffer: 视频或音频帧
///   - sampleBufferType: 媒体类型
- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    /// 媒体数据(音视频)发送
    [[VCSScreenRecordClient sharedInstance] sendSampleBuffer:sampleBuffer withType:sampleBufferType];
}

#pragma mark - ----- VCSScreenRecordClientDelegate -----
#pragma mark 录屏完成回调
/// 录屏完成回调
/// @param client VCSScreenRecordClient实例
/// @param reason 原因描述
- (void)screenClient:(VCSScreenRecordClient *)client didBroadcastFinished:(NSString *)reason {
    
    /// 声明描述
    NSString *describe = @"屏幕录制已结束";
    /// 构建Error信息
    NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : describe}];
    /// 完成屏幕录制
    [self finishBroadcastWithError:error];
}

@end
