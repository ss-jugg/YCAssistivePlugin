//
//  YCAssistivePluginHomeViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import "YCAssistivePluginHomeViewController.h"
#import "YCAssistiveFunctionCell.h"
#import "UIImage+AssistiveBundle.h"
#import "UIViewController+AssistiveUtil.h"
#import "YCAssistivePluginFactory.h"

@interface YCAssistivePluginHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<YCAssistiveFunctionViewModel *> *functions;

@end

@implementation YCAssistivePluginHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self as_setNavigationBarTitle:@"测试辅助工具"];
    [self as_setLeftBarItemTitle:@"关闭"];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self.tableView reloadData];
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController {
    
    [self pluginWindowDidClosed];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.functions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YCAssistiveFunctionCell heightForCell:self.functions[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCAssistiveFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCAssistiveFunctionCell"];
    YCAssistiveFunctionViewModel *viewModel = self.functions[indexPath.row];
    [cell bindFunctionModel:viewModel];
    return cell;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100.0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[YCAssistiveFunctionCell class] forCellReuseIdentifier:@"YCAssistiveFunctionCell"];
    }
    return _tableView;
}

- (NSMutableArray<YCAssistiveFunctionViewModel *> *)functions {
    
    if (_functions == nil) {
        _functions = [YCAssistivePluginFactory homeFunctions];
    }
    return _functions;
}

@end
