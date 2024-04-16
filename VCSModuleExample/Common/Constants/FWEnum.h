//
//  FWEnum.h
//  VCSModuleExample
//
//  Created by SailorGa on 2023/3/13.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 签名证书类型
/**
 签名证书类型

- FWCertificateStateDebug: Debug版本
- FWCertificateStateAdhoc: Adhoc版本
- FWCertificateStateAppStore: AppStore版本
*/
typedef enum : NSUInteger {
    FWCertificateStateDebug = 1,
    FWCertificateStateAdhoc,
    FWCertificateStateAppStore
} FWCertificateState;

#pragma mark - 企业成员角色类型
/**
 企业成员角色类型

- FWCompanyMemberRoleTypeNormal: 普通成员
- FWCompanyMemberRoleTypeCreator: 创建者
- FWCompanyMemberRoleTypeAdmin: 管理员
*/
typedef enum : NSUInteger {
    FWCompanyMemberRoleTypeNormal = 0,
    FWCompanyMemberRoleTypeCreator,
    FWCompanyMemberRoleTypeAdmin
} FWCompanyMemberRoleType;

#pragma mark - 用户获取验证码类型
/**
用户获取验证码类型

- FWUserCodeStateRegister: 注册
- FWUserCodeStateResetCode: 重置密码
*/
typedef enum : NSUInteger {
    FWUserCodeStateRegister = 1,
    FWUserCodeStateResetCode
} FWUserCodeState;

@interface FWEnum : NSObject

@end

NS_ASSUME_NONNULL_END
