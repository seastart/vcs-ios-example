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

@interface FWMeetingRoomViewController () <VCSMeetControlDelegate, FWMeetingRoomMemberViewDelegate>

/// 挂断按钮
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;
/// 成员列表视图
@property (weak, nonatomic) IBOutlet FWMeetingRoomMemberView *roomMemberView;

/// 主码流信息
@property (nonatomic, strong) Stream *streamMain;
/// 辅码流信息
@property (nonatomic, strong) Stream *streamSub;
/// 房间信息
@property (nonatomic, strong) FWMeetingRoomModel *roomModel;

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

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
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
    /// 进入房间
    [self enterRoom:self.info];
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
}

#pragma mark - 进入房间
/// 进入房间
/// - Parameter roomModel: 房间信息
- (void)enterRoom:(FWMeetingRoomModel *)roomModel {
    
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
    controlParam.audioState = DeviceState_DsClosed;
    controlParam.videoState = DeviceState_DsClosed;
    controlParam.streamMain = self.streamMain;
    controlParam.streamSub = self.streamSub;
    controlParam.serverId = roomModel.data.meeting_server_id;
    /// 初始化会控组件
    [[VCSMeetControl sharedInstance] initializeWithControlParam:controlParam delegate:self];
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
            @strongify(self);
            /// 隐藏加载
            [FWToastBridge hiddenToastAction];
            /// 离开房间视图
            [self.navigationController popViewControllerAnimated:self];
        }];
    }];
}

#pragma mark - ------ FWMeetingRoomMemberViewDelegate 代理方法 ------
#pragma mark 成员选择回调
/// 成员选择回调
/// @param memberView 成员列表对象
/// @param account 成员信息
- (void)memberView:(FWMeetingRoomMemberView *)memberView didSelectItemAccount:(Account *)account {
    
    SGLOG(@"选择了成员 %@", account.id_p);
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
    [self.roomMemberView memberUpdateWithAccount:notify.account];
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
    [self.roomMemberView memberUpdateWithAccount:notify.account];
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
    [self.roomMemberView memberUpdateWithAccount:notify.account];
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

@end
