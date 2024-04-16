//
//  FWDrawingConfigViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/10.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWDrawingConfigViewController.h"

@interface FWDrawingConfigViewController ()

/// 服务地址
@property (weak, nonatomic) IBOutlet UITextField *drawingHostTextField;
/// 服务端口
@property (weak, nonatomic) IBOutlet UITextField *drawingPortTextField;
/// 房间标识
@property (weak, nonatomic) IBOutlet UITextField *roomIdTextField;
/// 用户标识
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
/// 进入画板按钮
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@end

@implementation FWDrawingConfigViewController

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
    self.navigationItem.title = @"画板配置";
    /// 设置文本默认数据
    self.drawingHostTextField.text = @"121.40.163.43";
    self.drawingPortTextField.text = @"3003";
    self.roomIdTextField.text = @"915606946786";
    self.userIdTextField.text = @"15606946786";
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定进入画板按钮事件
    [[self.enterButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 进入画板事件
        [self enterDrawingClick];
    }];
}

#pragma mark - 进入画板事件
/// 进入画板事件
- (void)enterDrawingClick {
    
    /// 获取服务地址
    NSString *drawingHostText = self.drawingHostTextField.text;
    /// 获取服务端口
    NSString *drawingPortText = self.drawingPortTextField.text;
    /// 获取房间标识
    NSString *roomIdText = self.roomIdTextField.text;
    /// 获取用户标识
    NSString *userIdText = self.userIdTextField.text;
    
    if (kStringIsEmpty(drawingHostText)) {
        [FWToastBridge showToastAction:@"请输入服务地址"];
        return;
    }
    
    if (kStringIsEmpty(drawingPortText)) {
        [FWToastBridge showToastAction:@"请输入服务端口"];
        return;
    }
    
    if (kStringIsEmpty(roomIdText)) {
        [FWToastBridge showToastAction:@"请输入房间标识"];
        return;
    }
    
    if (kStringIsEmpty(userIdText)) {
        [FWToastBridge showToastAction:@"请输入用户标识"];
        return;
    }
    
    /// 创建画板配置参数
    VCSWhiteBoardConfig *boardConfig = [[VCSWhiteBoardConfig alloc] init];
    boardConfig.drawingHost = drawingHostText;
    boardConfig.drawingPort = [drawingPortText intValue];
    boardConfig.roomId = roomIdText;
    boardConfig.userId = userIdText;
    boardConfig.readwrite = YES;
    
    /// 跳转画板页面
    [self push:@"FWDrawingViewController" info:boardConfig block:nil];
}

@end
