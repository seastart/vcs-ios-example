//
//  FWSpeedTestSpeedCollectionViewCell.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWSpeedTestSpeedCollectionViewCell.h"

@interface FWSpeedTestSpeedCollectionViewCell()

/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FWSpeedTestSpeedCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    /// Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        /// 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        /// 如果路径不存在
        if (arrayOfViews.count < 1) {
            return nil;
        }
        /// 如果xib中view不属于UICollectionViewCell类
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        /// 加载xib
        self = [arrayOfViews objectAtIndex:0];
        /// 配置属性
        [self stepConfig];
    }
    return self;
}

#pragma mark - 配置属性
/// 配置属性
- (void)stepConfig {
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 8.0f;
}

#pragma mark - 赋值显示
/// 赋值显示
/// @param selected 选中状态
/// @param titleText 标题
- (void)setupWithSelected:(BOOL)selected titleText:(nullable NSString *)titleText {
    
    /// 设置显示
    self.titleLabel.text = titleText;
    
    if (selected) {
        /// 设置选中状态
        self.titleLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = RGBOF(0x0039B3);
        self.layer.borderColor = RGBOF(0x0039B3).CGColor;
    } else {
        /// 设置非选中状态
        self.titleLabel.textColor = RGBOF(0x666666);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = RGBOF(0xDEDEDE).CGColor;
    }
}

@end
