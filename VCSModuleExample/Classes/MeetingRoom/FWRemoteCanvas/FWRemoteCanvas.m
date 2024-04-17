//
//  FWRemoteCanvas.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRemoteCanvas.h"

/// KVO监控frame属性名
#define kVCSMonitorRemoteBoundsKeyPathName @"bounds"

@interface FWRemoteCanvas()

/// 用户标识
@property (nonatomic, assign, readwrite) int streamId;
/// 轨道标识
@property (nonatomic, assign, readwrite) VCSTrackIdentifierFlags trackId;

/// 视频渲染实例
@property (nonatomic, strong) RTYUVPlayer *playerView;
/// 承载视频画面的控件
@property (nonatomic, strong) VIEW_CLASS *remotePreview;

/// 记录当前控件区域
@property (nonatomic, assign) CGRect bounds;

@end

@implementation FWRemoteCanvas

#pragma mark - ------------ 远程画布外部方法 ------------
#pragma mark 订阅远端用户的视频流
/// 订阅远端用户的视频流
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
/// @param view 承载视频画面的控件
- (void)startRemoteView:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId view:(VIEW_CLASS *)view {
    
    /// 保存关联的用户标识
    self.streamId = streamId;
    /// 保存关联的轨道标识
    self.trackId = trackId;
    
    /// 重置远程画面
    [self resetRemoteView:view];
}

#pragma mark 更新远端用户的视频流
/// 更新远端用户的视频流
/// @param streamId 指定远端用户标识
/// @param trackId 指定要观看的轨道标识
/// @param view 承载视频画面的控件
- (void)updateRemoteView:(int)streamId trackId:(VCSTrackIdentifierFlags)trackId view:(VIEW_CLASS *)view {
    
    /// 保存关联的用户标识
    self.streamId = streamId;
    /// 保存关联的轨道标识
    self.trackId = trackId;
    
    /// 重置远程画面
    [self resetRemoteView:view];
    /// 重置视频渲染实例布局
    [self resetPreviewBounds:view.bounds];
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
    
    /// 当前应用处于非活跃状态
    if (![FWToolBridge applicationActive]) {
        /// 释放流媒体像素数据资源
        [FWToolBridge destroyStreamWithyData:yData uData:uData vData:vData];
        /// 应用处于非活跃状态 ，丢弃此次渲染
        return;
    }
    
    /// 该帧远程流不属于该成员
    if (self.streamId != streamId) {
        /// 释放流媒体像素数据资源
        [FWToolBridge destroyStreamWithyData:yData uData:uData vData:vData];
        /// 该帧远程流不属于该成员，丢弃此次渲染
        return;
    }
    
    /// 渲染远程流数据帧
    int result = [_playerView displayYUVData:streamId type:type lable:angle width:width height:height yData:yData uData:uData vData:vData];
    /// 如果返回值小于0，表示此次渲染失败
    if (result != 0) {
        /// 视频渲染远程流失败埋点
        SGLOG(@"渲染远程YUV数据(FWRemoteCanvas remoteStreamDataStreamId:)，渲染失败 streamId = %d, result = %d", streamId, result);
    }
}

#pragma mark 资源销毁
/// 资源销毁
- (void)destroy {
    
    /// 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    /// 移除监听
    [_remotePreview removeObserver:self forKeyPath:kVCSMonitorRemoteBoundsKeyPathName];
    
    /// 释放视频渲染实例
    if (_playerView) {
        [_playerView cleanpixels];
        [_playerView removeFromSuperview];
        [_playerView ReleasePlay];
        _playerView = nil;
    }
}


#pragma mark - ------------ 远程画布内部方法 ------------
#pragma mark 对象初始化
/// 对象初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark 懒加载视频渲染实例
/// 懒加载视频渲染实例
- (RTYUVPlayer *)playerView {
    
    if (!_playerView) {
        _playerView = [[RTYUVPlayer alloc] initWithFrame:self.remotePreview.bounds];
        /// 设置背景颜色
        /// _playerView.backgroundColor = kVCSRGBOF(0x696969);
        _playerView.backgroundColor = [UIColor clearColor];
        /// 设置边界裁剪
        _playerView.layer.masksToBounds = YES;
    }
    return _playerView;
}

#pragma mark 承载视频画面的控件frame属性变化回调
/// 承载视频画面的控件frame属性变化回调
/// @param keyPath 观察者属性
/// @param object 监听对象
/// @param change 变更信息
/// @param context 上下文对象
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    /// 视频画面的控件frame属性变化处理
    if ([keyPath isEqualToString:kVCSMonitorRemoteBoundsKeyPathName]) {
        /// 获取监听控件对象
        UIView *preview = (UIView *)object;
        /// 判断控件区域是否发生变化
        if (CGRectEqualToRect(_bounds, preview.bounds)) {
            /// 丢弃此次回调
            return;
        }
        /// 重置视频渲染实例布局
        [self resetPreviewBounds:preview.bounds];
    }
}

#pragma mark 重置视频渲染实例布局
/// 重置视频渲染实例布局
/// @param bounds 控件区域
- (void)resetPreviewBounds:(CGRect)bounds {
    
    /// 记录当前控件区域
    _bounds = bounds;
    /// 重置视频渲染实例布局
    _playerView.frame = bounds;
    /// 重置布局
    [_playerView SetLayoutReset:YES];
}

#pragma mark 重置远程画面
/// 重置远程画面
/// @param view 承载视频画面的控件
- (void)resetRemoteView:(VIEW_CLASS *)view {
    
    /// 移除上次的监听
    [_remotePreview removeObserver:self forKeyPath:kVCSMonitorRemoteBoundsKeyPathName];
    
    /// 缓存承载视频画面的控件
    _remotePreview = view;
    /// KVO监听承载视频画面的控件frame属性变化
    [_remotePreview addObserver:self forKeyPath:kVCSMonitorRemoteBoundsKeyPathName options:NSKeyValueObservingOptionNew context:nil];
    /// 渲染视图添加到承载视频画面的控件
    [_remotePreview addSubview:self.playerView];
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放流媒体远程画布(FWRemoteCanvas dealloc)");
}

@end
