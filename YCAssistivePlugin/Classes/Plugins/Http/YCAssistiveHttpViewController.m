//
//  YCAssistiveHttpViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import "YCAssistiveHttpViewController.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveNetworkManager.h"
#import "YCAssistiveHttpModel.h"
#import "YCAssistiveMacro.h"
#import "YCAssistiveHttpCell.h"
#import "UIColor+AssistiveColor.h"
#import "YCAssistiveHttpDetailViewController.h"
#import "UIViewController+AssistiveUtil.h"
#import "UIView+AssistiveUtils.h"
#import "YCAssistiveSearchView.h"
#import "YCAssistiveDefine.h"

@interface YCAssistiveHttpViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) YCAssistiveSearchView *searchView;
@end

@implementation YCAssistiveHttpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    [self.tableView reloadData];
}

- (void)initialUI {
    
    self.searchView = [[YCAssistiveSearchView alloc] initWithFrame:CGRectMake(0, 0, AS_ScreenWidth, 44)];
    weak(self);
    [self.searchView setSearchBlock:^(NSString * _Nonnull text) {
        strong(self);
        [self searchHttpModel:text];
    }];
    [self.view addSubview:self.searchView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottomMargin);
    }];
    [self as_setLeftBarItemTitle:@"关闭"];
    [self as_setRightBarItemTitle:@"清空"];
}

- (void)as_viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    
    [self.dataSource removeAllObjects];
    [[YCAssistiveNetworkManager shareManager] clearAll];
    [self.tableView reloadData];
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController  {
    
    [self pluginWindowDidClosed];
}

- (void)searchHttpModel:(NSString *)key {
    
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    NSMutableArray *originModels = [YCAssistiveNetworkManager shareManager].httpModels;
    [originModels enumerateObjectsUsingBlock:^(YCAssistiveHttpModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.url.absoluteString.lowercaseString containsString:key.lowercaseString] || key.length == 0) {
            [datas addObject:obj];
        }
    }];
    self.dataSource = [[[datas reverseObjectEnumerator] allObjects] mutableCopy];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YCAssistiveHttpCell heightForHttpCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCAssistiveHttpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCAssistiveHttpCell"];
    YCAssistiveHttpModel *httpModel = self.dataSource[indexPath.row];
    [cell bindHttpModel:httpModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCAssistiveHttpModel *model = self.dataSource[indexPath.row];
    YCAssistiveHttpDetailViewController *detailVC = [[YCAssistiveHttpDetailViewController alloc] initWithHttpModel:model];
    [detailVC setReadHttpBlock:^{
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0.01)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[YCAssistiveHttpCell class] forCellReuseIdentifier:@"YCAssistiveHttpCell"];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataSource {
    
    if (_dataSource == nil) {
        NSMutableArray *datas = [NSMutableArray arrayWithArray:[YCAssistiveNetworkManager shareManager].httpModels];
        _dataSource = [[[datas reverseObjectEnumerator] allObjects] mutableCopy];
    }
    return _dataSource;
}

@end
