//
//  FWMeetingRoomModel.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/11.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWBaseModel.h"
#import "FWLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FWMeetingRoomDetailsModel;
@protocol FWMeetingRoomDetailsModel
@end

@class FWMeetingRoomControlModel;
@protocol FWMeetingRoomControlModel
@end

#pragma mark - 房间信息
@interface FWMeetingRoomModel : FWBaseModel

/// 房间详情
@property (nonatomic, strong) FWMeetingRoomDetailsModel *data;
/// 登录信息
@property (nonatomic, strong) FWLoginModel *loginModel;
/// 控制信息
@property (nonatomic, strong) FWMeetingRoomControlModel *controlModel;

@end

#pragma mark - 房间详情信息
@interface FWMeetingRoomDetailsModel : FWBaseModel

/// 互动服务地址
@property (nonatomic, copy) NSString *meeting_host;
/// 互动服务端口
@property (nonatomic, assign) NSInteger meeting_port;
/// 互动服务ID
@property (nonatomic, copy) NSString *meeting_server_id;
/// WebRtc互动服务
@property (nonatomic, copy) NSString *meeting_ws_url;
/// 角色
@property (nonatomic, assign) ConferenceRole role;
/// SDK Number
@property (nonatomic, assign) NSInteger sdk_no;
/// SDK Session
@property (nonatomic, copy) NSString *session;
/// 流媒体地址
@property (nonatomic, copy) NSString *stream_host;
/// 流媒体端口
@property (nonatomic, assign) NSInteger stream_port;
/// WebRtc流媒体服务
@property (nonatomic, copy) NSString *stream_ws_url;
/// 房间标题
@property (nonatomic, copy) NSString *title;
/// 房间类型(1-连线帐号 2-连线会议)
@property (nonatomic, assign) NSInteger type;
/// 流媒体服务器ID
@property (nonatomic, copy) NSString *upload_id;
/// 电子白板地址
@property (nonatomic, copy) NSString *wb_host;
/// http websocket 端口
@property (nonatomic, assign) NSInteger ws_port;
/// https websocket 端口
@property (nonatomic, assign) NSInteger wss_port;
/// 参会记录标识
@property (nonatomic, copy) NSString *room_attend_log_id;
/// 账号入会模式(是否隐身入会)
@property (nonatomic, assign) AccountMode acc_mode;

/// 图片模式是否可用
@property (nonatomic, assign) BOOL pic_mode;

/// 房间信息
@property (nonatomic, strong) FWRoomModel *room;

@end

#pragma mark - 房间控制信息
@interface FWMeetingRoomControlModel : FWBaseModel

/// 调试地址
@property (nonatomic, copy, nullable) NSString *debugText;
/// 视频状态
@property (nonatomic, assign) BOOL videoState;
/// 音频状态
@property (nonatomic, assign) BOOL audioState;

@end

NS_ASSUME_NONNULL_END
