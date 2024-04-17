//
//  FWSpeedTestResultTableViewCell.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWSpeedTestResultTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

#pragma mark - 赋值显示
/// 赋值显示
/// @param titleText 标题
/// @param valueText 值
/// @param textColor 值文字颜色
- (void)setupWithTitleText:(nullable NSString *)titleText valueText:(nullable NSString *)valueText textColor:(UIColor *)textColor;

@end

NS_ASSUME_NONNULL_END
