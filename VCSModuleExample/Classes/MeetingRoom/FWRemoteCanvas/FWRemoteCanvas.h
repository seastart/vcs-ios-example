//
//  FWRemoteCanvas.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - FWRemoteCanvas
@interface FWRemoteCanvas : NSObject

/// 用户标识
@property (nonatomic, assign, readonly) int streamId;
/// 轨道标识
@property (nonatomic, assign, readonly) VCSTrackIdentifierFlags trackId;

#pragma mark 订阅远端用户的视频流
/// 订阅远端用户的视频流
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
/// @param view 承载视频画面的控件
- (void)startRemoteView:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId view:(VIEW_CLASS *)view;

#pragma mark 更新远端用户的视频流
/// 更新远端用户的视频流
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
/// @param view 承载视频画面的控件
- (void)updateRemoteView:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId view:(VIEW_CLASS *)view;

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
- (void)remoteStreamDataStreamId:(int)streamId stamp:(int)stamp trackId:(VCSTrackIdentifierFlags)trackId type:(int)type angle:(int)angle width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData;

#pragma mark 资源销毁
/// 资源销毁
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
