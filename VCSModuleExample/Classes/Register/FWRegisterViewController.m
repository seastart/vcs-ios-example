//
//  FWRegisterViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRegisterViewController.h"

@interface FWRegisterViewController ()

/// 手机号码
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
/// 验证码
@property (weak, nonatomic) IBOutlet UITextField *vcodeTextField;
/// 密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/// 获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *vcodeButton;
/// 提交按钮
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

/// 验证码计时器
@property (nonatomic, strong) dispatch_source_t timer;
/// 页面类型
@property (nonatomic, assign) FWUserCodeState state;

@end

@implementation FWRegisterViewController

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    /// 隐藏顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 获取页面类型
    FWUserCodeState state = (FWUserCodeState)[self.info integerValue];
    /// 设置标题
    self.navigationItem.title = (state == FWUserCodeStateRegister) ? @"账号注册" : @"重置密码";
    /// 保存页面类型
    self.state = state;
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 获取验证码成功开始读秒
/// 获取验证码成功开始读秒
- (void)countdownAction {
    
    @weakify(self);
    /// 倒计时时间
    __block NSInteger time = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    /// 每秒执行
    dispatch_source_set_timer(self.timer,DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        /// 倒计时结束，关闭
        if(time <= 0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                /// 设置常规效果的样式
                [self noneStyle];
            });
        } else {
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                /// 设置label读秒效果
                [self countdownStyle:seconds];
            });
            time--;
        }
    });
    dispatch_resume(self.timer);
}

#pragma mark - 设置验证码按钮效果
- (void)noneStyle {
    
    [self.vcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.vcodeButton setTitleColor:RGBOF(0x0039B3) forState:UIControlStateNormal];
    /// 开启用户交互关闭
    self.vcodeButton.userInteractionEnabled = YES;
}

#pragma mark - 设置按钮读秒效果
- (void)countdownStyle:(int)seconds {
    
    [self.vcodeButton setTitle:[NSString stringWithFormat:@"%.2dS", seconds] forState:UIControlStateNormal];
    [self.vcodeButton setTitleColor:RGBOF(0xB8B8B8) forState:UIControlStateNormal];
    /// 在这个状态下 用户交互关闭，防止再次点击 button 再次计时
    self.vcodeButton.userInteractionEnabled = NO;
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定获取验证码按钮事件
    [[self.vcodeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 获取手机号码
        NSString *mobileText = self.mobileTextField.text;
        
        if (kStringIsEmpty(mobileText)) {
            [FWToastBridge showToastAction:@"请输入手机号码"];
            return;
        }
        /// 获取短信验证码
        [self getMobileCode:mobileText];
    }];
    
    /// 绑定提交按钮事件
    [[self.submitButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 获取手机号码
        NSString *mobileText = self.mobileTextField.text;
        /// 获取验证码
        NSString *vcodeText = self.vcodeTextField.text;
        /// 获取密码
        NSString *passwordText = self.passwordTextField.text;
        
        if (kStringIsEmpty(mobileText)) {
            [FWToastBridge showToastAction:@"请输入手机号码"];
            return;
        }
        if (kStringIsEmpty(vcodeText)) {
            [FWToastBridge showToastAction:@"请输入短信验证码"];
            return;
        }
        if (kStringIsEmpty(passwordText)) {
            [FWToastBridge showToastAction:@"请输入密码"];
            return;
        }
        
        /// 根据页面类型处理提交事件
        if (self.state == FWUserCodeStateRegister) {
            /// 注册账号
            [self onRegisterAccount:mobileText vcodeText:vcodeText passwordText:passwordText];
        } else {
            /// 重置密码
            [self onResetPassword:mobileText vcodeText:vcodeText passwordText:passwordText];
        }
    }];
}

#pragma mark - 获取验证码
/// 获取验证码
/// - Parameter mobileText: 手机号码
- (void)getMobileCode:(NSString *)mobileText {
    
    @weakify(self);
    /// 显示加载
    [FWToastBridge showToastAction];
    /// 构建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.state) forKey:@"used_for"];
    [params setValue:mobileText forKey:@"mobile"];
    [params setValue:mobileText forKey:@"account_name"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWUSERVCODEINTERFACE params:params className:@"FWBaseModel" result:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        @strongify(self);
        /// 隐藏加载
        [FWToastBridge hiddenToastAction];
        if (result && result) {
            /// 获取验证码成功开始读秒
            [self countdownAction];
            /// 提示交互信息
            [FWToastBridge showToastAction:@"验证码发送成功,请注意查收"];
        } else {
            /// 提示错误信息
            [FWToastBridge showToastAction:errorMsg];
        }
    }];
}

#pragma mark - 注册账号
/// 注册账号
/// - Parameters:
///   - mobileText: 手机号码
///   - vcodeText: 短信验证码
///   - passwordText: 密码
- (void)onRegisterAccount:(NSString *)mobileText vcodeText:(NSString *)vcodeText passwordText:(NSString *)passwordText {
    
    @weakify(self);
    /// 显示加载
    [FWToastBridge showToastAction];
    /// 构建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:mobileText forKey:@"name"];
    [params setValue:mobileText forKey:@"mobile"];
    [params setValue:mobileText forKey:@"nickname"];
    [params setValue:vcodeText forKey:@"vcode"];
    [params setValue:[FWToolBridge HmacSha1:VCSKEYS data:[NSString stringWithFormat:@"%@%@", mobileText, passwordText]] forKey:@"password"];
    [params setValue:@(3) forKey:@"dev_type"];
    [params setValue:[FWToolBridge getIdentifierForVendor] forKey:@"device_id"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWUSERREGISTERINTERFACE params:params className:@"FWBaseModel" result:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        @strongify(self);
        /// 隐藏加载
        [FWToastBridge hiddenToastAction];
        if (result && result) {
            /// 提示交互信息
            [FWToastBridge showToastAction:@"注册成功"];
            /// 离开当前页面
            [self.navigationController popViewControllerAnimated:self];
        } else {
            /// 提示错误信息
            [FWToastBridge showToastAction:errorMsg];
        }
    }];
}

#pragma mark - 重置密码
/// 重置密码
/// - Parameters:
///   - mobileText: 手机号码
///   - vcodeText: 短信验证码
///   - passwordText: 密码
- (void)onResetPassword:(NSString *)mobileText vcodeText:(NSString *)vcodeText passwordText:(NSString *)passwordText {
    
    @weakify(self);
    /// 显示加载
    [FWToastBridge showToastAction];
    /// 构建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:mobileText forKey:@"name"];
    [params setValue:vcodeText forKey:@"vcode"];
    [params setValue:[FWToolBridge HmacSha1:VCSKEYS data:[NSString stringWithFormat:@"%@%@", mobileText, passwordText]] forKey:@"new_password"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWUSERRESETINTERFACE params:params className:@"FWBaseModel" result:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        @strongify(self);
        /// 隐藏加载
        [FWToastBridge hiddenToastAction];
        if (result && result) {
            /// 提示交互信息
            [FWToastBridge showToastAction:@"重置密码成功"];
            /// 离开当前页面
            [self.navigationController popViewControllerAnimated:self];
        } else {
            /// 提示错误信息
            [FWToastBridge showToastAction:errorMsg];
        }
    }];
}

@end
