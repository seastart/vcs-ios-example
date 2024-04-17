//
//  FWSpeedTestSpeedTableViewCell.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWSpeedTestSpeedTableViewCell.h"
#import "FWSpeedTestSpeedCollectionViewCell.h"

/// 定义TableViewCell重用标识
static NSString *FWSpeedTestSpeedTableViewCellName = @"FWSpeedTestSpeedTableViewCell";
/// 定义CollectionViewCell重用标识
static NSString *FWSpeedTestSpeedCollectionViewCellName = @"FWSpeedTestSpeedCollectionViewCell";

/// 声明数据源
#define dataArray @[@"1", @"2", @"4", @"6", @"8", @"12"]

@interface FWSpeedTestSpeedTableViewCell() <UICollectionViewDataSource, UICollectionViewDelegate>

/// collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 切换按钮
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

/// 标识是否为上行码率检测
@property (nonatomic, assign) BOOL upSpeed;
/// 选中索引
@property (nonatomic, assign) NSInteger selectedIndex;

/// 转换按钮回调
@property (copy, nonatomic) FWSpeedTestSpeedSwitchChangeBlock switchChangeBlock;
/// 速率变更回调
@property (copy, nonatomic) FWSpeedTestSpeedChangeBlock speedChangeBlock;

@end

@implementation FWSpeedTestSpeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    /// Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    /// 先去缓存池找可重用的cell
    FWSpeedTestSpeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWSpeedTestSpeedTableViewCellName];
    /// 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:FWSpeedTestSpeedTableViewCellName owner:nil options:nil] lastObject];
        /// 配置属性
        [cell stepConfig];
    }
    return cell;
}

#pragma mark - 页面重新绘制
/// 页面重新绘制
- (void)layoutSubviews {
    
    [super layoutSubviews];
    /// 刷新列表布局
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - 配置属性
- (void)stepConfig {
    
    /// 设置默认数据
    [self setupDefaultData];
    /// 设置CollectionView
    [self setupCollectionView];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
/// 设置默认数据
- (void)setupDefaultData {
    
    /// 默认选中索引
    self.selectedIndex = 1;
}

#pragma mark - 设置CollectionView
/// 设置CollectionView
- (void)setupCollectionView {
    
    /// 设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    /// 注册Cell
    [self.collectionView registerClass:[FWSpeedTestSpeedCollectionViewCell class] forCellWithReuseIdentifier:FWSpeedTestSpeedCollectionViewCellName];
}

#pragma mark - 绑定动态响应信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定切换按钮事件
    [[self.switchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable control) {
        @strongify(self);
        if (self.switchChangeBlock) {
            self.switchChangeBlock(!control.selected, self.upSpeed);
        }
    }];
}

#pragma mark - 赋值显示
/// 赋值显示
/// @param titleLabel 标题
/// @param isSwitch 开关状态
/// @param upSpeed 标识是否为上行码率检测
- (void)setupWithTitleLabel:(nullable NSString *)titleLabel isSwitch:(BOOL)isSwitch upSpeed:(BOOL)upSpeed {
    
    /// 标识是否为上行码率检测
    self.upSpeed = upSpeed;
    /// 设置显示
    self.titleLabel.text = titleLabel;
    /// 设置开关状态
    self.switchButton.selected = isSwitch;
    /// 确定是否显示码率选择视图
    self.collectionView.hidden = !isSwitch;
}

#pragma mark - 转换按钮回调
/// 转换按钮回调
/// @param switchChangeBlock 转换按钮回调
- (void)switchChangeBlock:(FWSpeedTestSpeedSwitchChangeBlock)switchChangeBlock {
    
    self.switchChangeBlock = switchChangeBlock;
}

#pragma mark - 速率变更回调
/// 速率变更回调
/// @param speedChangeBlock 速率变更回调
- (void)speedChangeBlock:(FWSpeedTestSpeedChangeBlock)speedChangeBlock {
    
    self.speedChangeBlock = speedChangeBlock;
}

#pragma mark - ----- CollectionView&UICollectionViewDataSource的代理方法 -----
#pragma mark 分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

#pragma mark 每组Cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return dataArray.count;
}

#pragma mark 设置每个Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.collectionView.frame.size.width - 60) / 3.f, 35);
}

#pragma mark 设置内容整体边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 15, 0, 15);
}

#pragma mark 初始化Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FWSpeedTestSpeedCollectionViewCell *rCell = [collectionView dequeueReusableCellWithReuseIdentifier:FWSpeedTestSpeedCollectionViewCellName forIndexPath:indexPath];
    /// 赋值显示
    [rCell setupWithSelected:(self.selectedIndex == indexPath.row) titleText:[NSString stringWithFormat:@"%@Mbps", [dataArray objectAtIndex:indexPath.row]]];
    return rCell;
}

#pragma mark Cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /// 设置选中索引
    self.selectedIndex = indexPath.row;
    /// 回调上层
    if (self.speedChangeBlock) {
        /// 转换单位
        int speed = [[dataArray objectAtIndex:indexPath.row] intValue];
        self.speedChangeBlock(speed, self.upSpeed);
    }
    /// 刷新列表
    [self.collectionView reloadData];
}

@end
