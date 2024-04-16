//
//  FWConstants.m
//  VCSModuleExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWConstants.h"

///// 组件APPID
//NSString * const VCSSDKAPPID = <# 替换成平台分配的Appid #>
///// 组件APPKEY
//NSString * const VCSSDKAPPKEY = <# 替换成平台分配的AppKey #>
/// 组件APPID
NSString * const VCSSDKAPPID = @"0a16828823ce41c5ad040be3ed384c14";
/// 组件APPKEY
NSString * const VCSSDKAPPKEY = @"a67c660b29234e2891cc6627fc6401ce";
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

#pragma mark - 服务器地址(风远)
/// 线上环境(默认)
NSString * const FWDEFAULTSERVICEURI = @"https://v1.srtc.live:9000";
/// 预发布环境
NSString * const FWUATSERVICEURI = @"https://v1-uat.srtc.live:9000";
/// 公网开发环境
NSString * const FWDEVSERVICEURI = @"https://dev.srtc.live:9000";
/// Anyconf环境
NSString * const FWANYCONFSERVICEURI = @"http://vcs.anyconf.cn:5000";
/// 集成测试环境
NSString * const FWQASERVICEURI = @"https://v1-qa-local.srtc.live:9000";
/// 压测环境
NSString * const FWPETSERVICEURI = @"https://v1-pet-local.srtc.live:9000";
/// 开发环境1
NSString * const FWLOCAL1SERVICEURI = @"https://localv1.srtc.live:9000";

#pragma mark - 服务器地址(萤石)
/// 线上环境
NSString * const FWDEFAULTSERVICEEZMURI = @"https://ezm.ys7.com";
/// 测试环境
NSString * const FWTESTSERVICEEZMURI = @"https://test1.swmeeting.cn";
/// 演示环境
NSString * const FWDEMOSERVICEEZMURI = @"https://test2.swmeeting.cn";
/// 百人环境
NSString * const FWOPTIMIZESERVICEEZMURI = @"https://test3.swmeeting.cn";
/// 本地环境
NSString * const FWLOCALSERVICEEZMURI = @"https://test4.swmeeting.cn";
/// 开发环境
NSString * const FWDEVSERVICEEZMURI = @"https://test5.swmeeting.cn";
/// PB环境
NSString * const FWPBSERVICEEZMURI = @"https://pb.swmeeting.cn";

/// Application Group Identifier
NSString * const FWAPPGROUP = @"group.cn.seastart.vcsmodule";

@implementation FWConstants

@end
