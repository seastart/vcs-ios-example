//
//  FWSpeedTestSpeedCollectionViewCell.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWSpeedTestSpeedCollectionViewCell : UICollectionViewCell

#pragma mark - 赋值显示
/// 赋值显示
/// @param selected 选中状态
/// @param titleText 标题
- (void)setupWithSelected:(BOOL)selected titleText:(nullable NSString *)titleText;

@end

NS_ASSUME_NONNULL_END
