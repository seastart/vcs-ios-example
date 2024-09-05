//
//  FWRoomCallViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/10.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRoomCallViewController.h"
#import "FWLoginModel.h"

@interface FWRoomCallViewController () <VCSMeetCallDelegate>

/// 房间标识
@property (weak, nonatomic) IBOutlet UITextField *roomTextField;
/// 账号标识
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
/// 发起邀请
@property (weak, nonatomic) IBOutlet UIButton *inviteConfirmButton;
/// 上报通话状态
@property (weak, nonatomic) IBOutlet UIButton *callStatusButton;
/// 发起呼叫
@property (weak, nonatomic) IBOutlet UIButton *callButton;
/// 取消呼叫
@property (weak, nonatomic) IBOutlet UIButton *callCancelButton;
/// 发送文本消息
@property (weak, nonatomic) IBOutlet UIButton *publishTextButton;
/// 发送图片消息
@property (weak, nonatomic) IBOutlet UIButton *publishImageButton;

/// 呼叫用户信息
@property (strong, nonatomic) WaitingAccount *selfAccount;
/// 呼叫用户信息
@property (strong, nonatomic) WaitingAccount *waitingAccount;
/// 呼叫列表
@property (strong, nonatomic) NSMutableArray *callDataArray;

/// 登录信息
@property (nonatomic, strong) FWLoginModel *loginModel;

@end

@implementation FWRoomCallViewController

#pragma mark - 创建呼叫用户信息
- (WaitingAccount *)waitingAccount {
    
    if (!_waitingAccount) {
        _waitingAccount = [[WaitingAccount alloc] init];
        _waitingAccount.callId = [FWToolBridge getUniqueIdentifier];
        /// 15606946786 - b2a04ab737cd4ea98e8088254ff05066
        /// 15606946788 - bfc5d971f0a1452c8a3935e521a2d550
        /// 15606946788 - fdf64b937faf4f5f9e41a34a39510d76
        _waitingAccount.id_p = @"fdf64b937faf4f5f9e41a34a39510d76";
        _waitingAccount.name = @"15606946788";
        _waitingAccount.nickname = @"15606946788";
        _waitingAccount.portrait = @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png";
        _waitingAccount.roomNo = self.roomTextField.text;
        _waitingAccount.status = InviteStatus_Waiting;
        _waitingAccount.callType = 3;
        _waitingAccount.roomPwd = @"abc@12345";
    }
    return _waitingAccount;
}

#pragma mark - 创建呼叫用户信息
- (WaitingAccount *)selfAccount {
    
    if (!_selfAccount) {
        _selfAccount = [[WaitingAccount alloc] init];
        _selfAccount.callId = [FWToolBridge getUniqueIdentifier];
        /// 15606946786 - b2a04ab737cd4ea98e8088254ff05066
        /// 15606946788 - bfc5d971f0a1452c8a3935e521a2d550
        /// 15606946788 - 60165d81b9df4b5194e9acb97183ee3c
        _selfAccount.id_p = self.loginModel.data.account.id;
        _selfAccount.name = self.loginModel.data.account.name;
        _selfAccount.nickname = self.loginModel.data.account.nickname;
        _selfAccount.portrait = @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png";
        _selfAccount.roomNo = self.roomTextField.text;
        _selfAccount.status = InviteStatus_Waiting;
        _selfAccount.callType = 3;
        _selfAccount.roomPwd = @"abc@12345";
    }
    return _selfAccount;
}

#pragma mark - 创建房间内成员
- (NSMutableArray *)callDataArray {
    
    if (!_callDataArray) {
        _callDataArray = [[NSMutableArray alloc] init];
        [_callDataArray addObject:self.waitingAccount];
    }
    return _callDataArray;
}

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置标题
    self.navigationItem.title = @"呼叫组件";
    /// 获取登录信息
    self.loginModel = (FWLoginModel *)self.info;
    /// 设置默认房间标识
    self.roomTextField.text = @"915606946786";
    /// 设置默认成员标识
    self.accountTextField.text = self.loginModel.data.account.mobile;
    
    /// 创建账号信息
    VCSMeetCallAccount *callAccount = [[VCSMeetCallAccount alloc] init];
    callAccount.accountId = self.loginModel.data.account.id;
    callAccount.name = self.loginModel.data.account.name;
    callAccount.nickname = self.loginModel.data.account.nickname;
    callAccount.portrait = self.loginModel.data.account.portrait;
    /// 初始化会控呼叫
    [[VCSMeetCall sharedInstance] initializeWithAccountModel:callAccount delegate:self];
    
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定发起邀请按钮事件
    [[self.inviteConfirmButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 发起邀请
        [[VCSMeetCall sharedInstance] inviteWithRoomNo:self.roomTextField.text targetId:self.accountTextField.text];
    }];
    
    /// 绑定上报自己的通话状态按钮事件
    [[self.callStatusButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 构建成员信息
        WaitingAccount *account = [[WaitingAccount alloc] init];
        account.id_p = self.loginModel.data.account.id;
        account.name = @"Sailor";
        account.nickname = @"SailorGa";
        account.portrait = @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png";
        account.roomNo = self.roomTextField.text;
        account.status = InviteStatus_Waiting;
        account.callType = 3;
        account.roomPwd = @"abc@12345";
        /// 更新帐户信息
        [[VCSMeetCall sharedInstance] updateWaitingAccountInfo:account];
    }];
    
    /// 绑定发起呼叫按钮事件
    [[self.callButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        for (WaitingAccount *account in self.callDataArray) {
            account.status = InviteStatus_Waiting;
        }
        /// 发起呼叫
        [[VCSMeetCall sharedInstance] callWithAccountsArray:self.callDataArray currentMember:self.selfAccount roomNo:self.roomTextField.text restart:YES];
    }];
    
    /// 绑定取消呼叫按钮事件
    [[self.callCancelButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        for (WaitingAccount *account in self.callDataArray) {
            account.status = InviteStatus_Canceled;
        }
        /// 取消呼叫
        [[VCSMeetCall sharedInstance] callCancelNewWithAccountsArray:self.callDataArray roomNo:self.roomTextField.text];
    }];
    
    /// 绑定发送文本消息按钮事件
    [[self.publishTextButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 发送文本消息
        [self publishTextClick];
    }];
    
    /// 绑定发送图片消息按钮事件
    [[self.publishImageButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 发送图片消息
        [self publishImageClick];
    }];
}

#pragma mark - 发送文本消息
/// 发送文本消息
- (void)publishTextClick {
    
    /// 发送单聊文本消息
    [[VCSMeetCall sharedInstance] sendTextWithMessage:@"你好呀。" receiverId:self.loginModel.data.account.id];
}

#pragma mark - 发送图片消息
/// 发送图片消息
- (void)publishImageClick {
    
    /// 创建图片地址
    NSString *imagePath = @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png";
    /// 发送单聊图片消息
    [[VCSMeetCall sharedInstance] sendImageWithImagePath:imagePath receiverId:self.loginModel.data.account.id];
}


#pragma mark - ------ VCSMeetCallDelegate 代理方法 ------
#pragma mark 呼叫连接状态变化
/// 呼叫连接状态变化
/// - Parameters:
///   - meetCall: 呼叫实例
///   - status: 连接状态，YES-连接 NO-断开
- (void)meetCall:(VCSMeetCall *)meetCall onConnectChangeStatus:(BOOL)status {
    
    /// 提示信息
    [FWToastBridge showToastAction:status ? @"呼叫连接成功" : @"呼叫连接断开"];
}

#pragma mark 呼叫响应结果
/// 呼叫响应结果
/// - Parameters:
///   - meetCall: 呼叫实例
///   - command: 指令类型
///   - result: 响应结果
- (void)meetCall:(VCSMeetCall *)meetCall onRespondCommand:(Command)command result:(Result)result {
    
    switch (command) {
        case Command_CmdRegHeartbeat: {
            if (result == Result_ResultOk) {
                SGLOG(@"呼叫心跳发送成功");
            } else {
                SGLOG(@"呼叫心跳发送失败");
            }
        }
            break;
        case Command_CmdRegChatRsp: {
            if (result == Result_ResultOk) {
                SGLOG(@"呼叫聊天消息发送成功");
            } else {
                SGLOG(@"呼叫聊天消息发送失败");
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 呼叫邀请通知
/// 呼叫邀请通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onInviteNotify:(InviteNotification *)notify error:(NSError *)error {
    
    /// 日志埋点
    [FWToastBridge showToastAction:@"邀请入会通知"];
}

#pragma mark 呼叫邀请确认通知
/// 呼叫邀请确认通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onInviteConfirmNotify:(InviteConfirm *)notify error:(NSError *)error {
    
    /// 日志埋点
    [FWToastBridge showToastAction:@"邀请入会确认通知"];
}

#pragma mark 成员通话状态变更通知
/// 成员通话状态变更通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onMemberChangeCallStatusNotify:(WaitingRoomBroadcast *)notify error:(NSError *)error {
    
    /// 日志埋点
    [FWToastBridge showToastAction:@"成员的通话状态通知"];
}

#pragma mark 自己通话状态变更通知
/// 自己通话状态变更通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onSelfChangeCallStatusNotify:(WaitingRoomUpdate *)notify error:(NSError *)error {
    
    /// 日志埋点
    [FWToastBridge showToastAction:@"自己的通话状态通知"];
}

#pragma mark 应用内推送通知
/// 应用内推送通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onInAppPushNotificationNotify:(PushNotification *)notify error:(NSError *)error {
    
    /// 日志埋点
    [FWToastBridge showToastAction:@"应用内推送通知"];
}

#pragma mark 聊天消息通知
/// 聊天消息通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onChatMessagehNotify:(RegChatNotify *)notify error:(NSError *)error {
    
    switch (notify.imBody.type) {
            /// 文本消息
        case MessageType_MtText: {
            /// 日志埋点
            [FWToastBridge showToastAction:@"聊天消息通知(文本消息)"];
        }
            break;
            /// 图片消息
        case MessageType_MtPicture: {
            /// 日志埋点
            [FWToastBridge showToastAction:@"聊天消息通知(图片消息)"];
        }
            break;
            /// 语音消息
        case MessageType_MtAudio: {
            /// 日志埋点
            [FWToastBridge showToastAction:@"聊天消息通知(语音消息)"];
        }
            break;
        default:
            break;
    }
}

#pragma mark 会议开始通知
/// 会议开始通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onMeetingBeginNotify:(MeetingBeginNotify *)notify error:(NSError *)error {
    
    /// 日志埋点
    SGLOG(@"会议开始通知");
}

#pragma mark 会议结束通知
/// 会议结束通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onMeetingEndNotify:(MeetingEndNotify *)notify error:(NSError *)error {
    
    /// 日志埋点
    SGLOG(@"会议结束通知");
}

#pragma mark 会议邀请通知
/// 会议邀请通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onMeetingInviteNotify:(InviteConfNoticeNotify *)notify error:(NSError *)error {
    
    /// 日志埋点
    SGLOG(@"会议邀请通知");
}

#pragma mark 发送聊天消息回执通知
/// 发送聊天消息回执通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onSendChatReceiptNotify:(RegChatResponse *)notify error:(NSError *)error {
    
    /// 日志埋点
    SGLOG(@"发送聊天消息回执通知");
}

#pragma mark 聊天消息撤回通知
/// 聊天消息撤回通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onChatRevokeNotify:(RegChatRevokeNotify *)notify error:(NSError *)error {
    
    /// 日志埋点
    SGLOG(@"聊天消息撤回通知");
}

#pragma mark 会议预约通知
/// 会议预约通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onMeetingPrepareNotify:(RoomPrepareNotify *)notify error:(NSError *)error {
    
    /// 日志埋点
    SGLOG(@"会议预约通知");
}

#pragma mark 呼叫卡片消息通知
/// 呼叫卡片消息通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - notify: 通知对象
///   - error: 错误信息
- (void)meetCall:(VCSMeetCall *)meetCall onCallCardNotify:(CallCardMsgNotify *)notify error:(NSError *)error {
    
    /// 日志埋点
    SGLOG(@"呼叫卡片消息通知");
}

#pragma mark 事件透传通知
/// 事件透传通知
/// - Parameters:
///   - meetCall: 呼叫实例
///   - event: 事件类型
///   - content: 事件内容
- (void)meetCall:(VCSMeetCall *)meetCall onTransparentEvent:(VCSMeetCommandEvent)event content:(NSString *)content {
    
    /// 日志埋点
    SGLOG(@"呼叫组件-事件命令透传通知 Command = %ld content = %@", event, content);
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 销毁会控呼叫资源
    [[VCSMeetCall sharedInstance] destroy];
}

@end
