//
//  FWServeConfigViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWServeConfigViewController.h"

@interface FWServeConfigViewController ()

/// 服务地址
@property (weak, nonatomic) IBOutlet UITextField *serverTextField;
/// 保存服务按钮
@property (weak, nonatomic) IBOutlet UIButton *saveServerButton;

@end

@implementation FWServeConfigViewController

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
    
    /// 设置标题
    self.navigationItem.title = @"服务配置";
    /// 设置文本默认数据
    self.serverTextField.text = [kSGUserDefaults objectForKey:FWDATADEFAULTAPIKEY];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定保存服务按钮事件
    [[self.saveServerButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 保存服务地址
        [self saveServerAction];
    }];
}

#pragma mark - 保存服务地址
/// 保存服务地址
- (void)saveServerAction {
    
    /// 获取服务地址
    NSString *serverText = self.serverTextField.text;
    
    if (kStringIsEmpty(serverText)) {
        [FWToastBridge showToastAction:@"请输入服务地址"];
        return;
    }
    /// 存储当前服务器地址
    [kSGUserDefaults setObject:serverText forKey:FWDATADEFAULTAPIKEY];
    /// 提示交互信息
    [FWToastBridge showToastAction:@"服务地址保存成功"];
    /// 离开当前页面
    [self.navigationController popViewControllerAnimated:self];
}

@end
