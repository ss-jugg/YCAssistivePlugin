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

@interface YCNetworkEmvironmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSArray <YCNetworkConfigurItem *> *configurItems;

@property (nonatomic, strong) YCNetworkConfigStorage *storage;

@end

@implementation YCNetworkEmvironmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试环境配置";
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonOnClicked:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonOnClicked:)];
    self.navigationItem.rightBarButtonItems = @[confirmButton];
    [self setupItemConfigursMap];
}

- (void)setupItemConfigursMap {

    self.configurItems  = @[[YCNetworkConfigurItem configurItemWithTitle:@"合伙人app" identifier:kPartnerApiKey],
                            [YCNetworkConfigurItem configurItemWithTitle:@"车商app" identifier:kDealerApiKey]];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.configurItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellID"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = self.configurItems[indexPath.row].displayText;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YCNetworkConfigurItem *item = self.configurItems[indexPath.row];
    YCNetworkEnvironmentEditViewController *detailVC = [[YCNetworkEnvironmentEditViewController alloc] initWithIdentifier:item.identifier configurs:item.configurs selectedHandler:^(NSArray<YCNetworkConfigur *> * _Nonnull configurs) {
        item.configurs = configurs;
        [self.tableView reloadData];
    }];
    
    detailVC.navigationItem.title = item.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)confirmButtonOnClicked:(UIBarButtonItem *)item {
    NSMutableArray *selectedConfigurs = [NSMutableArray array];
    
    for (YCNetworkConfigurItem *item in self.configurItems) {
        YCNetworkConfigur *selectedConfigur = nil;
        for (YCNetworkConfigur *configur in item.configurs) {
            if (configur.isSelected) {
                selectedConfigur = configur;
                [selectedConfigurs addObject:selectedConfigur];
                break;
            }
        }
        
        NSMutableArray *mconfigurs = item.configurs.mutableCopy;
        
        if (selectedConfigur) {
            [mconfigurs removeObject:selectedConfigur];
            [mconfigurs insertObject:selectedConfigur atIndex:0];
        }
        
        [self.storage setConfigurs:mconfigurs forKey:item.identifier];
    }
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOut" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)cancelButtonOnClicked:(UIBarButtonItem *)item {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
