//
//  FWSpeedTestViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWSpeedTestViewController.h"
#import "FWSpeedTestTableViewCell.h"
#import "FWSpeedTestSpeedTableViewCell.h"
#import "FWSpeedTestResultTableViewCell.h"
#import "FWSpeedTestResultHeaderTableViewCell.h"

/// 分组头部高度
#define FWSpeedTestTableSectionHeaderViewH 10.0
/// 结果正常颜色
#define FWSpeedTestResultNormalRGB RGBOF(0x32CD32)
/// 结果异常颜色
#define FWSpeedTestResultWarnRGB RGBOF(0xFF5C5C)
/// 结果默认颜色
#define FWSpeedTestResultDefaultRGB RGBOF(0x999999)

@interface FWSpeedTestViewController () <VCSSpeedTestDelegate>

/// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 开始测试按钮
@property (weak, nonatomic) IBOutlet UIButton *startButton;
/// 等待检测视图
@property (weak, nonatomic) IBOutlet UIView *waitingView;

/// 标识下行码率检测状态
@property (nonatomic, assign) BOOL isUpSpeed;
/// 标识下行码率检测状态
@property (nonatomic, assign) BOOL isDownSpeed;

/// 上行码率，默认 20000kbps
@property (nonatomic, assign) int upSpeed;
/// 下行码率，默认 20000kbps
@property (nonatomic, assign) int downSpeed;
/// 检测时长，默认 30s
@property (nonatomic, assign) int duration;

/// 标识网络检测完成
@property (nonatomic, assign) BOOL isNetworkFinish;

/// 上行网络监测结果
@property (nonatomic, strong) VCSSpeedTestResult *uploadResult;
/// 下行网络监测结果
@property (nonatomic, strong) VCSSpeedTestResult *downResult;
/// 网络连接状况结果
@property (nonatomic, strong) VCSSpeedTestConnectResult *connectResult;

@end

@implementation FWSpeedTestViewController

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    /// 隐藏顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置页面标题
    self.navigationItem.title = @"网络检测";
    /// 设置背景色
    self.view.backgroundColor = RGB(248, 248, 248);
    /// 设置默认数据
    [self setupDefaultData];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
/// 设置默认数据
- (void)setupDefaultData {
    
    /// 默认网络检测未完成
    self.isNetworkFinish = NO;
    /// 默认上行检测
    self.isUpSpeed = YES;
    /// 默认下行检测
    self.isDownSpeed = YES;
    /// 默认检测时长
    self.duration = 10;
    /// 默认上行码率
    self.upSpeed = 2;
    /// 默认下行码率
    self.downSpeed = 2;
}

#pragma mark - 绑定动态响应信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定开始测试按钮事件
    [[self.startButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 开启网络检测
        [self onBeginedNetworkDetection];
    }];
}

#pragma mark - 开启网络检测(房间外部)
/// 开启网络检测(房间外部)
- (void)onBeginedNetworkDetection {
    
    int upSpeed = self.isUpSpeed ? self.upSpeed * 1000 : 0;
    int downSpeed = self.isDownSpeed ? self.downSpeed * 1000 : 0;
    int duration = self.duration;
    
    /// 初始化网络监测配置
    VCSSpeedTestParams *params = [[VCSSpeedTestParams alloc] init];
    params.streamId = @"991125";
    params.streamHost = @"103.78.228.91";
    params.streamPort = 8006;
    params.expectedUpBandwidth = upSpeed;
    params.expectedDownBandwidth = downSpeed;
    params.duration = duration;
    
    /// 开启网络检测
    BOOL isSucceed = [[VCSSpeedTest sharedInstance] startSpeedTest:params delegate:self];
    if (!isSucceed) {
        SGLOG(@"当前检测未结束，请稍后重试");
    }
}

#pragma mark - ------- VCSSpeedTestDelegate代理实现 -------
#pragma mark 网络测速开始回调
/// 网络测速开始回调
/// @param speedTest  VCSSpeedTest实例
- (void)speedTestDidBegined:(VCSSpeedTest *)speedTest {
    
    /// 网络检测开启事件
    [self onNetworkBegined];
}

#pragma mark 网络测速的结果回调
/// 网络测速的结果回调
/// @param speedTest VCSSpeedTest实例
/// @param uploadResult 上行网速测试数据
/// @param downResult 下行网速测试数据
/// @param connectResult 连接情况
- (void)speedTest:(VCSSpeedTest *)speedTest didFinishUploadResult:(nullable VCSSpeedTestResult *)uploadResult downResult:(nullable VCSSpeedTestResult *)downResult connectResult:(nullable VCSSpeedTestConnectResult *)connectResult {
    
    /// 网络检测完成事件
    [self onNetworkFinshed:uploadResult downResult:downResult connectResult:connectResult];
}

#pragma mark - 网络检测开启事件
/// 网络检测开启事件
- (void)onNetworkBegined {
    
    /// 显示检测等待指示视图
    self.waitingView.hidden = NO;
    /// 标记网络检测未完成
    self.isNetworkFinish = NO;
    /// 置空上行网络监测结果
    self.uploadResult = nil;
    /// 置空下行网络监测结果
    self.downResult = nil;
    /// 置空网络连接状况结果
    self.connectResult = nil;
    /// 设置操作按钮标题
    [self.startButton setTitle:@"立即测试" forState:UIControlStateNormal];
}

#pragma mark - 网络检测完成事件
/// 网络检测完成事件
/// @param uploadResult 上行网络状况
/// @param downResult 下行网络状况
/// @param connectResult 网络连接状况
- (void)onNetworkFinshed:(nullable VCSSpeedTestResult *)uploadResult downResult:(nullable VCSSpeedTestResult *)downResult connectResult:(VCSSpeedTestConnectResult *)connectResult {
    
    /// 隐藏检测等待指示视图
    self.waitingView.hidden = YES;
    /// 标记网络检测已完成
    self.isNetworkFinish = YES;
    /// 保存上行网络监测结果
    self.uploadResult = uploadResult;
    /// 保存下行网络监测结果
    self.downResult = downResult;
    /// 保存网络连接状况结果
    self.connectResult = connectResult;
    /// 设置操作按钮标题
    [self.startButton setTitle:@"重新检测" forState:UIControlStateNormal];
    /// 刷新列表显示结果
    [self.tableView reloadData];
}

#pragma mark --------------- TableView的代理方法 ---------------
#pragma mark 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isNetworkFinish) {
        if (section == 0) {
            return 5;
        } else if (section == 1) {
            return (self.uploadResult && self.connectResult.internetConnect) ? 7 : 0;
        } else {
            return (self.downResult && self.connectResult.internetConnect) ? 7 : 0;
        }
    } else {
        return 1;
    }
}

#pragma mark 菜单头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return FWSpeedTestTableSectionHeaderViewH;
}

#pragma mark 菜单脚部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

#pragma mark 每个Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isNetworkFinish) {
        return 50.0;
    } else {
        if (indexPath.section == 1) {
            return self.isUpSpeed ? 150.0 : 50.0;
        } else if (indexPath.section == 2) {
            return self.isDownSpeed ? 150.0 : 50.0;
        } else {
            return 50.0;
        }
    }
}

#pragma mark 初始化Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isNetworkFinish) {
        if ((indexPath.section == 1 || indexPath.section == 2) && indexPath.row == 0) {
            FWSpeedTestResultHeaderTableViewCell *rCell = [FWSpeedTestResultHeaderTableViewCell cellWithTableView:tableView];
            [self configSpeedTestResultHeaderCell:rCell atIndexPath:indexPath];
            return rCell;
        } else {
            FWSpeedTestResultTableViewCell *rCell = [FWSpeedTestResultTableViewCell cellWithTableView:tableView];
            [self configSpeedTestResultCell:rCell atIndexPath:indexPath];
            return rCell;
        }
    } else {
        if (indexPath.section == 0) {
            FWSpeedTestTableViewCell *rCell = [FWSpeedTestTableViewCell cellWithTableView:tableView];
            [self configSpeedTestCell:rCell atIndexPath:indexPath];
            return rCell;
        } else {
            FWSpeedTestSpeedTableViewCell *rCell = [FWSpeedTestSpeedTableViewCell cellWithTableView:tableView];
            [self configSpeedTestSpeedCell:rCell atIndexPath:indexPath];
            return rCell;
        }
    }
}

#pragma mark 设置Cell内容
- (void)configSpeedTestCell:(FWSpeedTestTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupWithTitleLabel:@"测试时间"];
    WeakSelf();
    /// 选中时间回调
    [cell selectedBlock:^(int duration) {
        weakSelf.duration = duration;
    }];
}

#pragma mark 设置Cell内容
- (void)configSpeedTestSpeedCell:(FWSpeedTestSpeedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        [cell setupWithTitleLabel:@"上行码率" isSwitch:self.isUpSpeed upSpeed:YES];
    } else if (indexPath.section == 2) {
        [cell setupWithTitleLabel:@"下行码率" isSwitch:self.isDownSpeed upSpeed:NO];
    }
    WeakSelf();
    /// 按钮切换回调
    [cell switchChangeBlock:^(BOOL isSwitch, BOOL upSpeed) {
        if (upSpeed) {
            /// 操作上行检测状态
            weakSelf.isUpSpeed = isSwitch;
        } else {
            /// 操作下行检测状态
            weakSelf.isDownSpeed = isSwitch;
        }
        /// 刷新列表显示
        [weakSelf.tableView reloadData];
    }];
    /// 速率变更回调
    [cell speedChangeBlock:^(int speed, BOOL upSpeed) {
        if (upSpeed) {
            /// 保存上行检测速率
            weakSelf.upSpeed = speed;
        } else {
            /// 操作下行检测速率
            weakSelf.downSpeed = speed;
        }
    }];
}

#pragma mark 设置Cell内容
- (void)configSpeedTestResultHeaderCell:(FWSpeedTestResultHeaderTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *titleStr;
    if (indexPath.section == 1) {
        titleStr = [NSString stringWithFormat:@"上行码率 %dM", self.upSpeed];
    } else {
        titleStr = [NSString stringWithFormat:@"下行码率 %dM", self.downSpeed];
    }
    [cell setupWithTitleText:titleStr];
}

#pragma mark 设置Cell内容
- (void)configSpeedTestResultCell:(FWSpeedTestResultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor *textColor = FWSpeedTestResultDefaultRGB;
    NSString *titleStr;
    NSString *valueStr;
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                titleStr = @"测试执行时间";
                valueStr = [NSString stringWithFormat:@"%dS", self.duration];
            } else if (indexPath.row == 1) {
                titleStr = @"端到端环回延迟";
                if (!self.connectResult.internetConnect || !self.connectResult.streamConnect) {
                    valueStr = @"无法到达";
                    textColor = FWSpeedTestResultWarnRGB;
                } else {
                    if (self.connectResult.delay <= 0) {
                        valueStr = @"--";
                        textColor = FWSpeedTestResultWarnRGB;
                    } else {
                        valueStr = [NSString stringWithFormat:@"%ldms", self.connectResult.delay];
                    }
                }
            } else if (indexPath.row == 2) {
                titleStr = @"互联网连接情况";
                valueStr = self.connectResult.internetConnect ? @"正常" : @"异常";
                textColor = self.connectResult.internetConnect ? FWSpeedTestResultNormalRGB : FWSpeedTestResultWarnRGB;
            } else if (indexPath.row == 3) {
                titleStr = @"信令服务器连接情况";
                valueStr = self.connectResult.signalingConnect ? @"正常" : @"异常";
                textColor = self.connectResult.signalingConnect ? FWSpeedTestResultNormalRGB : FWSpeedTestResultWarnRGB;
            } else if (indexPath.row == 4) {
                titleStr = @"流媒体服务器连接情况";
                valueStr = self.connectResult.streamConnect ? @"正常" : @"异常";
                textColor = self.connectResult.streamConnect ? FWSpeedTestResultNormalRGB : FWSpeedTestResultWarnRGB;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 1) {
                titleStr = @"网络状况";
                switch (self.uploadResult.state) {
                    case VCSNetworkStateNormal:
                        valueStr = @"良好";
                        textColor = FWSpeedTestResultNormalRGB;
                        break;
                    case VCSNetworkStatePoor:
                        valueStr = @"不佳";
                        textColor = FWSpeedTestResultWarnRGB;
                        break;
                    case VCSNetworkStateBad:
                        valueStr = @"较差";
                        textColor = FWSpeedTestResultWarnRGB;
                        break;
                    case VCSNetworkStateVeryBad:
                        valueStr = @"极差";
                        textColor = FWSpeedTestResultWarnRGB;
                        break;
                    default:
                        break;
                }
            } else if (indexPath.row == 2) {
                titleStr = @"服务接收到的包";
                valueStr = [NSString stringWithFormat:@"%ld", self.uploadResult.recv];
            } else if (indexPath.row == 3) {
                titleStr = @"服务端接收到的包错序数";
                valueStr = [NSString stringWithFormat:@"%ld", self.uploadResult.miss];
            } else if (indexPath.row == 4) {
                titleStr = @"丢包数";
                valueStr = [NSString stringWithFormat:@"%ld", self.uploadResult.losf];
            } else if (indexPath.row == 5) {
                titleStr = @"平均码率kbps";
                valueStr = [NSString stringWithFormat:@"%ld", self.uploadResult.speed];
            } else if (indexPath.row == 6) {
                titleStr = @"上行丢包率";
                valueStr = [NSString stringWithFormat:@"%.2f%%", self.uploadResult.dropRate * 100];
            }
        }
            break;
        case 2: {
            if (indexPath.row == 1) {
                titleStr = @"网络状况";
                switch (self.downResult.state) {
                    case VCSNetworkStateNormal:
                        valueStr = @"良好";
                        textColor = FWSpeedTestResultNormalRGB;
                        break;
                    case VCSNetworkStatePoor:
                        valueStr = @"不佳";
                        textColor = FWSpeedTestResultWarnRGB;
                        break;
                    case VCSNetworkStateBad:
                        valueStr = @"较差";
                        textColor = FWSpeedTestResultWarnRGB;
                        break;
                    case VCSNetworkStateVeryBad:
                        valueStr = @"极差";
                        textColor = FWSpeedTestResultWarnRGB;
                        break;
                    default:
                        break;
                }
            } else if (indexPath.row == 2) {
                titleStr = @"服务接收到的包数";
                valueStr = [NSString stringWithFormat:@"%ld", self.downResult.recv];
            } else if (indexPath.row == 3) {
                titleStr = @"服务端接收到的包错序数";
                valueStr = [NSString stringWithFormat:@"%ld", self.downResult.miss];
            } else if (indexPath.row == 4) {
                titleStr = @"丢包数";
                valueStr = [NSString stringWithFormat:@"%ld", self.downResult.losf];
            } else if (indexPath.row == 5) {
                titleStr = @"平均码率kbps";
                valueStr = [NSString stringWithFormat:@"%ld", self.downResult.speed];
            } else if (indexPath.row == 6) {
                titleStr = @"下行丢包率";
                valueStr = [NSString stringWithFormat:@"%.2f%%", self.downResult.dropRate * 100];
            }
        }
            break;
        default:
            break;
    }
    /// 赋值显示
    [cell setupWithTitleText:titleStr valueText:valueStr textColor:textColor];
}

#pragma mark Cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 停止网络测速
    [[VCSSpeedTest sharedInstance] stopSpeedTest];
    /// 资源销毁
    [[VCSSpeedTest sharedInstance] destroy];
}

@end
