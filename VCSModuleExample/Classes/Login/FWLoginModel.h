//
//  FWLoginModel.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FWLoginDetailsModel;
@protocol FWLoginDetailsModel
@end

@class FWAccountModel;
@protocol FWAccountModel
@end

@class FWRoomModel;
@protocol FWRoomModel
@end

@class FWRegisterServeModel;
@protocol FWRegisterServeModel
@end

@class FWCompanyModel;
@protocol FWCompanyModel
@end

#pragma mark - 登录信息
@interface FWLoginModel : FWBaseModel

@property (nonatomic, strong) FWLoginDetailsModel *data;

@end

#pragma mark - 登录详情信息
@interface FWLoginDetailsModel : FWBaseModel

/// 登录token
@property (nonatomic, copy) NSString *token;
/// 账号信息
@property (nonatomic, strong) FWAccountModel *account;
/// 注册服务器信息
@property (nonatomic, strong) FWRegisterServeModel *reg;
/// 企业信息
@property (nonatomic, strong) FWCompanyModel *corp;
/// 在企业中的角色
@property (nonatomic, assign) FWCompanyMemberRoleType corp_role;

@end

#pragma mark - 账号信息
@interface FWAccountModel : FWBaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, assign) NSInteger created_at;
@property (nonatomic, assign) NSInteger updated_at;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *room_id;

/// 会议室信息
@property (nonatomic, strong) FWRoomModel *room;

/// 在企业中的昵称
@property (nonatomic, copy) NSString *corp_nickname;
/// 企业ID
@property (nonatomic, copy) NSString *corp_id;
/// 企业名称
@property (nonatomic, copy) NSString *corp_name;
/// 在企业中的角色
@property (nonatomic, assign) FWCompanyMemberRoleType corp_role;
@property (nonatomic, assign) NSInteger fs_used_size;
@property (nonatomic, assign) NSInteger reg_from;


@end

#pragma mark - 会议室信息
@interface FWRoomModel : FWBaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *sdk_no;
@property (nonatomic, assign) BOOL access_pwd;
@property (nonatomic, assign) BOOL access_whitelist;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger limited;
@property (nonatomic, assign) NSInteger samplerate;
@property (nonatomic, assign) NSInteger ol_count;
@property (nonatomic, assign) NSInteger vstate;
@property (nonatomic, assign) NSInteger astate;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, assign) BOOL water_mark;
@property (nonatomic, assign) NSInteger max_video;
@property (nonatomic, assign) NSInteger movehost_state;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, assign) NSInteger owner_type;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger token_updated_at;

@end

#pragma mark - 注册服务器信息
@interface FWRegisterServeModel : FWBaseModel

/// UDP地址
@property (nonatomic, copy) NSString *addr;
/// UDP端口
@property (nonatomic, assign) NSInteger port;
/// MQTT地址
@property (nonatomic, copy) NSString *mqtt_address;
/// MQTT端口
@property (nonatomic, assign) NSInteger mqtt_port;
/// MQTT完整地址
@property (nonatomic, copy) NSString *mqtt_tcp;
/// WebRtc MQTT地址
@property (nonatomic, copy) NSString *mqtt_ws;
/// 注册服务器ID
@property (nonatomic, copy) NSString *server_id;

@end

#pragma mark - 企业信息
@interface FWCompanyModel : FWBaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *app_id;

@property (nonatomic, assign) NSInteger created_at;
@property (nonatomic, assign) NSInteger reg_from;

@property (nonatomic, assign) BOOL vas_time;
@property (nonatomic, assign) BOOL vas_conc;

/// 企业法人账号信息
@property (nonatomic, strong) FWAccountModel *account;

@end

NS_ASSUME_NONNULL_END
