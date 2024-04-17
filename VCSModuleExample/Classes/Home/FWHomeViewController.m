//
//  FWHomeViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/14.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWHomeViewController.h"
#import "FWLoginModel.h"

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
    
    /// 绑定进入房间按钮事件
    [[self.enterButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        
    }];
    
    /// 绑定呼叫服务按钮事件
    [[self.callButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转呼叫组件视图
        [self push:@"FWRoomCallViewController" info:self.loginModel block:nil];
    }];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 退出登录
    [[VCSMeetLogin sharedInstance] logout];
}

@end
