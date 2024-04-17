//
//  FWSpeedTestSpeedTableViewCell.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 转换按钮回调
typedef void(^FWSpeedTestSpeedSwitchChangeBlock)(BOOL isSwitch, BOOL upSpeed);
/// 速率变更回调
typedef void(^FWSpeedTestSpeedChangeBlock)(int speed, BOOL upSpeed);

@interface FWSpeedTestSpeedTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 赋值显示
/// @param titleLabel 标题
/// @param isSwitch 开关状态
/// @param upSpeed 标识是否为上行码率检测
- (void)setupWithTitleLabel:(nullable NSString *)titleLabel isSwitch:(BOOL)isSwitch upSpeed:(BOOL)upSpeed;

/// 转换按钮回调
/// @param switchChangeBlock 转换按钮回调
- (void)switchChangeBlock:(FWSpeedTestSpeedSwitchChangeBlock)switchChangeBlock;

/// 速率变更回调
/// @param speedChangeBlock 速率变更回调
- (void)speedChangeBlock:(FWSpeedTestSpeedChangeBlock)speedChangeBlock;

@end

NS_ASSUME_NONNULL_END
