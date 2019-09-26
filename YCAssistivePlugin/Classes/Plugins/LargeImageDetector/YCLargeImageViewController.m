//
//  YCLargeImageViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import "YCLargeImageViewController.h"
#import "YCLargeImageInterceptor.h"
#import "YCLargeImageCell.h"
#import "UIViewController+AssistiveUtil.h"
#import <Masonry/Masonry.h>

@interface YCLargeImageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YCLargeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self as_setNavigationBarTitle:@"大图检测"];
    [self as_setLeftBarItemTitle:@"关闭"];
    [self as_setRightBarItemTitle:@"清空"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController {
    
    [self pluginWindowDidClosed];
}

- (void)as_viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    [[YCLargeImageInterceptor shareInterceptor] removeAllImages];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YCLargeImageInterceptor shareInterceptor].images.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YCLargeImageCell largeImageCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCLargeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCLargeImageCell"];
    if (!cell) {
        cell = [[YCLargeImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCLargeImageCell"];
    }
    YCLargeImageModel *model = [YCLargeImageInterceptor shareInterceptor].images[indexPath.row];
    [cell renderUIWithModel:model];
    return cell;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
