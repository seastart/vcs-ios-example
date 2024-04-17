//
//  FWHomeViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/14.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWHomeViewController.h"
#import "FWMeetingRoomModel.h"

/// 分辨率列表
#define FWRESOLUTIONLISTS @[NSLocalizedString(@"720P", nil), NSLocalizedString(@"480P", nil)]

@interface FWHomeViewController ()

/// 房间号码
@property (weak, nonatomic) IBOutlet UITextField *roomnoTextField;
/// 参会昵称
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
/// 调试地址
@property (weak, nonatomic) IBOutlet UITextField *debugTextField;

/// 视频控制按钮
@property (weak, nonatomic) IBOutlet UIButton *videoSwitchButton;
/// 音频控制按钮
@property (weak, nonatomic) IBOutlet UIButton *audioSwitchButton;
/// 分辨率选择按钮
@property (weak, nonatomic) IBOutlet UIButton *resolutionButton;
/// 分辨率标签
@property (weak, nonatomic) IBOutlet UILabel *resolutionLabel;

/// 进入房间按钮
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
/// 呼叫服务按钮
@property (weak, nonatomic) IBOutlet UIButton *callButton;

/// 当前IP地址
@property (weak, nonatomic) IBOutlet UILabel *ipAddressLabel;

/// 登录信息
@property (nonatomic, strong) FWLoginModel *loginModel;

@end

@implementation FWHomeViewController

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
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
    
    /// 设置标题
    self.navigationItem.title = @"首页";
    /// 获取登录信息
    self.loginModel = (FWLoginModel *)self.info;
    
    /// 设置文本默认数据
    self.roomnoTextField.text = @"919420744";
    /// 设置默认参会昵称
    self.nicknameTextField.text = self.loginModel.data.account.nickname;
    /// 设置当前IP地址
    self.ipAddressLabel.text = [NSString stringWithFormat:@"当前IP地址：%@",[FWIPAddressBridge currentIpAddress]];
    /// 设置默认分辨率
    self.resolutionLabel.text = @"720P";
    
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定视频控制按钮事件
    [[self.videoSwitchButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.videoSwitchButton.selected = !self.videoSwitchButton.selected;
    }];
    
    /// 绑定音频控制按钮事件
    [[self.audioSwitchButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.audioSwitchButton.selected = !self.audioSwitchButton.selected;
    }];
    
    /// 绑定分辨率选择按钮事件
    [[self.resolutionButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 列举分辨率选项
        [self onEnumResolution];
    }];
    
    /// 绑定进入房间按钮事件
    [[self.enterButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 进入房间事件
        [self enterRoomClick];
    }];
    
    /// 绑定呼叫服务按钮事件
    [[self.callButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转呼叫组件视图
        [self push:@"FWRoomCallViewController" info:self.loginModel block:nil];
    }];
}

#pragma mark - 列举分辨率选项
/// 列举分辨率选项
- (void)onEnumResolution {
    
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    
    /// 批量设置服务地址选项列表
    for (NSString *value in FWRESOLUTIONLISTS) {
        UIAlertAction *renewAction = [UIAlertAction actionWithTitle:value style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            @strongify(self);
            /// 变更显示分辨率
            self.resolutionLabel.text = value;
        }];
        [alert addAction:renewAction];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 进入房间事件
/// 进入房间事件
- (void)enterRoomClick {
    
    /// 获取房间号码
    NSString *roomnoText = self.roomnoTextField.text;
    /// 获取参会昵称
    NSString *nicknameText = self.nicknameTextField.text;
    /// 获取调试地址
    NSString *debugText = self.debugTextField.text;
    /// 获取分辨率
    NSString *resolutionText = self.resolutionLabel.text;
    /// 获取视频状态
    BOOL videoState = self.videoSwitchButton.selected;
    /// 获取音频状态
    BOOL audioState = self.audioSwitchButton.selected;
    
    if (kStringIsEmpty(roomnoText)) {
        [FWToastBridge showToastAction:@"请输入房间号码"];
        return;
    }
    
    if (kStringIsEmpty(nicknameText)) {
        [FWToastBridge showToastAction:@"请输入参会昵称"];
        return;
    }
    
    if (kStringIsEmpty(resolutionText)) {
        [FWToastBridge showToastAction:@"请选择相应分辨率"];
        return;
    }
    
    /// 显示加载
    [FWToastBridge showToastAction];
    
    /// 构建控制参数
    FWMeetingRoomControlModel *controlModel = [[FWMeetingRoomControlModel alloc] init];
    /// 设置调试地址
    controlModel.debugText = debugText;
    /// 设置视频状态
    controlModel.videoState = videoState;
    /// 设置音频状态
    controlModel.audioState = audioState;
    /// 设置分辨率
    controlModel.resolutionText = resolutionText;
    
    /// 构建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// 房间号码
    [params setValue:roomnoText forKey:@"room_no"];
    /// 终端标识
    [params setValue:[FWToolBridge getIdentifierForVendor] forKey:@"device_id"];
    /// 参会昵称
    [params setValue:nicknameText forKey:@"account_nickname"];
    /// 版本号标识
    [params setValue:@"4" forKey:@"version"];
    
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWUSERENTERROOMINTERFACE params:params className:@"FWMeetingRoomModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        /// 隐藏加载
        [FWToastBridge hiddenToastAction];
        /// 获取房间信息
        FWMeetingRoomModel *roomModel = (FWMeetingRoomModel *)result;
        if (isSuccess && result) {
            /// 设置登录信息
            roomModel.loginModel = self.loginModel;
            /// 设置控制信息
            roomModel.controlModel = controlModel;
            /// 跳转房间视图
            [self push:@"FWMeetingRoomViewController" info:roomModel block:nil];
        } else {
            /// 确定提示信息
            NSString *toastStr = errorMsg;
            if (roomModel.code == 409) {
                /// 对方开启了密码验证，需要提供密码
                toastStr = @"请输入会议室密码";
            } else if (roomModel.code == 504) {
                /// 密码验证失败
                toastStr = @"密码错误。";
            } else if (roomModel.code == 410) {
                /// 企业并发不足(房间人数超限)
                toastStr = @"当前企业的会议人数已达上限。";
            } else if (roomModel.code == 411) {
                /// 房间已被主持人锁定
                toastStr = @"会议已锁定，如需加入，请联系主持人。";
            } else if (roomModel.code == 505) {
                /// 白名单验证失败
                toastStr = @"会议仅限受邀人加入，您当前没有权限。";
            } else if (roomModel.code == 501) {
                /// 会议已结束
                toastStr = @"您来晚了，会议已经结束了。";
            }
            /// 提示错误信息
            [FWToastBridge showToastAction:toastStr];
        }
    }];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 退出登录
    [[VCSMeetLogin sharedInstance] logout];
}

@end
