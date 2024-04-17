//
//  FWLoginViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWLoginViewController.h"
#import "FWLoginModel.h"

@interface FWLoginViewController ()

/// 登录账号
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
/// 登录密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/// 账号登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/// 账号注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
/// 重置密码按钮
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordButton;
/// 服务配置按钮
@property (weak, nonatomic) IBOutlet UIButton *serveConfigButton;
/// 无线投屏按钮
@property (weak, nonatomic) IBOutlet UIButton *screenCastingButton;
/// 网络检测按钮
@property (weak, nonatomic) IBOutlet UIButton *speedTestButton;
/// 电子画板按钮
@property (weak, nonatomic) IBOutlet UIButton *drawingButton;
/// 当前服务器地址
@property (weak, nonatomic) IBOutlet UILabel *serveAddrLable;

@end

@implementation FWLoginViewController

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    /// 设置当前服务器
    self.serveAddrLable.text = [NSString stringWithFormat:@"当前服务地址：%@", [kSGUserDefaults objectForKey:FWDATADEFAULTAPIKEY]];
}

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
/// 初始化UI
- (void)buildView {
    
    /// 设置文本默认数据
    self.accountTextField.text = @"15606946786";
    self.passwordTextField.text = @"abc@12345";
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定账号登录按钮事件
    [[self.loginButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 登录事件
        [self loginAction];
    }];
    
    /// 绑定账号注册按钮事件
    [[self.registerButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转注册页面
        [self push:@"FWRegisterViewController" info:@(FWUserCodeStateRegister) block:nil];
    }];
    
    /// 绑定重置密码按钮事件
    [[self.resetPasswordButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转注册页面
        [self push:@"FWRegisterViewController" info:@(FWUserCodeStateResetCode) block:nil];
    }];
    
    /// 绑定服务配置按钮事件
    [[self.serveConfigButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转服务配置页面
        [self push:@"FWServeConfigViewController"];
    }];
    
    /// 绑定无线投屏按钮事件
    [[self.screenCastingButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转无线投屏页面
        [self push:@"FWScreenCastingViewController"];
    }];
    
    /// 绑定网络检测按钮事件
    [[self.speedTestButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转网络检测页面
        [self push:@"FWSpeedTestViewController"];
    }];
    
    /// 绑定电子画板按钮事件
    [[self.drawingButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转电子画板配置页面
        [self push:@"FWDrawingConfigViewController"];
    }];
}

#pragma mark - 登录事件
/// 登录事件
- (void)loginAction {
    
    /// 获取登录账号
    NSString *accountText = self.accountTextField.text;
    /// 获取登录密码
    NSString *passwordText = self.passwordTextField.text;
    
    if (kStringIsEmpty(accountText)) {
        [FWToastBridge showToastAction:@"请输入登录账号"];
        return;
    }
    
    if (kStringIsEmpty(passwordText)) {
        [FWToastBridge showToastAction:@"请输入登录密码"];
        return;
    }
    
    /// 显示加载
    [FWToastBridge showToastAction];
    /// 构建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:accountText forKey:@"loginname"];
    [params setValue:[FWToolBridge HmacSha1:VCSKEYS data:[NSString stringWithFormat:@"%@%@", accountText, passwordText]] forKey:@"password"];
    [params setValue:@(3) forKey:@"dev_type"];
    [params setValue:[FWToolBridge getIdentifierForVendor] forKey:@"device_id"];
    
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWUSERLOGININTERFACE params:params className:@"FWLoginModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        /// 隐藏加载
        [FWToastBridge hiddenToastAction];
        if (isSuccess && result) {
            /// 获取登录信息
            FWLoginModel *loginModel = (FWLoginModel *)result;
            /// 设置userToken
            [[FWNetworkBridge sharedManager] setUserToken:loginModel.data.token];
            /// 创建会控配置
            VCSMeetConfig *meetConfig = [[VCSMeetConfig alloc] init];
            meetConfig.token = loginModel.data.token;
            meetConfig.meetingHost = loginModel.data.reg.mqtt_address;
            meetConfig.meetingPort = loginModel.data.reg.mqtt_port;
            meetConfig.serverId = loginModel.data.reg.server_id;
            meetConfig.timeoutInterval = 20;
            /// 令牌登录会控服务
            [[VCSMeetLogin sharedInstance] loginWithMeetConfig:meetConfig resultBlock:^(NSError * _Nullable error) {
                if (error) {
                    /// 提示错误信息
                    [FWToastBridge showToastAction:@"令牌登录会控服务失败"];
                } else {
                    /// 跳转首页视图
                    [self push:@"FWHomeViewController" info:loginModel block:nil];
                }
            }];
        } else {
            /// 提示错误信息
            [FWToastBridge showToastAction:errorMsg];
        }
    }];
}

@end
