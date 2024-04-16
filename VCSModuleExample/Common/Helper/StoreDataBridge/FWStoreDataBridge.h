//
//  FWStoreDataBridge.h
//  VCSModuleExample
//
//  Created by SailorGa on 2022/3/4.
//  Copyright © 2022 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWStoreDataBridge : NSObject

#pragma mark - 初始化方法
/// 初始化方法
+ (FWStoreDataBridge *)sharedManager;

//#pragma mark - 登录用户
///// @param userModel 用户信息
//- (void)login:(nullable RTCEngineUserModel *)userModel;
//
//#pragma mark - 更新当前用户信息
///// 更新当前用户信息
///// @param userModel 用户信息
//- (void)updateUserModel:(nullable RTCEngineUserModel *)userModel;
//
//#pragma mark - 获取登录用户信息
///// 获取登录用户信息
//- (RTCEngineUserModel *)getUserModel;

#pragma mark - 退出登录
/// 退出登录
- (void)logout;

#pragma mark - 获取服务器地址
/// 获取服务器地址
- (NSString *)getServerUrl;

#pragma mark - 设置服务器地址
/// 设置服务器地址
/// @param serverUrl 版本号
- (void)setServerUrl:(NSString *)serverUrl;

#pragma mark - 获取UserSig
/// 获取UserSig
- (NSString *)getUserSig;

#pragma mark - 设置UserSig
/// 设置UserSig
/// @param userSig UserSig
- (void)setUserSig:(NSString *)userSig;

#pragma mark - 获取用户昵称
/// 获取用户昵称
- (NSString *)getNickname;

#pragma mark - 设置用户昵称
/// 设置用户昵称
/// @param nickname 用户昵称
- (void)setNickname:(NSString *)nickname;

#pragma mark - 获取房间编号
/// 获取房间编号
- (NSString *)getRoomNo;

#pragma mark - 设置房间编号
/// 设置房间编号
/// @param roomNo 房间编号
- (void)setRoomNo:(NSString *)roomNo;

@end

NS_ASSUME_NONNULL_END
