//
//  FWMeetingRoomMemberView.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/11.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWMeetingRoomMemberView;

@protocol FWMeetingRoomMemberViewDelegate <NSObject>

#pragma mark 成员选择回调
/// 成员选择回调
/// @param memberView 成员列表对象
/// @param account 成员信息
- (void)memberView:(FWMeetingRoomMemberView *)memberView didSelectItemAccount:(Account *)account;

@end

@interface FWMeetingRoomMemberView : UIView

/// 回调代理
@property (nonatomic, weak) IBOutlet id <FWMeetingRoomMemberViewDelegate> delegate;

#pragma mark - 更新成员信息
/// 更新成员信息
/// @param account 成员信息
- (void)memberUpdateWithAccount:(Account *)account;

#pragma mark - 成员离开房间
/// 成员离开房间
/// @param account 成员信息
- (void)memberExitWithAccount:(Account *)account;

@end

NS_ASSUME_NONNULL_END
