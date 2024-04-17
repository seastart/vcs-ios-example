//
//  FWSpeedTestTableViewCell.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 选中时间回调
typedef void(^FWSpeedTestSelectedBlock)(int duration);

@interface FWSpeedTestTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 赋值显示
/// @param titleLabel 标题
- (void)setupWithTitleLabel:(nullable NSString *)titleLabel;

/// 选中时间回调
/// @param selectedBlock 选中时间回调
- (void)selectedBlock:(FWSpeedTestSelectedBlock)selectedBlock;

@end

NS_ASSUME_NONNULL_END
