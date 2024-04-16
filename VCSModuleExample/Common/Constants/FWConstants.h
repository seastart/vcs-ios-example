//
//  FWConstants.h
//  VCSModuleExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 组件APPID
FOUNDATION_EXTERN NSString *__nonnull const VCSSDKAPPID;
/// 组件APPKEY
FOUNDATION_EXTERN NSString *__nonnull const VCSSDKAPPKEY;
/// 组件签名
FOUNDATION_EXTERN NSString *__nonnull const VCSSDKSIGNATURE;
/// 加密密钥
FOUNDATION_EXTERN NSString *__nonnull const VCSKEYS;

/// 服务器地址存储键值
FOUNDATION_EXTERN NSString *__nonnull const FWDATADEFAULTAPIKEY;
/// 默认服务器
FOUNDATION_EXTERN NSString *__nonnull const DATADEFAULTAPI;
/// 服务器前缀
FOUNDATION_EXTERN NSString *__nonnull const FWDATADAPIHEADER;
/// 账号登录接口
FOUNDATION_EXTERN NSString *__nonnull const FWUSERLOGININTERFACE;
/// 账号注册接口
FOUNDATION_EXTERN NSString *__nonnull const FWUSERREGISTERINTERFACE;
/// 重置密码接口
FOUNDATION_EXTERN NSString *__nonnull const FWUSERRESETINTERFACE;
/// 获取验证码接口
FOUNDATION_EXTERN NSString *__nonnull const FWUSERVCODEINTERFACE;
/// 账号入会接口
FOUNDATION_EXTERN NSString *__nonnull const FWUSERENTERROOMINTERFACE;
/// 离开房间接口
FOUNDATION_EXTERN NSString *__nonnull const FWUSEREXITROOMINTERFACE;

#pragma mark - 服务器地址(风远)
/// 线上环境(默认)
FOUNDATION_EXTERN NSString *__nonnull const FWDEFAULTSERVICEURI;
/// 预发布环境
FOUNDATION_EXTERN NSString *__nonnull const FWUATSERVICEURI;
/// 公网开发环境
FOUNDATION_EXTERN NSString *__nonnull const FWDEVSERVICEURI;
/// Anyconf环境
FOUNDATION_EXTERN NSString *__nonnull const FWANYCONFSERVICEURI;
/// 集成测试环境
FOUNDATION_EXTERN NSString *__nonnull const FWQASERVICEURI;
/// 压测环境
FOUNDATION_EXTERN NSString *__nonnull const FWPETSERVICEURI;
/// 开发环境1
FOUNDATION_EXTERN NSString *__nonnull const FWLOCAL1SERVICEURI;

#pragma mark - 服务器地址(萤石)
/// 线上环境
FOUNDATION_EXTERN NSString *__nonnull const FWDEFAULTSERVICEEZMURI;
/// 测试环境
FOUNDATION_EXTERN NSString *__nonnull const FWTESTSERVICEEZMURI;
/// 演示环境
FOUNDATION_EXTERN NSString *__nonnull const FWDEMOSERVICEEZMURI;
/// 百人环境
FOUNDATION_EXTERN NSString *__nonnull const FWOPTIMIZESERVICEEZMURI;
/// 本地环境
FOUNDATION_EXTERN NSString *__nonnull const FWLOCALSERVICEEZMURI;
/// 开发环境
FOUNDATION_EXTERN NSString *__nonnull const FWDEVSERVICEEZMURI;
/// PB环境
FOUNDATION_EXTERN NSString *__nonnull const FWPBSERVICEEZMURI;

/// Application Group Identifier
FOUNDATION_EXTERN NSString *__nonnull const FWAPPGROUP;

@interface FWConstants : NSObject

@end

NS_ASSUME_NONNULL_END
