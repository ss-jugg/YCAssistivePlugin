//
//  YCPluginFunctionView.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/26.
//

#import "YCPluginFunctionView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import "YCPluginFunctionViewModel.h"

@interface YCPluginFunctionView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YCPluginFunctionViewModel *viewModel;

@end

@implementation YCPluginFunctionView
- (instancetype)initWithViewModel:(YCPluginFunctionViewModel *)viewModel {
    
    if (self = [super init]) {
        self.viewModel = viewModel;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.functions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCPluginFunctionCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCPluginFunctionCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:9.0];
    }
    YCPluginFunctionModel *model = self.viewModel.functions[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCPluginFunctionModel *model = self.viewModel.functions[indexPath.row];
    [model.didSelectedCommand execute:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _tableView;
}
@end
