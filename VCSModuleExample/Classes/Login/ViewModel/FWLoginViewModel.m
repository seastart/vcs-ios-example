//
//  FWLoginViewModel.m
//  VCSModuleExample
//
//  Created by SailorGa on 2021/10/27.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWLoginViewModel.h"
#import "FWUserExtendModel.h"
#import "FWAuthToken.h"

@interface FWLoginViewModel()

/// 账户扩展信息
@property (nonatomic, strong) FWUserExtendModel *extendModel;

@end

@implementation FWLoginViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _loginSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _serverText = [[FWStoreDataBridge sharedManager] getServerUrl];
        _userSigText = [[FWStoreDataBridge sharedManager] getUserSig];
        _nicknameText = [[FWStoreDataBridge sharedManager] getNickname];
        _versionText = @"当前SDK版本信息：1.0.0";
        _buildText = [NSString stringWithFormat:@"示例编译时间：%@", BundleVersion];
        _loading = NO;
    }
    return self;
}

#pragma mark - 懒加载账户扩展信息
/// 懒加载账户扩展信息
- (FWUserExtendModel *)extendModel {
    
    if (!_extendModel) {
        _extendModel = [[FWUserExtendModel alloc] init];
        _extendModel.videoState = NO;
        _extendModel.audioState = NO;
    }
    return _extendModel;
}

#pragma mark - 登录事件
/// 登录事件
- (void)onLoginEvent {
    
    if (kStringIsEmpty(self.serverText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入服务地址", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.userSigText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入token", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.nicknameText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入用户昵称", nil)];
        return;
    }
    
    /// 缓存用户输入信息
    [[FWStoreDataBridge sharedManager] setServerUrl:self.serverText];
    [[FWStoreDataBridge sharedManager] setUserSig:self.userSigText];
    [[FWStoreDataBridge sharedManager] setNickname:self.nicknameText];
    
    /// 回调登录成功
    [self.loginSubject sendNext:nil];
}

@end
