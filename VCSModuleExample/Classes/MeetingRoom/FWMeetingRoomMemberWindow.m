//
//  FWMeetingRoomMemberWindow.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/11.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingRoomMemberWindow.h"
#import "FWMeetingRoomMemberStatusView.h"

@interface FWMeetingRoomMemberWindow() <UIGestureRecognizerDelegate>

/// 视图容器
@property (strong, nonatomic) UIView *contentView;
/// 播放器窗口
@property (weak, nonatomic) IBOutlet UIView *playerView;
/// 成员状态组件
@property (weak, nonatomic) IBOutlet FWMeetingRoomMemberStatusView *statusView;

/// 是否是自己
@property (nonatomic, assign) BOOL isSelf;

@end

@implementation FWMeetingRoomMemberWindow

#pragma mark - 初始化视图
/// 初始化视图
- (instancetype)init:(BOOL)isSelf {

    self = [super init];
    if (self) {
        /// 配置属性
        [self setupConfig:isSelf];
    }
    return self;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame isSelf:(BOOL)isSelf {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self setupConfig:isSelf];
    }
    return self;
}

#pragma mark - 配置属性
- (void)setupConfig:(BOOL)isSelf {
    
    /// 保存该窗口是否为自己
    self.isSelf = isSelf;
    /// 关联是否为自己
    self.statusView.isSelf = isSelf;
    /// 创建采集实例
    if (isSelf) {
        /// 设置视频采集参数
        [[VCSVideoCapture sharedInstance] setVideoCaptureParam:[VCSCaptureParam defaultConfig]];
        /// 开启本地摄像头的预览画面
        [[VCSVideoCapture sharedInstance] startLocalPreview:YES view:self.playerView];
    }
    /// 添加视图手势
    [self appendRecognizer];
}

#pragma mark - 添加视图手势
/// 添加视图手势
- (void)appendRecognizer {
    
    /// 添加视图手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
    gestureRecognizer.delegate = self;
    [self addGestureRecognizer:gestureRecognizer];
}

#pragma mark - 视图手势事件处理
/// 视图手势事件处理
- (void)handleGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    /// 回调上层成员选择
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowView:didSelectItemAccount:)]) {
        [self.delegate windowView:self didSelectItemAccount:self.account];
    }
}

#pragma mark - 设置成员信息
/// 设置成员信息
/// @param account 成员信息
- (void)setAccount:(nullable Account *)account {
    
    if (!account) {
        return;
    }
    /// 保存成员信息
    _account = account;
    /// 关联成员信息
    self.statusView.account = account;
}

#pragma mark - 设置订阅流类型
/// 设置订阅流类型
/// @param streamType 订阅流类型
- (void)setStreamType:(FWStreamType)streamType {
    
    /// 取消订阅轨道
    if (streamType == FWStreamTypeNormal) {
        VCSTrackIdentifierFlags flags = VCSTrackIdentifierFlags0;
        switch (self.streamType) {
            case FWStreamTypeMain:
                flags = VCSTrackIdentifierFlags1;
                break;
            case FWStreamTypeSub:
                flags = VCSTrackIdentifierFlags0;
                break;
            case FWStreamTypeScreen:
                flags = VCSTrackIdentifierFlags2;
                break;
            default:
                break;
        }
        /// 取消订阅远端用户的视频流
        [[FWRemoteSession sharedInstance] stopRemoteView:self.account.streamId trackId:flags];
        /// 保存订阅流类型
        _streamType = streamType;
        /// 关联订阅流类型
        self.statusView.streamType = streamType;
    } else {
        /// 保存订阅流类型
        _streamType = streamType;
        /// 关联订阅流类型
        self.statusView.streamType = streamType;
        VCSTrackIdentifierFlags flags = VCSTrackIdentifierFlags0;
        switch (streamType) {
            case FWStreamTypeMain:
                flags = VCSTrackIdentifierFlags1;
                break;
            case FWStreamTypeSub:
                flags = VCSTrackIdentifierFlags0;
                break;
            case FWStreamTypeScreen:
                flags = VCSTrackIdentifierFlags2;
                break;
            default:
                break;
        }
        /// 订阅远端用户的视频流
        [[FWRemoteSession sharedInstance] startRemoteView:self.account.streamId trackId:flags view:self.playerView];
    }
}


#pragma mark ------- UIGestureRecognizerDelegate代理实现 -------
#pragma mark 保证允许同时识别手势
/// 保证允许同时识别手势
/// - Parameters:
///   - gestureRecognizer: 手势识别器
///   - otherGestureRecognizer: 其它手势识别器
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
