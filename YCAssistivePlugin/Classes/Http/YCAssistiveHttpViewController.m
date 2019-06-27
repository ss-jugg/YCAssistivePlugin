//
//  YCAssistiveHttpViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import "YCAssistiveHttpViewController.h"
#import "YCAssistiveHttpHelper.h"
#import "YCAssistiveHttpModel.h"
#import "YCAssistiveMacro.h"

@interface YCAssistiveHttpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YCAssistiveHttpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tableView.frame = CGRectMake(0, NAV_BAR_H, SCREEN_W, SCREE_SAFE_H);
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YCAssistiveHttpHelper sharedInstance].httpModels.count;
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
    YCAssistiveHttpModel *httpModel = [YCAssistiveHttpHelper sharedInstance].httpModels[indexPath.row];
    cell.textLabel.text = httpModel.url.host;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.detailTextLabel.text = httpModel.url.path;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0.01)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}

@end
