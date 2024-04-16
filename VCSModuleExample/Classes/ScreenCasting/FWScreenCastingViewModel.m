//
//  FWScreenCastingViewModel.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/6.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWScreenCastingViewModel.h"

@interface FWScreenCastingViewModel()

@end

@implementation FWScreenCastingViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _toastSubject = [RACSubject subject];
        _buildSubject = [RACSubject subject];
        _domainText = @"192.168.1.122";
        _usernameText = @"投屏测试成员";
        _enableAudio = YES;
        _loading = NO;
    }
    return self;
}

#pragma mark - 构建投屏配置
/// 构建投屏配置
- (void)buildMediaConfig {
    
    if (kStringIsEmpty(self.domainText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入投屏地址", nil)];
        return;
    }
    
    if (![self.domainText isValidateIP]) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入正确的投屏地址", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.usernameText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入用户名称", nil)];
        return;
    }
    
    /// 创建配置参数
    VCSScreenCastingConfig *castingConfig = [[VCSScreenCastingConfig alloc] init];
    castingConfig.castingHost = self.domainText;
    castingConfig.username = self.usernameText;
    
    /// 回调构建完成
    [self.buildSubject sendNext:castingConfig];
}

@end
