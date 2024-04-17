//
//  FWRemoteSession.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRemoteSession.h"
#import "FWRemoteCanvas.h"

@interface FWRemoteSession()

/// 远程画面列表
/// 使用用户标识和轨道标识共同组成索引Key
/// 远程画布对象组成Value
@property (nonatomic, strong) NSMutableDictionary<NSString *, FWRemoteCanvas *> *remoteCanvas;

/// 远程轨道列表
/// 使用用户编号作为索引Key
/// 轨道数组组成Value
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSNumber *> *> *remoteTrackIds;

@end

@implementation FWRemoteSession

#pragma mark - ------------ 引擎管理外部方法 ------------

#pragma mark 获取管理实例
/// 获取管理实例
+ (FWRemoteSession *)sharedInstance {
    
    static FWRemoteSession *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[FWRemoteSession alloc] init];
    });
    return instance;
}

#pragma mark 清空缓存数据
/// 清空缓存数据
- (void)cleanData {
    
    /// 停止订阅所有远端用户的视频流
    [self stopAllRemoteView];
}

#pragma mark 订阅远端用户的视频流
/// 订阅远端用户的视频流
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
/// @param view 承载视频画面的控件
- (void)startRemoteView:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId view:(VIEW_CLASS *)view {
    
    /// 1、更新远程画布列表
    [self updateRemoteCanvas:streamId trackId:trackId view:view];
    /// 2、更新远程轨道列表
    [self updateRemoteTrack:streamId trackId:trackId view:view];
    /// 3、更新远程流订阅
    [self updateRemoteStream:streamId trackId:trackId];
}

#pragma mark 更新远端用户的视频流
/// 更新远端用户的视频流
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
/// @param view 承载视频画面的控件
- (void)updateRemoteView:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId view:(VIEW_CLASS *)view {
    
    /// 1、更新远程画布列表
    [self updateRemoteCanvas:streamId trackId:trackId view:view];
    /// 2、更新远程轨道列表
    [self updateRemoteTrack:streamId trackId:trackId view:view];
    /// 3、更新远程流订阅
    [self updateRemoteStream:streamId trackId:trackId];
}

#pragma mark 停止订阅远端用户的视频流
/// 停止订阅远端用户的视频流
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
- (void)stopRemoteView:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId {
    
    /// 1、移除远程画布
    [self removeRemoteCanvas:streamId trackId:trackId];
    /// 2、移除远程轨道
    [self removeRemoteTrack:streamId trackId:trackId];
    /// 3、更新远程流订阅
    [self updateRemoteStream:streamId trackId:trackId];
}

#pragma mark 停止订阅所有远端用户的视频流
/// 停止订阅所有远端用户的视频流
- (void)stopAllRemoteView {
    
    /// 停止订阅所有远端用户的视频流
    [[VCSStreamMedia sharedInstance] subscribeRemoteStreamWithStreamId:0 state:VCSPickerStateAudioAndVideo];
    
    /// 遍历远程画布列表
    [self.remoteCanvas enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FWRemoteCanvas * _Nonnull obj, BOOL * _Nonnull stop) {
        /// 销毁远程画布资源
        [obj destroy];
    }];
    
    if (_remoteCanvas) {
        /// 清空远程画面列表
        [_remoteCanvas removeAllObjects];
        /// 置空远程画面列表
        _remoteCanvas = nil;
    }
    
    if (_remoteTrackIds) {
        /// 清空远程轨道列表
        [_remoteTrackIds removeAllObjects];
        /// 置空远程轨道列表
        _remoteTrackIds = nil;
    }
}

#pragma mark 重置远程流订阅
/// 重置远程流订阅
- (void)resetRemoteStream {
    
    @synchronized (self.remoteCanvas) {
        WeakSelf();
        [self.remoteCanvas enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FWRemoteCanvas * _Nonnull obj, BOOL * _Nonnull stop) {
            /// 更新远程流订阅
            [weakSelf updateRemoteStream:obj.streamId trackId:obj.trackId];
        }];
    }
}

#pragma mark 渲染远程流数据
/// 渲染远程流数据
/// @param streamId 成员标识
/// @param stamp 视频时间戳
/// @param trackId 视频轨道
/// @param type 视频存储格式
/// @param angle 视频角度
/// @param width 视频宽
/// @param height 视频高
/// @param yData 像素数据
/// @param uData 像素数据
/// @param vData 像素数据
- (void)remoteStreamDataStreamId:(int)streamId stamp:(int)stamp trackId:(VCSTrackIdentifierFlags)trackId type:(int)type angle:(int)angle width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData {
    
    /// 构造远程画布索引键
    NSString *remoteKey = [FWToolBridge formationRemoteCanvasKey:streamId trackId:trackId];
    /// 根据索引键获取远程画布
    FWRemoteCanvas *canvas = [self.remoteCanvas objectForKey:remoteKey];
    
    if (canvas) {
        /// 渲染远程流数据
        [canvas remoteStreamDataStreamId:streamId stamp:stamp trackId:trackId type:type angle:angle width:width height:height yData:yData uData:uData vData:vData];
    }
    
    /// 释放流媒体像素数据资源
    [FWToolBridge destroyStreamWithyData:yData uData:uData vData:vData];
}


#pragma mark - ------------ 引擎管理内部方法 ------------

#pragma mark 创建远程画面列表
/// 创建远程画面列表
- (NSMutableDictionary<NSString *, FWRemoteCanvas *> *)remoteCanvas {
    
    if (!_remoteCanvas) {
        _remoteCanvas = [NSMutableDictionary dictionary];
    }
    return _remoteCanvas;
}

#pragma mark 创建远程轨道列表
/// 创建远程轨道列表
- (NSMutableDictionary<NSString *, NSMutableArray<NSNumber *> *> *)remoteTrackIds {
    
    if (!_remoteTrackIds) {
        _remoteTrackIds = [NSMutableDictionary dictionary];
    }
    return _remoteTrackIds;
}

#pragma mark 更新远程画布列表
/// 更新远程画布列表
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
/// @param view 承载视频画面的控件
- (void)updateRemoteCanvas:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId view:(VIEW_CLASS *)view {
    
    /// 构造远程画布索引键
    NSString *remoteKey = [FWToolBridge formationRemoteCanvasKey:streamId trackId:trackId];
    /// 根据索引键获取远程画布
    FWRemoteCanvas *canvas = [self.remoteCanvas objectForKey:remoteKey];
    /// 该远程画布本地不存在
    if (!canvas) {
        /// 创建远程画布
        canvas = [[FWRemoteCanvas alloc] init];
        /// 订阅远端用户的视频流
        [canvas startRemoteView:streamId trackId:trackId view:view];
    } else {
        /// 更新远端用户的视频流
        [canvas updateRemoteView:streamId trackId:trackId view:view];
    }
    
    /// 更新到远程画布列表
    [self.remoteCanvas setValue:canvas forKey:remoteKey];
}

#pragma mark 更新远程轨道列表
/// 更新远程轨道列表
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
/// @param view 承载视频画面的控件
- (void)updateRemoteTrack:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId view:(VIEW_CLASS *)view {
    
    /// 构建远程轨道索引键
    NSString *remoteKey = [NSString stringWithFormat:@"%d", streamId];
    /// 根据索引键获取该用户关联的轨道列表
    NSMutableArray<NSNumber *> *trackIds = [self.remoteTrackIds objectForKey:remoteKey];
    /// 如果当前轨道列表不为空
    if (!kArrayIsEmpty(trackIds)) {
        /// 声明远程轨道
        __block NSNumber *trackNumber = nil;
        /// 遍历关联的轨道列表，查找对应的轨道
        [trackIds enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj integerValue] == trackId) {
                trackNumber = obj;
                *stop = YES;
            }
        }];
        
        if (!trackNumber) {
            /// 添加对应轨道
            [trackIds addObject:@(trackId)];
        }
    } else {
        /// 创建轨道列表，并添加对应轨道
        trackIds = [NSMutableArray arrayWithObject:@(trackId)];
        /// 添加到轨道列表
        [self.remoteTrackIds setValue:trackIds forKey:remoteKey];
    }
}

#pragma mark 更新远程流订阅
/// 更新远程流订阅
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
- (void)updateRemoteStream:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId {
    
    /// 构建远程轨道索引键
    NSString *remoteKey = [NSString stringWithFormat:@"%d", streamId];
    /// 根据索引键获取该用户关联的轨道列表
    NSMutableArray<NSNumber *> *trackIds = [self.remoteTrackIds objectForKey:remoteKey];
    /// 如果当前轨道列表不为空
    if (!kArrayIsEmpty(trackIds)) {
        /// 1、订阅远程流
        [[VCSStreamMedia sharedInstance] subscribeRemoteStreamWithStreamId:streamId state:VCSPickerStateAudioAndVideo];
        /// 2、订阅远程流轨道
        VCSTrackMaskFlags maskFlags = 0;
        /// 遍历当前轨道列表计算掩码
        for (NSNumber *trackId in trackIds) {
            /// 转换流媒体码流轨道ID
            VCSTrackIdentifierFlags identifierFlags = (VCSTrackIdentifierFlags)[trackId integerValue];
            switch (identifierFlags) {
                case VCSTrackIdentifierFlags0:
                    maskFlags = maskFlags | VCSTrackMaskFlags0;
                    break;
                case VCSTrackIdentifierFlags1:
                    maskFlags = maskFlags | VCSTrackMaskFlags1;
                    break;
                case VCSTrackIdentifierFlags2:
                    maskFlags = maskFlags | VCSTrackMaskFlags2;
                    break;
                case VCSTrackIdentifierFlags3:
                    maskFlags = maskFlags | VCSTrackMaskFlags3;
                    break;
                case VCSTrackIdentifierFlags4:
                    maskFlags = maskFlags | VCSTrackMaskFlags4;
                    break;
                case VCSTrackIdentifierFlags5:
                    maskFlags = maskFlags | VCSTrackMaskFlags5;
                    break;
                case VCSTrackIdentifierFlags6:
                    maskFlags = maskFlags | VCSTrackMaskFlags6;
                    break;
                default:
                    break;
            }
        }
        /// 订阅远程流轨道
        [[VCSStreamMedia sharedInstance] subscribeRemoteStreamTrackWithStreamId:streamId trackMask:(int)maskFlags synchro:YES];
    } else {
        /// 取消订阅远程流
        [[VCSStreamMedia sharedInstance] subscribeRemoteStreamWithStreamId:streamId state:VCSPickerStateClose];
    }
}

#pragma mark 移除远程画布
/// 移除远程画布
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
- (void)removeRemoteCanvas:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId {
    
    /// 构造远程画布索引键
    NSString *remoteKey = [FWToolBridge formationRemoteCanvasKey:streamId trackId:trackId];
    /// 根据索引键获取远程画布
    FWRemoteCanvas *canvas = [self.remoteCanvas objectForKey:remoteKey];
    /// 该远程画布存在本地
    if (canvas) {
        /// 销毁远程画布资源
        [canvas destroy];
    }
    /// 移除远程画布
    [self.remoteCanvas removeObjectForKey:remoteKey];
}

#pragma mark 移除远程轨道
/// 移除远程轨道
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
- (void)removeRemoteTrack:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId {
    
    /// 构建远程轨道索引键
    NSString *remoteKey = [NSString stringWithFormat:@"%d", streamId];
    /// 根据索引键获取该用户关联的轨道列表
    NSMutableArray<NSNumber *> *trackIds = [self.remoteTrackIds objectForKey:remoteKey];
    /// 声明远程轨道
    __block NSNumber *trackNumber = nil;
    /// 遍历关联的轨道列表，查找对应的轨道
    [trackIds enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] == trackId) {
            trackNumber = obj;
            *stop = YES;
        }
    }];
    
    if (trackNumber) {
        /// 移除该轨道
        [trackIds removeObject:trackNumber];
    }
}

@end
