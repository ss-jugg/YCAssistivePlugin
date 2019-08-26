//
//  YCConsoleLoggerViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/8/26.
//

#import "YCConsoleLoggerViewController.h"
#import <Masonry/Masonry.h>
#import <YCLogger/YCLogger.h>
#import "YCConsoleLoggerCell.h"

@interface YCConsoleLoggerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YCConsoleLoggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottomMargin);
    }];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YCLoggerManager shareManager].loggerModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCConsoleLoggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCConsoleLoggerCell"];
    if (!cell) {
        cell = [[YCConsoleLoggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCConsoleLoggerCell"];
    }
    YCConsoleLoggerModel *model = [YCLoggerManager shareManager].loggerModels[indexPath.row];
    [cell bindDescribeValue:[model description]];
    return cell;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}
@end
