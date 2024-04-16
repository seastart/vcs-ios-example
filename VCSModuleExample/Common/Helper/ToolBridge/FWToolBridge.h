//
//  FWToolBridge.h
//  VCSModuleExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 系统权限类型
/**
 系统权限类型

- FWPermissionsStateVideo: 相机
- FWPermissionsStateAudio: 麦克风
*/
typedef enum : NSUInteger {
    FWPermissionsStateVideo = 1,
    FWPermissionsStateAudio
} FWPermissionsState;

/// 返回结果
typedef void (^FWPermissionsResultBlock)(BOOL status);

@interface FWToolBridge : NSObject

#pragma mark - 获取应用程序签名环境
/// 获取应用程序签名环境
+ (FWCertificateState)getApplicationCertificate;

#pragma mark - 获取UUID随机标识字符串
/// 获取UUID随机标识字符串
+ (NSString *)getUniqueIdentifier;

#pragma mark - 获取设备唯一标识符
/// 获取设备唯一标识符
+ (NSString *)getIdentifierForVendor;

#pragma mark - 获取设备名称
/// 获取设备名称
+ (NSString *)getDeviceName;

#pragma mark - 移除字符串两侧空格
/// 移除字符串两侧空格
/// - Parameter text: 原始串
+ (nullable NSString *)clearMarginsBlank:(nullable NSString *)text;

#pragma mark - 验证房间号码是否有效
/// 验证房间号码是否有效
/// - Parameter roomNo: 房间号码
+ (BOOL)isValidateRoomNo:(NSString *)roomNo;

/// 请求权限
/// @param state 权限类型
/// @param superVC 控制器
/// @param resultBlock 返回结果
+ (void)requestAuthorization:(FWPermissionsState)state superVC:(nullable UIViewController *)superVC result:(nullable FWPermissionsResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
