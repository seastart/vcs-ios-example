//
//  FWConstants.m
//  VCSModuleExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWConstants.h"

/// 组件APPID
NSString * const VCSSDKAPPID = <# 替换成平台分配的Appid #>
/// 组件APPKEY
NSString * const VCSSDKAPPKEY = <# 替换成平台分配的AppKey #>
/// 组件签名
NSString * const VCSSDKSIGNATURE = @"";
/// 加密密钥
NSString * const VCSKEYS = @"0a6430bcb7084269817813a06e905979";

/// 服务器地址存储键值
NSString * const FWDATADEFAULTAPIKEY = @"cn.seastart.vcsmodule.servers";
/// 默认服务器
NSString * const DATADEFAULTAPI = @"http://vcs.anyconf.cn:5000";
/// 服务器前缀
NSString * const FWDATADAPIHEADER = @"/vcs/";
/// 账号登录接口
NSString * const FWUSERLOGININTERFACE = @"account/login";
/// 账号注册接口
NSString * const FWUSERREGISTERINTERFACE = @"account/register";
/// 获取验证码接口
NSString * const FWUSERVCODEINTERFACE = @"account/vcode";
/// 重置密码接口
NSString * const FWUSERRESETINTERFACE = @"account/reset-password";
/// 账号入会接口
NSString * const FWUSERENTERROOMINTERFACE = @"room/enter";
/// 离开房间接口
NSString * const FWUSEREXITROOMINTERFACE = @"room/exit";

/// Application Group Identifier
NSString * const FWAPPGROUP = @"group.cn.seastart.vcsmodule";

@implementation FWConstants

@end
