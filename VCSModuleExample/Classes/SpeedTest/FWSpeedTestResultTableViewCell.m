//
//  FWSpeedTestResultTableViewCell.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWSpeedTestResultTableViewCell.h"

/// 定义一个重用标识
static NSString *FWSpeedTestResultTableViewCellName = @"FWSpeedTestResultTableViewCell";

@interface FWSpeedTestResultTableViewCell()

/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 值
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation FWSpeedTestResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    /// Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    /// 先去缓存池找可重用的cell
    FWSpeedTestResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWSpeedTestResultTableViewCellName];
    /// 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:FWSpeedTestResultTableViewCellName owner:nil options:nil] lastObject];
        /// 配置属性
        [cell stepConfig];
    }
    return cell;
}

#pragma mark - 配置属性
- (void)stepConfig {
    
    /// TO DO...
}

#pragma mark - 赋值显示
/// 赋值显示
/// @param titleText 标题
/// @param valueText 值
/// @param textColor 值文字颜色
- (void)setupWithTitleText:(nullable NSString *)titleText valueText:(nullable NSString *)valueText textColor:(UIColor *)textColor {
    
    /// 设置显示标题
    self.titleLabel.text = titleText;
    /// 设置显示值
    self.valueLabel.text = valueText;
    /// 设置显示值文字颜色(0x999999&0xFF5C5C)
    self.valueLabel.textColor = textColor;
}

@end
