//
//  FWMeetingRoomMemberStatusView.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMeetingRoomMemberStatusView : UIView

/// 是否是自己
@property (nonatomic, assign) BOOL isSelf;
/// 窗口关联成员信息
@property (nonatomic, strong, nullable) Account *account;
/// 订阅流类型
@property (nonatomic, assign) FWStreamType streamType;

@end

NS_ASSUME_NONNULL_END
