//
//  YCLoggerViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/8/26.
//

#import "YCLoggerViewController.h"
#import <Masonry/Masonry.h>
#import "YCLoggerCell.h"
#import "YCConsoleLoggerViewController.h"
#import "YCAssistiveCrashViewController.h"

@interface YCLoggerViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 列表 */
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YCLoggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottomMargin);
    }];
    [self.tableView reloadData];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCLoggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCLoggerCell"];
    if (!cell) {
        cell = [[YCLoggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCLoggerCell"];
    }
    if (indexPath.row == 0) {
        cell.titleLbl.text = @"调试日志";
    }
    if (indexPath.row == 1) {
        cell.titleLbl.text = @"崩溃日志";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        YCConsoleLoggerViewController *vc = [[YCConsoleLoggerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        YCAssistiveCrashViewController *vc = [[YCAssistiveCrashViewController alloc] init];
        vc.title = @"崩溃日志";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
