//
//  FWIPAddressBridge.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWIPAddressBridge : NSObject

/// 获取具体的IP地址
+ (NSString *)currentIpAddress;

/// 获取IP地址的详细信息
+ (void)currentIPAdressDetailInfo;

@end

NS_ASSUME_NONNULL_END
