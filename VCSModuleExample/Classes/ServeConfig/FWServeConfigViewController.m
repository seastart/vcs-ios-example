//
//  FWServeConfigViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWServeConfigViewController.h"

/// 服务器地址列表
#define FWSERVICEURILISTS @[@{NSLocalizedString(@"线上环境(FW)", nil) : FWDEFAULTSERVICEURI}, @{NSLocalizedString(@"预发布环境", nil) : FWUATSERVICEURI}, @{NSLocalizedString(@"公网开发环境", nil) : FWDEVSERVICEURI}, @{NSLocalizedString(@"Anyconf环境", nil) : FWANYCONFSERVICEURI}, @{NSLocalizedString(@"集成测试环境", nil) : FWQASERVICEURI}, @{NSLocalizedString(@"压测环境", nil) : FWPETSERVICEURI}, @{NSLocalizedString(@"开发环境1", nil) : FWLOCAL1SERVICEURI}, @{NSLocalizedString(@"线上环境(EZM)", nil) : FWDEFAULTSERVICEEZMURI}, @{NSLocalizedString(@"测试环境", nil) : FWTESTSERVICEEZMURI}, @{NSLocalizedString(@"演示环境", nil) : FWDEMOSERVICEEZMURI}, @{NSLocalizedString(@"百人环境", nil) : FWOPTIMIZESERVICEEZMURI}, @{NSLocalizedString(@"本地环境", nil) : FWLOCALSERVICEEZMURI}, @{NSLocalizedString(@"开发环境", nil) : FWDEVSERVICEEZMURI}, @{NSLocalizedString(@"PB环境", nil) : FWPBSERVICEEZMURI}]

@interface FWServeConfigViewController ()

/// 服务地址
@property (weak, nonatomic) IBOutlet UITextField *serverTextField;
/// 服务列表按钮
@property (weak, nonatomic) IBOutlet UIButton *selectServerButton;
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
    
    /// 绑定服务列表按钮事件
    [[self.selectServerButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 列举服务地址
        [self onEnumServesUri];
    }];
    
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

#pragma mark - 列举服务地址
/// 列举服务地址
- (void)onEnumServesUri {
    
    WeakSelf();
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    
    /// 批量设置服务地址选项列表
    for (NSDictionary *service in FWSERVICEURILISTS) {
        /// 创建提示框Action
        NSString *key = service.allKeys.firstObject;
        NSString *value = service.allValues.firstObject;
        UIAlertAction *renewAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@(%@)", key, value] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            /// 变更显示服务器地址
            weakSelf.serverTextField.text = value;
        }];
        [alert addAction:renewAction];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
