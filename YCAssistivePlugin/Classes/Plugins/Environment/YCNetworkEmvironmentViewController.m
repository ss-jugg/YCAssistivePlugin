//
//  YCNetworkEmvironmentViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "YCNetworkEmvironmentViewController.h"
#import "YCNetworkConfigur.h"
#import "YCNetworkConfigurItem.h"
#import "YCNetworkConfigStorage.h"
#import "YCNetworkEnvironmentEditViewController.h"
#import "YCNetworkEnvironment.h"
#import "YCAssistiveMacro.h"
#import "YCNetworkEnvironmentCell.h"
#import "YCNetworkEnvironment.h"
#import "UIViewController+AssistiveUtil.h"

@interface YCNetworkEmvironmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSArray <YCNetworkConfigurItem *> *configurItems;

@property (nonatomic, strong) YCNetworkConfigStorage *storage;

@end

@implementation YCNetworkEmvironmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self as_setNavigationBarTitle:@"测试环境配置"];
    [self as_setLeftBarItemTitle:@"关闭"];
    [self as_setRightBarItemTitle:@"确定"];
    
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    [self setupItemConfigursMap];
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController {
    [self pluginWindowDidClosed];
}

- (void)setupItemConfigursMap {

    self.configurItems  = @[[YCNetworkConfigurItem configurItemWithTitle:@"测试环境配置" identifier:kAppEnvironmentApiKey]];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.configurItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YCNetworkEnvironmentCell heightFoNetworkCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCNetworkEnvironmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCNetworkEnvironmentCell"];
    if (!cell) {
        cell = [[YCNetworkEnvironmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCNetworkEnvironmentCell"];
    }
    YCNetworkConfigurItem *item = self.configurItems[indexPath.row];
    cell.titleLbl.text = item.title;
    cell.detailLbl.text = item.displayText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YCNetworkConfigurItem *item = self.configurItems[indexPath.row];
    YCNetworkEnvironmentEditViewController *detailVC = [[YCNetworkEnvironmentEditViewController alloc] initWithIdentifier:item.identifier configurs:item.configurs];
    detailVC.navigationItem.title = item.title;
    [detailVC setSelectHandler:^(NSMutableArray<YCNetworkConfigur *> *configs) {
        [self exchangeConfigBySelected:configs];
        item.configurs = configs;
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)exchangeConfigBySelected:(NSMutableArray<YCNetworkConfigur *> *)configs {
    
    __block NSInteger index = 0;
    [configs enumerateObjectsUsingBlock:^(YCNetworkConfigur * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index > 0) {
        YCNetworkConfigur *config = configs[index];
        [configs removeObjectAtIndex:index];
        [configs insertObject:config atIndex:0];
    }
    [self.tableView reloadData];
}

#pragma mark - 导航栏事件
- (void)as_viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    
    [self.configurItems enumerateObjectsUsingBlock:^(YCNetworkConfigurItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.storage setConfigurs:obj.configurs forKey:obj.identifier];
        [[YCNetworkEnvironment sharedInstance] switchEnvironmentForKey:obj.identifier];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOut" object:nil];
    [self pluginWindowDidClosed];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0.01)];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}

- (YCNetworkConfigStorage *)storage {
    
    return [YCNetworkConfigStorage sharedInstance];
}

@end
