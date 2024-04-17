//
//  FWMeetingRoomMemberWindow.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/11.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingRoomMemberWindow.h"

@interface FWMeetingRoomMemberWindow() <UIGestureRecognizerDelegate>

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

@end

@implementation FWMeetingRoomMemberWindow

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

#pragma mark - 配置属性
- (void)setupConfig {
    
    /// 添加视图手势
    [self appendRecognizer];
}

#pragma mark - 添加视图手势
/// 添加视图手势
- (void)appendRecognizer {
    
    /// 添加视图手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
    gestureRecognizer.delegate = self;
    [self addGestureRecognizer:gestureRecognizer];
}

#pragma mark - 视图手势事件处理
/// 视图手势事件处理
- (void)handleGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    /// 回调上层成员选择
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowView:didSelectItemAccount:)]) {
        [self.delegate windowView:self didSelectItemAccount:self.account];
    }
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
    
    /// 设置音频状态
    NSString *videoImageName = @"icon_room_video_state_un";
    if (account.videoState == DeviceState_DsActive) {
        /// 开启状态
        videoImageName = @"icon_room_video_state";
    }
    /// 设置视频状态
    [self.videoImageView setImage:kGetImage(videoImageName)];
    
    /// 设置成员昵称
    self.nameLabel.text = account.nickname;
}

#pragma mark ------- UIGestureRecognizerDelegate代理实现 -------
#pragma mark 保证允许同时识别手势
/// 保证允许同时识别手势
/// - Parameters:
///   - gestureRecognizer: 手势识别器
///   - otherGestureRecognizer: 其它手势识别器
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
