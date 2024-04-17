//
//  FWMeetingRoomMemberWindow.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/11.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWMeetingRoomMemberWindow;

@protocol FWMeetingRoomMemberWindowDelegate <NSObject>

#pragma mark 成员选择回调
/// 成员选择回调
/// @param windowView 成员视图对象
/// @param account 成员信息
- (void)windowView:(FWMeetingRoomMemberWindow *)windowView didSelectItemAccount:(Account *)account;

@end

@interface FWMeetingRoomMemberWindow : UIView

/// 初始化视图
- (instancetype)init:(BOOL)isSelf;

#pragma mark - 初始化视图
- (instancetype)initWithFrame:(CGRect)frame isSelf:(BOOL)isSelf;

/// 回调代理
@property (nonatomic, weak) id <FWMeetingRoomMemberWindowDelegate> delegate;
/// 窗口关联成员信息
@property (nonatomic, strong, nullable) Account *account;
/// 订阅流类型
@property (nonatomic, assign) FWStreamType streamType;

@end

NS_ASSUME_NONNULL_END
