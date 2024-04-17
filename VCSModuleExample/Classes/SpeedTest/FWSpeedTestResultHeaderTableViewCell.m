//
//  FWSpeedTestResultHeaderTableViewCell.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWSpeedTestResultHeaderTableViewCell.h"

/// 定义一个重用标识
static NSString *FWSpeedTestResultHeaderTableViewCellName = @"FWSpeedTestResultHeaderTableViewCell";

@interface FWSpeedTestResultHeaderTableViewCell()

/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FWSpeedTestResultHeaderTableViewCell

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
    FWSpeedTestResultHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWSpeedTestResultHeaderTableViewCellName];
    /// 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:FWSpeedTestResultHeaderTableViewCellName owner:nil options:nil] lastObject];
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
- (void)setupWithTitleText:(nullable NSString *)titleText {
    
    /// 设置显示标题
    self.titleLabel.text = titleText;
}

@end
