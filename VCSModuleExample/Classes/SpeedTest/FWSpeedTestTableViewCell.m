//
//  FWSpeedTestTableViewCell.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWSpeedTestTableViewCell.h"

/// 定义一个重用标识
static NSString *FWSpeedTestTableViewCellName = @"FWSpeedTestTableViewCell";

/// 声明数据源
#define dataArray @[@"10", @"20", @"30"]

@interface FWSpeedTestTableViewCell()

/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 分段组件
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

/// 选中时间回调
@property (copy, nonatomic) FWSpeedTestSelectedBlock selectedBlock;

@end

@implementation FWSpeedTestTableViewCell

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
    FWSpeedTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWSpeedTestTableViewCellName];
    /// 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:FWSpeedTestTableViewCellName owner:nil options:nil] lastObject];
        /// 配置属性
        [cell stepConfig];
    }
    return cell;
}

#pragma mark - 配置属性
- (void)stepConfig {
    
    /// 设置默认数据
    [self setupDefaultData];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
/// 设置默认数据
- (void)setupDefaultData {
    
    /// 循环设置分段组件标题
    for (NSInteger index = 0; index < dataArray.count; index++) {
        /// 设置分段组件标题
        [self.segmentedControl setTitle:[NSString stringWithFormat:@"%@S", dataArray[index]] forSegmentAtIndex:index];
    }
}

#pragma mark - 绑定动态响应信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定分段组件事件
    [[self.segmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISegmentedControl * _Nullable control) {
        @strongify(self);
        /// 换算时间
        int duration = [[dataArray objectAtIndex:control.selectedSegmentIndex] intValue];
        if (self.selectedBlock) {
            self.selectedBlock(duration);
        }
    }];
}

#pragma mark - 赋值显示
/// 赋值显示
/// @param titleLabel 标题
- (void)setupWithTitleLabel:(nullable NSString *)titleLabel {
    
    /// 设置显示
    self.titleLabel.text = titleLabel;
}

#pragma mark - 选中时间回调
/// 选中时间回调
/// @param selectedBlock 选中时间回调
- (void)selectedBlock:(FWSpeedTestSelectedBlock)selectedBlock {
    
    self.selectedBlock = selectedBlock;
}


@end
