//
//  YCAppInfoViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAppInfoViewController.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveDefine.h"
#import "UIViewController+AssistiveUtil.h"
#import "YCAssistiveAppInfoCell.h"
#import "YCAppInfoUtil.h"

@interface YCAppInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YCAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self as_setNavigationBarTitle:@"App Info"];
    [self as_setLeftBarItemTitle:@"关闭"];
    [self initializeUI];
    [self initData];
}

- (void)initializeUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initData {
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    YCAppInfoModel *nameModel = [YCAppInfoModel modelWithName:@"设备名称" value:[YCAppInfoUtil iphoneName]];
    YCAppInfoModel *typeModel = [YCAppInfoModel modelWithName:@"手机型号" value:[YCAppInfoUtil iphoneType]];
    YCAppInfoModel *systemModel = [YCAppInfoModel modelWithName:@"系统版本" value:[YCAppInfoUtil iphoneSystemVersion]];
    [self.dataSource addObject:@{@"title":@"手机信息",@"info":@[nameModel,typeModel,systemModel]}];
    
    YCAppInfoModel *bundleModel = [YCAppInfoModel modelWithName:@"Bundle ID" value:[YCAppInfoUtil bundleIdentifier]];
    YCAppInfoModel *bundleVersionModel = [YCAppInfoModel modelWithName:@"Version" value:[YCAppInfoUtil bundleVersion]];
    YCAppInfoModel *versionModel = [YCAppInfoModel modelWithName:@"Short Version" value:[YCAppInfoUtil bundleShortVersionString]];
    [self.dataSource addObject:@{@"title":@"APP信息",@"info":@[bundleModel,bundleVersionModel,versionModel]}];
    
    YCAppInfoModel *locationModel = [YCAppInfoModel modelWithName:@"定位权限" value:[YCAppInfoUtil locationAuthority]];
    YCAppInfoModel *cameraModel = [YCAppInfoModel modelWithName:@"相机权限" value:[YCAppInfoUtil cameraAuthority]];
    YCAppInfoModel *photoModel = [YCAppInfoModel modelWithName:@"相册权限" value:[YCAppInfoUtil photoAuthority]];
    YCAppInfoModel *pushModel = [YCAppInfoModel modelWithName:@"推送权限" value:[YCAppInfoUtil pushAuthority]];
    [self.dataSource addObject:@{@"title":@"权限信息",@"info":@[locationModel,cameraModel,photoModel,pushModel]}];
    
    [self.tableView reloadData];
    
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController  {
    
    [self pluginWindowDidClosed];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataSource[section];
    return [dic[@"info"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 52.0;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCAssistiveAppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCAssistiveAppInfoCell"];
    if (!cell) {
        cell = [[YCAssistiveAppInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCAssistiveAppInfoCell"];
    }
    NSDictionary *dic = self.dataSource[indexPath.section];
    YCAppInfoModel *model = dic[@"info"][indexPath.row];
    [cell renderUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = self.dataSource[section];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_ScreenWidth, 40)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, AS_ScreenWidth-20, 40)];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont boldSystemFontOfSize:15.0];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = dic[@"title"];
    [sectionView addSubview:lbl];
    return sectionView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
    }
    return _tableView;
}

@end
