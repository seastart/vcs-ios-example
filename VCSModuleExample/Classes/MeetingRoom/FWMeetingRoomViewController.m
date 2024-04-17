//
//  FWMeetingRoomViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/11.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingRoomViewController.h"
#import "FWMeetingRoomMemberView.h"
#import "FWMeetingRoomModel.h"

@interface FWMeetingRoomViewController () <VCSVideoCaptureDelegate, VCSStreamMediaDelegate, VCSScreenRecordServerDelegate, VCSMeetControlDelegate, FWMeetingRoomMemberViewDelegate>

/// 挂断按钮
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;
/// 扬声器按钮
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
/// 摄像头按钮
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
/// 房间号码
@property (weak, nonatomic) IBOutlet UILabel *roomnoLabel;
/// 成员列表视图
@property (weak, nonatomic) IBOutlet FWMeetingRoomMemberView *roomMemberView;
/// 音频控制按钮
@property (weak, nonatomic) IBOutlet UIButton *audioButton;
/// 音频控制按钮图标
@property (weak, nonatomic) IBOutlet UIButton *audioButtonImage;
/// 音频控制按钮标题
@property (weak, nonatomic) IBOutlet UILabel *audioButtonLable;
/// 视频控制按钮
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
/// 视频控制按钮图标
@property (weak, nonatomic) IBOutlet UIButton *videoButtonImage;
/// 视频控制按钮标题
@property (weak, nonatomic) IBOutlet UILabel *videoButtonLable;
/// 共享按钮
@property (weak, nonatomic) IBOutlet UIButton *sharingButton;
/// 共享按钮图标
@property (weak, nonatomic) IBOutlet UIButton *sharingButtonImage;
/// 共享按钮标题
@property (weak, nonatomic) IBOutlet UILabel *sharingButtonLable;


/// 主码流信息
@property (nonatomic, strong) Stream *streamMain;
/// 辅码流信息
@property (nonatomic, strong) Stream *streamSub;
/// 房间信息
@property (nonatomic, strong) FWMeetingRoomModel *roomModel;

/// 屏幕录制组件
@property (nonatomic, strong) RPSystemBroadcastPickerView *broadcastPickerView;

@end

@implementation FWMeetingRoomViewController

#pragma mark - 创建主码流信息
- (Stream *)streamMain {
    
    if (!_streamMain) {
        _streamMain = [[Stream alloc] init];
        _streamMain.id_p = 2;
        _streamMain.width = 480;
        _streamMain.height = 640;
        _streamMain.bitrate = 900;
        _streamMain.fps = 25;
        _streamMain.type = StreamType_StreamMain;
        _streamMain.name = @"主码流信息";
        _streamMain.angle = 0x434d4130;
        _streamMain.codec = Codec_CodecH264;
        _streamMain.channel = 1;
        _streamMain.channelType = ChannelType_CtDefault;
    }
    return _streamMain;
}

#pragma mark - 创建辅码流信息
- (Stream *)streamSub {
    
    if (!_streamSub) {
        _streamSub = [[Stream alloc] init];
        _streamSub.id_p = 1;
        _streamSub.width = 320;
        _streamSub.height = 180;
        _streamSub.bitrate = 128;
        _streamSub.fps = 15;
        _streamSub.type = StreamType_StreamSub;
        _streamSub.name = @"子码流信息";
        _streamSub.angle = 0x434d4130;
        _streamSub.codec = Codec_CodecH264;
        _streamSub.channel = 1;
        _streamSub.channelType = ChannelType_CtDefault;
    }
    return _streamSub;
}

#pragma mark - 创建屏幕录制组件
/// 创建屏幕录制组件
- (RPSystemBroadcastPickerView *)broadcastPickerView API_AVAILABLE(ios(12.0)) {
    
    if (!_broadcastPickerView) {
        _broadcastPickerView = [[RPSystemBroadcastPickerView alloc] init];
        _broadcastPickerView.preferredExtension = @"cn.seastart.vcsmodule.replayBroadcastUpload";
        _broadcastPickerView.showsMicrophoneButton = NO;
        _broadcastPickerView.hidden = YES;
    }
    return _broadcastPickerView;
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    /// 更改状态栏颜色为白色
    [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleLightContent];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    /// 更改状态栏颜色为黑色
    [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleDefault];
    /// 隐藏顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 绑定动态响应信号
    [self bindSignal];
    /// 初始化会控组件
    [self initializeMeetControl:self.info];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定挂断按钮事件
    [[self.hangupButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 挂断事件处理
        [self onHangupEvent];
    }];
    
    /// 绑定扬声器按钮事件
    [[self.speakerButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 摄像头按钮事件
        [self handleSelectSpeakerButton:control];
    }];
    
    /// 绑定摄像头按钮事件
    [[self.cameraButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 扬声器按钮事件
        [self handleSelectCameraButton:control];
    }];
    
    /// 监听订阅音频控制按钮选择状态
    [RACObserve(self.audioButton, selected) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        if (value.boolValue) {
            /// 音频按钮选中
            [self.audioButtonImage setImage:kGetImage(@"icon_room_audio_un") forState:UIControlStateNormal];
            [self.audioButtonLable setText:@"解除静音"];
        } else {
            /// 音频按钮未选中
            [self.audioButtonImage setImage:kGetImage(@"icon_room_audio") forState:UIControlStateNormal];
            [self.audioButtonLable setText:@"静音"];
        }
    }];
    
    /// 监听订阅视频控制按钮选择状态
    [RACObserve(self.videoButton, selected) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        if (value.boolValue) {
            /// 视频按钮选中
            [self.videoButtonImage setImage:kGetImage(@"icon_room_video_un") forState:UIControlStateNormal];
            [self.videoButtonLable setText:NSLocalizedString(@"开启视频", nil)];
        } else {
            /// 视频按钮未选中
            [self.videoButtonImage setImage:kGetImage(@"icon_room_video") forState:UIControlStateNormal];
            [self.videoButtonLable setText:NSLocalizedString(@"关闭视频", nil)];
        }
    }];
    
    /// 监听订阅共享按钮选择状态
    [RACObserve(self.sharingButton, selected) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        if (value.boolValue) {
            /// 共享按钮选中
            [self.sharingButtonImage setImage:kGetImage(@"icon_room_share_un") forState:UIControlStateNormal];
            [self.sharingButtonLable setText:NSLocalizedString(@"停止共享", nil)];
        } else {
            /// 共享按钮未选中
            [self.sharingButtonImage setImage:kGetImage(@"icon_room_share") forState:UIControlStateNormal];
            [self.sharingButtonLable setText:NSLocalizedString(@"共享屏幕", nil)];
        }
    }];
    
    /// 绑定音频控制按钮事件
    [[self.audioButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 音频发送按钮事件
        [self handleSelectAudioButton:control];
    }];
    
    /// 绑定视频控制按钮事件
    [[self.videoButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 视频发送按钮事件
        [self handleSelectVideoButton:control];
    }];
    
    /// 绑定共享按钮事件
    [[self.sharingButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 共享按钮事件
        [self handleSelectSharingButton:control];
    }];
}

#pragma mark - 显示屏幕采集选择器视图
/// 显示屏幕采集选择器视图
- (void)showBroadcastPicker {
    
    /// 将事件传递给开启录制按钮
    for (UIView *view in self.broadcastPickerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view sendActionsForControlEvents:UIControlEventTouchDown | UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - 初始化会控组件
/// 初始化会控组件
/// - Parameter roomModel: 房间信息
- (void)initializeMeetControl:(FWMeetingRoomModel *)roomModel {
    
    /// 设置房间号码
    [self.roomnoLabel setText:roomModel.data.room.no];
    /// 保存房间信息
    self.roomModel = roomModel;
    /// 创建会控参数
    VCSMeetControlParam *controlParam = [[VCSMeetControlParam alloc] init];
    controlParam.session = roomModel.data.session;
    controlParam.roomId = roomModel.data.room.id;
    controlParam.roomSdkNo = roomModel.data.room.sdk_no;
    controlParam.accountId = roomModel.loginModel.data.account.id;
    controlParam.accountSdkNo = [roomModel.loginModel.data.account.room.sdk_no intValue];
    controlParam.name = roomModel.loginModel.data.account.name;
    controlParam.mobile = roomModel.loginModel.data.account.mobile;
    controlParam.nickname = roomModel.loginModel.data.account.nickname;
    controlParam.portrait = roomModel.loginModel.data.account.portrait;
    controlParam.audioState = self.roomModel.controlModel.audioState ? DeviceState_DsActive : DeviceState_DsClosed;
    controlParam.videoState = self.roomModel.controlModel.videoState ? DeviceState_DsActive : DeviceState_DsClosed;;
    controlParam.streamMain = self.streamMain;
    controlParam.streamSub = self.streamSub;
    controlParam.serverId = roomModel.data.meeting_server_id;
    /// 初始化会控组件
    [[VCSMeetControl sharedInstance] initializeWithControlParam:controlParam delegate:self];
    /// 初始化流媒体
    [self initializeStreamMedia];
}

#pragma mark - 初始化流媒体
/// 初始化流媒体
- (void)initializeStreamMedia {
    
    /// 开启屏幕录制并设置回调代理
    [[VCSScreenRecordServer sharedInstance] startScreenRecordWithAppGroup:FWAPPGROUP isCasting:NO encoderWidth:720 encoderHeight:1280 framerate:15 delegate:self];
    
    /// 设置采集回调代理
    [VCSVideoCapture sharedInstance].delegate = self;
    
    /// 创建流媒体配置
    VCSMediaConfig *mediaConfig = [[VCSMediaConfig alloc] init];
    mediaConfig.streamHost = self.roomModel.data.stream_host;
    mediaConfig.streamPort = (int)self.roomModel.data.stream_port;
    mediaConfig.roomSdkNo = [self.roomModel.data.room.sdk_no intValue];
    mediaConfig.streamId = [self.roomModel.loginModel.data.account.room.sdk_no intValue];
    mediaConfig.sessionKey = self.roomModel.data.session;
    
    /// 创建调试参数
    VCSDebugParam *debugParam = [VCSDebugParam defaultConfig];
    if (!kStringIsEmpty(self.roomModel.controlModel.debugText)) {
        /// 设置调试地址
        debugParam.debugHost = self.roomModel.controlModel.debugText;
    }
    /// 设置调试参数
    [[VCSStreamMedia sharedInstance] setRemoteDebugParam:debugParam];
    /// 初始化流媒体
    [[VCSStreamMedia sharedInstance] initializeWithMediaConfig:mediaConfig delegate:self];
    
    /// 设置音频按钮选中状态
    [self setupAudioButtonSelected:!self.roomModel.controlModel.audioState];
    /// 设置视频按钮选中状态
    [self setupVideoButtonSelected:!self.roomModel.controlModel.videoState];
}

#pragma mark - 挂断事件处理
/// 挂断事件处理
- (void)onHangupEvent {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定离开房间吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *leaveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 离开房间
        [self leaveRoom];
    }];
    [alert addAction:cancelAction];
    [alert addAction:leaveAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 离开房间
/// 离开房间
- (void)leaveRoom {
    
    @weakify(self);
    /// 显示加载
    [FWToastBridge showToastAction];
    /// 构建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.roomModel.data.room.no forKey:@"room_no"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWUSEREXITROOMINTERFACE params:params className:@"FWBaseModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        /// 销毁会控组件资源
        [[VCSMeetControl sharedInstance] destroy:^{
            /// 销毁媒体组件资源
            [[VCSStreamMedia sharedInstance] destroy:^{
                /// 销毁屏幕录制资源
                [[VCSScreenRecordServer sharedInstance] destroy];
                /// 清空缓存数据
                [[FWRemoteSession sharedInstance] cleanData];
                /// 销毁采集资源
                [[VCSVideoCapture sharedInstance] destroy];
                /// 声明弱引用
                @strongify(self);
                /// 隐藏加载
                [FWToastBridge hiddenToastAction];
                /// 离开房间视图
                [self pop:1];
            }];
        }];
    }];
}

#pragma mark - 摄像头按钮事件
/// 扬声器按钮事件
/// - Parameter source: 事件源
- (void)handleSelectSpeakerButton:(UIButton *)source {
    
    /// 切换摄像头
    [[VCSVideoCapture sharedInstance] switchCamera];
}

#pragma mark - 扬声器按钮事件
/// 摄像头按钮事件
/// - Parameter source: 事件源
- (void)handleSelectCameraButton:(UIButton *)source {
    
    /// 切换源按钮选中状态
    source.selected = !source.selected;
    /// 设置扬声器状态
    [[VCSStreamMedia sharedInstance] enabledAudioSpeaker:!source.selected];
}

#pragma mark - 音频发送按钮事件
/// 音频发送按钮事件
/// - Parameter source: 事件源
- (void)handleSelectAudioButton:(UIButton *)source {
    
    @weakify(self);
    /// 检测麦克风权限
    [FWToolBridge requestAuthorization:FWPermissionsStateAudio superVC:[FWEntryBridge sharedManager].appDelegate.window.rootViewController result:^(BOOL status) {
        if (status) {
            /// 声明弱引用
            @strongify(self);
            /// 切换源按钮选中状态
            source.selected = !source.selected;
            /// 获取音频发送状态
            BOOL audioState = !source.selected;
            /// 设置音频状态
            [[VCSMeetControl sharedInstance] enableSendAudio:audioState ? DeviceState_DsActive : DeviceState_DsClosed];
            /// 设置音频发送状态
            [[VCSStreamMedia sharedInstance] enabledSendAudio:audioState];
            /// 更新自己的状态信息
            [self.roomMemberView memberUpdateWithAccount:[VCSMeetControl sharedInstance].account isSelf:YES];
        }
    }];
}

#pragma mark - 视频发送按钮事件
/// 视频发送按钮事件
/// - Parameter source: 事件源
- (void)handleSelectVideoButton:(UIButton *)source {
    
    @weakify(self);
    /// 检测摄像头权限
    [FWToolBridge requestAuthorization:FWPermissionsStateVideo superVC:[FWEntryBridge sharedManager].appDelegate.window.rootViewController result:^(BOOL status) {
        if (status) {
            /// 声明弱引用
            @strongify(self);
            /// 切换源按钮选中状态
            source.selected = !source.selected;
            /// 获取视频发送状态
            BOOL videoState = !source.selected;
            /// 设置视频状态
            [[VCSMeetControl sharedInstance] enableSendVideo:videoState ? DeviceState_DsActive : DeviceState_DsClosed];
            /// 设置视频发送状态
            [[VCSStreamMedia sharedInstance] enabledPublish:videoState];
            /// 更新自己的状态信息
            [self.roomMemberView memberUpdateWithAccount:[VCSMeetControl sharedInstance].account isSelf:YES];
        }
    }];
}

#pragma mark - 共享按钮事件
/// 共享按钮事件
/// - Parameter source: 事件源
- (void)handleSelectSharingButton:(UIButton *)source {
    
    /// 显示选择器视图
    [self showBroadcastPicker];
}

#pragma mark - 设置音频按钮选中状态
/// 设置音频按钮选中状态
/// @param selected 选中状态
- (void)setupAudioButtonSelected:(BOOL)selected {
    
    FWDispatchAscyncOnMainQueue(^{
        self.audioButton.selected = selected;
    });
}

#pragma mark - 设置视频按钮选中状态
/// 设置视频按钮选中状态
/// @param selected 选中状态
- (void)setupVideoButtonSelected:(BOOL)selected {
    
    FWDispatchAscyncOnMainQueue(^{
        self.videoButton.selected = selected;
    });
}

#pragma mark - 设置共享按钮选中状态
/// 设置共享按钮选中状态
/// @param selected 选中状态
- (void)setupShareButtonSelected:(BOOL)selected {
    
    FWDispatchAscyncOnMainQueue(^{
        self.sharingButton.selected = selected;
    });
}


#pragma mark - ------ FWMeetingRoomMemberViewDelegate 代理方法 ------
#pragma mark 成员选择回调
/// 成员选择回调
/// @param memberView 成员列表对象
/// @param account 成员信息
- (void)memberView:(FWMeetingRoomMemberView *)memberView didSelectItemAccount:(Account *)account {
    
    if ([account.id_p isEqualToString:self.roomModel.loginModel.data.account.id]) {
        /// 选择成员为当前用户，丢弃该事件处理
        return;
    }
    /// 创建对话框标题
    NSString *title = [NSString stringWithFormat:@"%@ 所有发送流类型", [account.nickname nicknameSuitScanf]];
    
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    
    for (Stream *stream in account.streamsArray) {
        /// 显示视频类型的轨道列表
        NSString *title = @"未知流";
        /// 添加轨道列表
        switch (stream.channelType) {
            case ChannelType_CtDefault: {
                /// 视频流
                if (stream.type == StreamType_StreamMain) {
                    /// 主码流
                    title = [NSString stringWithFormat:@"主码流(%d)", stream.id_p];
                } else {
                    /// 子码流
                    title = [NSString stringWithFormat:@"子码流(%d)", stream.id_p];
                }
            }
                break;
            case ChannelType_CtScreen: {
                /// 共享流
                title = [NSString stringWithFormat:@"共享流(%d)", stream.id_p];
            }
                break;
            default:
                break;
        }
        UIAlertAction *trackAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            @strongify(self);
            /// 声明订阅流类型
            FWStreamType streamType = FWStreamTypeNormal;
            /// 判断需要订阅的流类型
            if ([title containsString:@"主码流"]) {
                streamType = FWStreamTypeMain;
            } else if ([title containsString:@"子码流"]) {
                streamType = FWStreamTypeSub;
            } else if ([title containsString:@"共享流"]) {
                streamType = FWStreamTypeScreen;
            }
            /// 订阅成员视频流
            [self.roomMemberView subscribeWithAccount:account streamType:streamType];
        }];
        [alert addAction:trackAction];
    }
    
    UIAlertAction *emptyAction = [UIAlertAction actionWithTitle:@"取消订阅流" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 取消订阅成员视频流
        [self.roomMemberView subscribeWithAccount:account streamType:FWStreamTypeNormal];
    }];
    [alert addAction:emptyAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - ------ VCSVideoCaptureDelegate 代理方法 ------
#pragma mark 视频采集数据回调
/// 视频采集数据回调
/// @param capture 采集实例
/// @param pixelBuffer 像素数据
/// @param stamp 时间戳
/// @param frontCamera 是否为前置摄像头
/// @param viewChange 视图是否发生变化
- (void)videoCapture:(VCSVideoCapture *)capture pixelBuffer:(CVPixelBufferRef)pixelBuffer stamp:(CMTime)stamp frontCamera:(BOOL)frontCamera viewChange:(int)viewChange {
    
    /// 渲染CVPixelBufferRef数据
    [[VCSVideoCapture sharedInstance] displayCVPixleBuffer:pixelBuffer];
    /// 发布视频数据流
    [[VCSStreamMedia sharedInstance] publishVideoWithSampleBuffer:pixelBuffer stamp:stamp frontCamera:frontCamera viewChange:viewChange];
}


#pragma mark - ------ VCSScreenRecordServerDelegate 代理方法 ------
#pragma mark 屏幕录制编码后数据回调
/// 屏幕录制编码后数据回调
/// @param server 服务端实例
/// @param streamData 共享流数据
/// @param pts 显示时间戳
/// @param dts 解码时间戳
/// @param angle 显示角度
/// @param keyframe 是否为关键帧
- (void)screenServer:(VCSScreenRecordServer *)server didStreamData:(NSData *)streamData pts:(uint32_t)pts dts:(uint32_t)dts angle:(int)angle keyframe:(BOOL)keyframe {
    
    /// 发布屏幕共享流
    [[VCSStreamMedia sharedInstance] publishScreenEncoderWithStreamData:streamData stamp:pts dts:dts displayAngle:angle];
}

#pragma mark 屏幕录制音频原始数据回调
/// 屏幕录制音频原始数据回调
/// @param server 服务端实例
/// @param streamData 共享音频数据
/// @param pts 显示时间戳
/// @param dts 解码时间戳
- (void)screenServer:(VCSScreenRecordServer *)server didAudioStreamData:(NSData *)streamData pts:(uint32_t)pts dts:(uint32_t)dts {
    
    
}

#pragma mark 屏幕录制实时帧率回调
/// 屏幕录制实时帧率回调
/// @param server 服务端实例
/// @param framerate 当前帧率
/// @param bitrate 当前码率
/// @param height 当前分辨率
/// @param width 当前分辨率
- (void)screenServer:(VCSScreenRecordServer *)server didChangeFramerate:(int)framerate bitrate:(int)bitrate height:(int)height width:(int)width {
    
    
}

#pragma mark 屏幕录制状态码回调
/// 投屏状态码回调
/// @param server 服务端实例
/// @param status 屏幕录制状态
- (void)screenServer:(VCSScreenRecordServer *)server didProcessStatus:(VCSScreenRecordStatus)status {
    
    /// 根据本地屏幕采集状态通知会控共享状态
    if (status == VCSScreenRecordStatusStart) {
        /// 开启屏幕共享
        [[VCSMeetControl sharedInstance] startRoomStartToShareWithSharingType:SharingType_StDesktop sharingPicURL:nil sharingRelativePicURL:nil];
    } else {
        /// 结束屏幕共享
        [[VCSMeetControl sharedInstance] stopRoomStopSharing];
    }
    /// 设置共享按钮选中状态
    [self setupShareButtonSelected:(status == VCSScreenRecordStatusStart)];
}


#pragma mark - ------ VCSStreamMediaDelegate 代理方法 ------
#pragma mark 流媒体连接成功回调
/// 流媒体连接成功回调
/// @param stream 流媒体组件实例
/// @param finish 完成状态
- (void)streamMedia:(VCSStreamMedia *)stream didConnectionFinish:(BOOL)finish {
    
    /// 日志埋点
    SGLOG(@"流媒体连接成功");
    /// 获取音频状态
    BOOL audioState = self.roomModel.controlModel.audioState;
    /// 获取视频状态
    BOOL videoState = self.roomModel.controlModel.videoState;
    /// 设置音频路由
    [[VCSStreamMedia sharedInstance] setAudioRoute:VCSAudioRouteSpeaker];
    /// 检测摄像头权限
    [FWToolBridge requestAuthorization:FWPermissionsStateVideo superVC:[FWEntryBridge sharedManager].appDelegate.window.rootViewController result:^(BOOL status) {
        /// 设置推流状态
        [[VCSStreamMedia sharedInstance] enabledPublish:videoState];
        /// 检测麦克风权限
        [FWToolBridge requestAuthorization:FWPermissionsStateAudio superVC:[FWEntryBridge sharedManager].appDelegate.window.rootViewController result:^(BOOL status) {
            /// 设置音频发送状态
            [[VCSStreamMedia sharedInstance] enabledSendAudio:audioState];
        }];
    }];
}

#pragma mark 流媒体重连完成回调
/// 流媒体重连完成回调
/// @param stream 流媒体组件实例
/// @param finish 完成状态
- (void)streamMedia:(VCSStreamMedia *)stream didReconnectionFinish:(BOOL)finish {
    
    /// 重置远程流订阅
    [[FWRemoteSession sharedInstance] resetRemoteStream];
}

#pragma mark 应用性能使用情况回调
/// 应用性能使用情况回调
/// @param stream 流媒体组件实例
/// @param memory 内存占用
/// @param cpuUsage CUP使用率
- (void)streamMedia:(VCSStreamMedia *)stream onApplicationPerformance:(double)memory cpuUsage:(double)cpuUsage {
    
    
}

#pragma mark 视频方向变化回调
/// 视频方向变化回调
/// @param stream 流媒体组件实例
/// @param track 视频轨道
/// @param angle 视频角度
- (void)streamMedia:(VCSStreamMedia *)stream didVideoOrientationChange:(VCSTrackIdentifierFlags)track angle:(int)angle {
    
    
}

#pragma mark 远程成员音频状态回调
/// 远程成员音频状态回调
/// @param stream 流媒体组件实例
/// @param audioArray 成员音频列表
- (void)streamMedia:(VCSStreamMedia *)stream onRemoteMemberAudioStatus:(NSArray<VCSStreamAudioModel *> *)audioArray {
    
    
}

#pragma mark 服务是否允许发言
/// 服务是否允许发言
/// @param stream 流媒体组件实例
/// @param enabled 是否允许发言，YES-允许发言 NO-不允许发言
- (void)streamMedia:(VCSStreamMedia *)stream onServiceEnabledSpeak:(BOOL)enabled {
    
    
}

#pragma mark 远程流数据回调
/// 远程流数据回调
/// @param stream 流媒体组件实例
/// @param streamId 远程成员标识
/// @param stamp 视频时间戳
/// @param track 视频轨道
/// @param type 视频存储格式
/// @param angle 视频角度
/// @param width 视频宽
/// @param height 视频高
/// @param yData 像素数据
/// @param uData 像素数据
/// @param vData 像素数据
- (void)streamMedia:(VCSStreamMedia *)stream didRemoteStreamDataStreamId:(int)streamId stamp:(int)stamp track:(int)track type:(int)type angle:(int)angle width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData {
    
    /// 渲染远程流数据
    [[FWRemoteSession sharedInstance] remoteStreamDataStreamId:streamId stamp:stamp trackId:(VCSTrackIdentifierFlags)track type:type angle:angle width:width height:height yData:yData uData:uData vData:vData];
}

#pragma mark 下行码率自适应状态回调
/// 下行码率自适应状态回调
/// @param stream 流媒体组件实例
/// @param streamId 远程成员标识
/// @param state 下行码率自适应状态
- (void)streamMedia:(VCSStreamMedia *)stream onDownBitrateAdaptiveStreamId:(int)streamId state:(VCSDownBitrateAdaptiveState)state {
    
    
}

#pragma mark 上行码率自适应状态回调
/// 上行码率自适应状态回调
/// @param stream 流媒体组件实例
/// @param state 上行码率自适应状态
- (void)streamMedia:(VCSStreamMedia *)stream onUploadBitrateAdaptiveState:(VCSUploadBitrateAdaptiveState)state {
    
    
}

#pragma mark 下行平均丢包档位变化回调
/// 下行平均丢包档位变化回调
/// @param stream 流媒体组件实例
/// @param state 下行平均丢包档位
- (void)streamMedia:(VCSStreamMedia *)stream onDownLossLevelChangeState:(VCSDownLossLevelState)state {
    
    
}

#pragma mark 下行平均丢包率回调
/// 下行平均丢包率回调
/// @param stream 流媒体组件实例
/// @param average 下行平均丢包率
- (void)streamMedia:(VCSStreamMedia *)stream onDownLossRateAverage:(CGFloat)average {
    
    
}

#pragma mark 流媒体发送状态数据回调
/// 流媒体发送状态数据回调
/// @param stream 流媒体组件实例
/// @param sendModel 流媒体发送状态数据
- (void)streamMedia:(VCSStreamMedia *)stream onSendStreamModel:(VCSStreamSendModel *)sendModel {
    
    
}

#pragma mark 流媒体接收状态数据回调
/// 流媒体接收状态数据回调
/// @param stream 流媒体组件实例
/// @param receiveModel 流媒体接收状态数据
- (void)streamMedia:(VCSStreamMedia *)stream onReceiveStreamModel:(VCSStreamReceiveModel *)receiveModel {
    
    
}

#pragma mark 音频路由变更回调
/// 音频路由变更回调
/// @param stream 流媒体组件实例
/// @param route 音频路由
/// @param previousRoute 变更前的音频路由
- (void)streamMedia:(VCSStreamMedia *)stream onAudioRouteChanged:(VCSAudioRoute)route previousRoute:(VCSAudioRoute)previousRoute {
    
    /// 埋点日志
    SGLOG(@"当前音频路由 route = %ld，previousRoute = %ld", route, previousRoute);
}


#pragma mark - ------ VCSMeetControlDelegate 代理方法 ------
#pragma mark 重连成功回调
/// 重连成功回调
/// - Parameter meetControl: 会控实例
- (BOOL)onReconnectedSucceed:(VCSMeetControl *)meetControl {
    
    SGLOG(@"会控组件重连成功。");
    return YES;
}

#pragma mark 响应结果回调
/// 响应结果回调
/// - Parameters:
///   - meetControl: 会控实例
///   - command: 指令类型
///   - result: 错误类型
- (void)meetControl:(VCSMeetControl *)meetControl onRespondCommand:(Command)command result:(Result)result {
    
    
}

#pragma mark 房间状态通知
/// 房间状态通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onRoomStateNotify:(RoomNotify *)notify error:(NSError *)error {
    
    SGLOG(@"房间状态通知 %@", notify.room);
}

#pragma mark 成员状态通知
/// 成员状态通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onMemberStateNotify:(AccountNotify *)notify error:(NSError *)error {
    
    /// 更新成员信息
    [self.roomMemberView memberUpdateWithAccount:notify.account isSelf:NO];
}

#pragma mark 踢出房间通知
/// 踢出房间通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onKickoutNotify:(KickoutNotify *)notify error:(NSError *)error {
    
    /// 检测到自己被踢出房间
    if ([self.roomModel.loginModel.data.account.id isEqualToString:notify.accountId]) {
        /// 提示信息
        [FWToastBridge showToastAction:@"您已被踢出房间。"];
        /// 主动离开会议
        [self leaveRoom];
    }
}

#pragma mark 成员进入房间通知
/// 成员进入房间通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onMemberEnterNotify:(EnterNotify *)notify error:(NSError *)error {
    
    /// 更新成员信息
    [self.roomMemberView memberUpdateWithAccount:notify.account isSelf:NO];
}

#pragma mark 成员离开房间通知
/// 成员离开房间通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onMemberLeaveNotify:(ExitNotify *)notify error:(NSError *)error {
    
    /// 成员离开房间
    [self.roomMemberView memberExitWithAccount:notify.account];
}

#pragma mark 会议开始通知
/// 会议开始通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onMeetingBeginNotify:(RoomBeginNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 会议结束通知
/// 会议结束通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onMeetingFinishNotify:(RoomEndedNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 自己状态变化通知
/// 自己状态变化通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
///   - firstNotify: 是否是首次回调进入
- (void)meetControl:(VCSMeetControl *)meetControl onSelfStateNotify:(MyAccountNotify *)notify error:(NSError *)error firstNotify:(BOOL)firstNotify {
    
    /// 更新成员信息
    [self.roomMemberView memberUpdateWithAccount:notify.account isSelf:YES];
}

#pragma mark 码流信息变化通知
/// 码流信息变化通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onChangedStreamNotify:(StreamNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 透传消息通知
/// 透传消息通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onPassthroughNotify:(PassthroughNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 聊天消息通知
/// 聊天消息通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onChatNotify:(ChatNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 举手发言通知
/// 举手发言通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onHandUpNotify:(HandUpNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 主持人操作码流信息通知
/// 主持人操作码流信息通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onAdminChangedStreamNotify:(HostCtrlStreamNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 回收主持人通知
/// 回收主持人通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onAdminRecoveryHostNotify:(RoomRecoveryHostNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 转移主持人通知
/// 转移主持人通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onAdminMoveHostNotify:(RoomMoveHostNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 联席主持人设置通知
/// 联席主持人设置通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onAdminUnionHostNotify:(RoomUnionHostNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 接收聊天通知
/// 接收聊天通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onChatEventNotify:(XChatEvent *)notify error:(NSError *)error {
    
    
}

#pragma mark 云录制状态通知
/// 云录制状态通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onCloudRecordStateNotify:(McuRunStateNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 网络研讨会角色变更通知
/// 网络研讨会角色变更通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onWebinarChangedMemberRoleNotify:(WebinarRoleNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 网络研讨会人数通知
/// 网络研讨会人数通知
/// - Parameters:
///   - meetControl: 会控实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetControl:(VCSMeetControl *)meetControl onWebinarAudienceCountNotify:(WebinarAudienceNumNotify *)notify error:(NSError *)error {
    
    
}

#pragma mark 事件透传通知
/// 事件透传通知
/// - Parameters:
///   - meetControl: 会控实例
///   - event: 事件类型
///   - content: 事件内容
- (void)meetControl:(VCSMeetControl *)meetControl onTransparentEvent:(VCSMeetCommandEvent)event content:(NSString *)content {
    
    
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 取消限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

@end
