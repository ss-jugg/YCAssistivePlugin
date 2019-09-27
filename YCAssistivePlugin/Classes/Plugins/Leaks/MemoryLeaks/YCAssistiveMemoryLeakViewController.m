//
//  YCAssistiveMemoryLeakViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/17.
//

#import "YCAssistiveMemoryLeakViewController.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveLeaksManager.h"
#import "YCAssistiveMemoryLeakCell.h"
#import "UIViewController+AssistiveUtil.h"

@interface YCAssistiveMemoryLeakViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YCAssistiveMemoryLeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self as_setNavigationBarTitle:@"内存泄漏"];
    [self as_setLeftBarItemTitle:@"关闭"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottomMargin);
    }];
    [self.tableView reloadData];
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController {
    [self pluginWindowDidClosed];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCAssistiveMemoryLeakCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCAssistiveMemoryLeakCell"];
    if (!cell) {
        cell = [[YCAssistiveMemoryLeakCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCAssistiveMemoryLeakCell"];
    }
    [cell bindModel:self.datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - getter
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60.0;
    }
    return _tableView;
}
- (NSMutableArray *)datas {
    
    if (_datas == nil) {
        _datas = [YCAssistiveLeaksManager shareManager].leakObjects;
        
    }
    return _datas;
}
@end
