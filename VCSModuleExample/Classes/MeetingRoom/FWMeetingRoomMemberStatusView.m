//
//  FWMeetingRoomMemberStatusView.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingRoomMemberStatusView.h"

@interface FWMeetingRoomMemberStatusView()

/// 视图容器
@property (strong, nonatomic) UIView *contentView;

/// 背景幕布
@property (weak, nonatomic) IBOutlet UIView *screenView;
/// 成员头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/// 状态状态
@property (weak, nonatomic) IBOutlet UIView *statusView;
/// 视频状态
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
/// 音频状态
@property (weak, nonatomic) IBOutlet UIImageView *audioImageView;
/// 成员昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 底部状态
@property (weak, nonatomic) IBOutlet UIView *bottomStatusView;
/// 视频状态
@property (weak, nonatomic) IBOutlet UIImageView *bottomVideoImageView;
/// 音频状态
@property (weak, nonatomic) IBOutlet UIImageView *bottomAudioImageView;
/// 成员昵称
@property (weak, nonatomic) IBOutlet UILabel *bottomNameLabel;

/// 取流状态
@property (weak, nonatomic) IBOutlet UILabel *subscribeLabel;

@end

@implementation FWMeetingRoomMemberStatusView

#pragma mark - 初始化视图
/// 初始化视图
- (instancetype)init {

    self = [super init];
    if (self) {
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 初始化视图
/// 初始化视图
/// @param aDecoder 解码器
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 配置属性
- (void)setupConfig {
    
    /// 配置属性
}

#pragma mark - 设置成员信息
/// 设置成员信息
/// @param account 成员信息
- (void)setAccount:(nullable Account *)account {
    
    if (!account) {
        return;
    }
    /// 保存成员信息
    _account = account;
    
    /// 设置头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[account.portrait stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:kGetImage(@"icon_common_avatar")];
    
    /// 设置视频状态
    NSString *audioImageName = @"icon_room_audio_state_un";
    if (account.audioState == DeviceState_DsActive) {
        /// 开启状态
        audioImageName = @"icon_room_audio_state";
    }
    /// 设置音频状态
    [self.audioImageView setImage:kGetImage(audioImageName)];
    [self.bottomAudioImageView setImage:kGetImage(audioImageName)];
    
    /// 设置音频状态
    NSString *videoImageName = @"icon_room_video_state_un";
    if (account.videoState == DeviceState_DsActive) {
        /// 开启状态
        videoImageName = @"icon_room_video_state";
    }
    /// 设置视频状态
    [self.videoImageView setImage:kGetImage(videoImageName)];
    [self.bottomVideoImageView setImage:kGetImage(videoImageName)];
    
    /// 设置成员昵称
    self.nameLabel.text = account.nickname;
    self.bottomNameLabel.text = account.nickname;
    
    /// 声明当前订阅流描述
    NSString *subscribeTile = @"未";
    switch (self.streamType) {
        case FWStreamTypeNormal:
            subscribeTile = @"未";
            break;
        case FWStreamTypeMain:
            subscribeTile = @"主流";
            break;
        case FWStreamTypeSub:
            subscribeTile = @"辅流";
            break;
        case FWStreamTypeScreen:
            subscribeTile = @"共享";
            break;
        default:
            break;
    }
    /// 设置取流状态内容
    self.subscribeLabel.text = subscribeTile;
    /// 设置取流状态显示状态
    self.subscribeLabel.hidden = self.isSelf;
    
    if (self.isSelf) {
        /// 根据视频状态设置控件显示状态
        if (account.videoState == DeviceState_DsActive) {
            /// 开启状态
            self.screenView.hidden = YES;
            self.avatarImageView.hidden = YES;
            self.statusView.hidden = YES;
            self.bottomStatusView.hidden = NO;
        } else {
            /// 其它状态
            self.screenView.hidden = NO;
            self.avatarImageView.hidden = NO;
            self.statusView.hidden = NO;
            self.bottomStatusView.hidden = YES;
        }
    } else {
        /// 根据订阅流类型设置控件显示状态
        if (self.streamType != FWStreamTypeNormal) {
            /// 已订阅视频流
            self.screenView.hidden = YES;
            self.avatarImageView.hidden = YES;
            self.statusView.hidden = YES;
            self.bottomStatusView.hidden = NO;
        } else {
            /// 未订阅视频流
            self.screenView.hidden = NO;
            self.avatarImageView.hidden = NO;
            self.statusView.hidden = NO;
            self.bottomStatusView.hidden = YES;
        }
    }
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
