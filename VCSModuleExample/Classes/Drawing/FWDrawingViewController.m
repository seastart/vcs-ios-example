//
//  FWDrawingViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/10.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWDrawingViewController.h"

@interface FWDrawingViewController () <VCSWhiteBoardViewDelegate>

/// 电子画板
@property (weak, nonatomic) IBOutlet VCSWhiteBoardView *whiteBoard;
/// 离开画板按钮
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
/// 更换背景图片按钮
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
/// 清空背景图片按钮
@property (weak, nonatomic) IBOutlet UIButton *emptyBackButton;
/// 图片按钮状态按钮
@property (weak, nonatomic) IBOutlet UIButton *pictureStateButton;

@end

@implementation FWDrawingViewController

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
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
    /// 进入电子画板
    [self enterDrawingBoard:self.info];
}

/// 进入电子画板
/// - Parameter boardConfig: 配置参数
- (void)enterDrawingBoard:(VCSWhiteBoardConfig *)boardConfig {
    
    /// 加入电子画板
    [self.whiteBoard enterDrawingBoardWithBoardConfig:boardConfig delegate:self];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定离开画板按钮事件
    [[self.closeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"离开画板" message:@"确定要离开画板吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        }];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            /// 离开页面
            [self.navigationController popViewControllerAnimated:self];
        }];
        [alert addAction:cancelAction];
        [alert addAction:ensureAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    /// 绑定更换背景图片按钮
    [[self.changeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 更换白板背景图片
        [self changeDrawBackImage:@"http://assets.sailorhub.cn/202108191348.png"];
    }];
    
    /// 清空背景图片按钮
    [[self.emptyBackButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 更换白板背景图片
        [self changeDrawBackImage:nil];
    }];
    
    /// 图片状态按钮
    [[self.pictureStateButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 设置图片按钮状态
        [self setupPictureState];
    }];
}

#pragma mark - 更换画板背景图片
/// 更换画板背景图片
/// @param imageUrl 背景图片路径
- (void)changeDrawBackImage:(nullable NSString *)imageUrl {
    
    /// 显示加载框
    [FWToastBridge showToastAction];
    /// 首先下载图片
    [[FWNetworkBridge sharedManager] downloadImageWithImageUrl:imageUrl finishBlock:^(UIImage * _Nullable image) {
        /// 更换画板背景图片(共享图片)
        [self.whiteBoard setDrawingBackImageWithImage:image imageUrl:imageUrl];
        /// 隐藏加载框
        [FWToastBridge hiddenToastAction];
    }];
}

#pragma mark - 设置图片按钮状态
/// 设置图片按钮状态
- (void)setupPictureState {
    
    self.pictureStateButton.selected = !self.pictureStateButton.selected;
    [self.whiteBoard setPictureButtonWithHidden:self.pictureStateButton.selected];
}

#pragma mark - ------- VCSWhiteBoardViewDelegate -------
#pragma mark 画板连接状态回调
/// 画板连接状态回调
/// - Parameters:
///   - whiteBoardView: 画板实例
///   - state: 连接状态
- (void)whiteBoardView:(VCSWhiteBoardView *)whiteBoardView onConnectStateChange:(VCSDrawingConnectState)state {
    
    if (state == VCSDrawingConnectStateSucceed) {
        [FWToastBridge showToastAction:NSLocalizedString(@"电子画板连接成功", nil)];
    } else {
        [FWToastBridge showToastAction:NSLocalizedString(@"电子画板连接不稳定，请检查你的网络设置。", nil)];
    }
}

#pragma mark 画板内容清空事件
/// 画板内容清空事件
/// - Parameters:
///   - whiteBoardView: 画板实例
- (void)onDrawingClearEvent:(VCSWhiteBoardView *)whiteBoardView {
    
    WeakSelf();
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除画板" message:@"确定要清除画板上的全部内容吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        /// 清空背景图片数据
        [weakSelf.whiteBoard setDrawingBackImageWithImage:nil imageUrl:nil];
        /// 清空电子画板数据
        [weakSelf.whiteBoard drawingClear];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 工具栏图片按钮选中事件
/// 工具栏图片按钮选中事件
/// - Parameters:
///   - whiteBoardView: 画板实例
- (void)onSelectedPictureEvent:(VCSWhiteBoardView *)whiteBoardView {
    
    /// 这里可以实现去选取图片、上传等操作
    /// 成功后调取画板setDrawingBackImageWithImage:方法更换画板背景图片或共享图片
    SGLOG(@"电子画板图片按钮点击事件");
}

#pragma mark 画板背景图片变更事件
/// 画板背景图片变更事件
/// - Parameters:
///   - whiteBoardView: 画板实例
///   - imageUrl: 背景图片路径
- (void)whiteBoardView:(VCSWhiteBoardView *)whiteBoardView onChangeDrawBackImageEvent:(nullable NSString *)imageUrl {
    
    /// 这里可以实现图片的下载等操作
    /// 成功后调取画板setDrawingLocalBackImageWithImage:方法更换画板本地背景图片
    SGLOG(@"电子画板背景图片变更");
}

@end
