//
//  FWScreenCastingViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/6.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWScreenCastingViewController.h"
#import "FWScreenCastingViewModel.h"

@interface FWScreenCastingViewController ()

/// 投屏按钮
@property (weak, nonatomic) IBOutlet UIButton *startCastingButton;
/// 音频按钮
@property (weak, nonatomic) IBOutlet UIButton *enableAudioButton;
/// 投屏地址
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
/// 用户名称
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
/// 发送延时标签
@property (weak, nonatomic) IBOutlet UILabel *delayedLabel;
/// 发送信息标签
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

/// ViewModel
@property (strong, nonatomic) FWScreenCastingViewModel *viewModel;

@end

@implementation FWScreenCastingViewController

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
    
    /// 设置title
    self.navigationItem.title = NSLocalizedString(@"无线投屏", nil);
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWScreenCastingViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定投屏地址
    RAC(self.domainTextField, text) = RACObserve(self.viewModel, domainText);
    /// 绑定用户名称
    RAC(self.usernameTextField, text) = RACObserve(self.viewModel, usernameText);
    
    /// 监听投屏地址
    [self.domainTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.domainText = text;
    }];
    
    /// 监听用户名称
    [self.usernameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.usernameText = text;
    }];
    
    /// 绑定音频按钮事件
    [[self.enableAudioButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 变更按钮选中状态
        self.enableAudioButton.selected = !self.enableAudioButton.selected;
    }];
    
    /// 绑定投屏按钮事件
    [[self.startCastingButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 构建投屏配置
        [self.viewModel buildMediaConfig];
    }];
    
    /// 构建完成订阅
    [self.viewModel.buildSubject subscribeNext:^(id _Nullable value) {
        @strongify(self);
        /// 开启投屏服务端
        [self startCastingWithConfig:value];
    }];
    
    /// 提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [FWToastBridge showToastAction:message];
        }
    }];
    
    /// 绑定启用音频按钮状态
    [RACObserve(self.enableAudioButton, selected) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        /// 变更音频启用状态
        self.viewModel.enableAudio = value.boolValue;
        /// 变更音频启用状态
        [[FWCastingBridge sharedManager] enableCastingAudio:self.viewModel.enableAudio];
    }];
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [FWToastBridge showToastAction];
        } else {
            [FWToastBridge hiddenToastAction];
        }
    }];
    
    /// 投屏状态通知回调
    [[FWCastingBridge sharedManager] screenStatusBlock:^(VCSScreenRecordStatus status) {
        @strongify(self);
        /// 变更按钮选中状态
        self.startCastingButton.selected = (status == VCSScreenRecordStatusStart);
    }];
    
    /// 发送延时通知回调
    [[FWCastingBridge sharedManager] delayedBlock:^(NSInteger timestamp) {
        @strongify(self);
        /// 更新发送延时标签内容
        self.delayedLabel.text = [NSString stringWithFormat:@"%@：%ld", NSLocalizedString(@"当前服务延时", nil), timestamp];
    }];
    
    /// 发送信息通知回调
    [[FWCastingBridge sharedManager] sendBlock:^(NSString * _Nonnull sendInfo) {
        @strongify(self);
        /// 更新发送信息标签内容
        self.sendLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"当前上行信息", nil), sendInfo];
    }];
}

#pragma mark - 开启投屏服务端
/// 开启投屏服务端
/// - Parameter castingConfig: 配置参数
- (void)startCastingWithConfig:(VCSScreenCastingConfig *)castingConfig {
    
    /// 配置投屏参数
    [[FWCastingBridge sharedManager] setupCastingConfig:castingConfig];
}

@end
