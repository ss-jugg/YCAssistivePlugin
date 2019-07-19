//
//  YCAssistiveSettingViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/19.
//

#import "YCAssistiveSettingViewController.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveSettingCell.h"
#import "YCAssistiveSettingModel.h"
#import "YCAssistiveLeaksManager.h"
@interface YCAssistiveSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *settings;

@end

@implementation YCAssistiveSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self setupSettings];
}

- (void)setupSettings {
    
    self.settings = @[[YCAssistiveSettingModel settingModelWithTitle:@"是否开启内存检测" detail:@"开启内存检测，若出现内存泄漏，会弹框提示，同事记录泄漏信息，在leak页面可查看"],
                      [YCAssistiveSettingModel settingModelWithTitle:@"是否开启循环引用检测" detail:@"开启循环引用后，会自动开启内存检测"]];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCAssistiveSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCAssistiveSettingCell"];
    if (!cell) {
        cell = [[YCAssistiveSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCAssistiveSettingCell"];
    }
    YCAssistiveSettingModel *model = self.settings[indexPath.row];
    [cell bindSettingModel:model];
    [cell.switchSignal subscribeNext:^(id  _Nullable x) {
        model.isOn = [x boolValue];
        if (indexPath.row == 0) {
            [YCAssistiveLeaksManager shareManager].enableLeaks = [x boolValue];
            if (![x boolValue]) {
                [YCAssistiveLeaksManager shareManager].enableRetainCycle = NO;
            }
        }else {
            [YCAssistiveLeaksManager shareManager].enableRetainCycle = [x boolValue];
            if ([x boolValue]) {
                [YCAssistiveLeaksManager shareManager].enableLeaks = YES;
            }
        }
    }];
    return cell;
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
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}

@end
