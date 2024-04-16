//
//  FWHomeViewController.m
//  VCSModuleExample
//
//  Created by SailorGa on 2024/3/14.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWHomeViewController.h"
#import "FWHomeTableViewCell.h"
#import "FWLoginModel.h"

@interface FWHomeViewController ()

/// 列表视图
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 列表数据
@property (nonatomic, copy) NSArray *listData;
/// 登录信息
@property (nonatomic, strong) FWLoginModel *loginModel;

@end

@implementation FWHomeViewController

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置标题
    self.navigationItem.title = @"首页模块";
    /// 获取登录信息
    self.loginModel = (FWLoginModel *)self.info;
    /// 创建列表数据
    self.listData = @[
        @{@"type": @(0), @"title": @"呼叫组件"},
        @{@"type": @(1), @"title": @"会控组件"}];
    /// 注册列表单元
    [self.tableView registerNib:[UINib nibWithNibName:@"FWHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"FWHomeTableViewCell"];
}


#pragma mark - ------ UITableView 的代理方法 ------
#pragma mark 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listData.count;
}

#pragma mark 每个单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

#pragma mark 创建列表单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellReuseIdentifier = @"FWHomeTableViewCell";
    FWHomeTableViewCell *rCell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!rCell) {
        rCell = [[FWHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    /// 获取单元格关联信息
    NSDictionary *info = [self.listData objectAtIndex:indexPath.row];
    /// 获取标题
    NSString *title = [info objectForKey:@"title"];
    /// 设置显示标题
    [rCell.describeLabel setText:title];
    /// 返回单元格
    return rCell;
}

#pragma mark 单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    /// 获取单元格关联信息
    NSDictionary *info = [self.listData objectAtIndex:indexPath.row];
    /// 获取类型
    NSInteger type = [[info objectForKey:@"type"] integerValue];
    /// 根据类型进入不同组件页面
    switch (type) {
        case 0:
            /// 跳转呼叫组件视图
            [self push:@"FWMeetingCallViewController" info:self.loginModel block:nil];
            break;
        case 1:
            /// 跳转会控组件视图
            [self push:@"FWMeetingControlViewController" info:self.loginModel block:nil];
            break;
        default:
            break;
    }
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 退出登录
    [[VCSMeetLogin sharedInstance] logout];
}

@end
