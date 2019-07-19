//
//  YCAssistiveHttpViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import "YCAssistiveHttpViewController.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveHttpPlugin.h"
#import "YCAssistiveHttpModel.h"
#import "YCAssistiveMacro.h"
#import "YCAssistiveHttpCell.h"
#import "UIColor+AssistiveColor.h"
#import "YCAssistiveHttpDetailViewController.h"

@interface YCAssistiveHttpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation YCAssistiveHttpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottomMargin);
    }];
    [self.tableView reloadData];
    [self as_setRightBarItemTitle:@"清空"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHttpData) name:kAssistiveHttpNotificationName object:nil];
}

- (void)reloadHttpData {
    
    [self.tableView reloadData];
}

- (void)as_viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    
    [self.dataSource removeAllObjects];
    [[YCAssistiveHttpPlugin sharedInstance] clearAll];
    [self.tableView reloadData];
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
        NSMutableArray *datas = [NSMutableArray arrayWithArray:[YCAssistiveHttpPlugin sharedInstance].httpModels];
        _dataSource = [[[datas reverseObjectEnumerator] allObjects] mutableCopy];
    }
    return _dataSource;
}
@end
