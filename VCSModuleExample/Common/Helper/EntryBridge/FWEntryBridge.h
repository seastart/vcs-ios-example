//
//  FWEntryBridge.h
//  VCSModuleExample
//
//  Created by SailorGa on 2021/10/27.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWAppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWEntryBridge : NSObject

/// 初始化方法
+ (FWEntryBridge *)sharedManager;

#pragma mark - 获取全局AppDelegate
- (FWAppDelegate *)appDelegate;

#pragma mark - 部分基础设置
/// 部分基础设置
- (void)setupDefault;

#pragma mark - 设置根视图
/// 设置根视图
- (void)setWindowRootView;

#pragma mark - 开启后台任务
/// 开启后台任务
- (void)beginBackgroundTask;

#pragma mark - 取消后台任务
/// 取消后台任务
- (void)cancelBackgroundTask;

@end

NS_ASSUME_NONNULL_END
