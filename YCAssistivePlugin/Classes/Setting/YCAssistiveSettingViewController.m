//
//  YCAssistiveSettingViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/19.
//

#import "YCAssistiveSettingViewController.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveMacro.h"
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
    
    YCAssistiveSettingModel *leakModel = [YCAssistiveSettingModel settingModelWithTitle:@"是否开启内存检测" detail:@"开启内存检测，若出现内存泄漏，会弹框提示，同事记录泄漏信息，在leak页面可查看"];
    leakModel.isOn = [[NSUserDefaults standardUserDefaults] objectForKey:kYCAssistiveMemoryLeakKey];
    YCAssistiveSettingModel *retainCycleModel = [YCAssistiveSettingModel settingModelWithTitle:@"是否开启循环引用检测" detail:@"开启循环引用后，会自动开启内存检测"];
    retainCycleModel.isOn = [[NSUserDefaults standardUserDefaults] objectForKey:kYCAssistiveRetainCycleKey];
    
    self.settings = @[leakModel,retainCycleModel];

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
    weak(self);
    [cell.switchSignal subscribeNext:^(id  _Nullable x) {
        strong(self);
        [self changedAtIndexPath:indexPath switchOn:[x boolValue]];
    }];
    return cell;
}

- (void)changedAtIndexPath:(NSIndexPath *)indexPath switchOn:(BOOL)isOn {
    
    YCAssistiveSettingModel *model = self.settings[indexPath.row];
    model.isOn = isOn;
    if (indexPath.row == 0) {
        [YCAssistiveLeaksManager shareManager].enableLeaks = isOn;
        [[NSUserDefaults standardUserDefaults] setObject:@(isOn) forKey:kYCAssistiveMemoryLeakKey];
        if (!isOn) {
            [YCAssistiveLeaksManager shareManager].enableRetainCycle = NO;
            YCAssistiveSettingModel *nextModel = self.settings[1];
            nextModel.isOn = NO;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:kYCAssistiveRetainCycleKey];
        }
    }
    if (indexPath.row == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@(isOn) forKey:kYCAssistiveRetainCycleKey];
        [YCAssistiveLeaksManager shareManager].enableRetainCycle = isOn;
        if (isOn) {
            YCAssistiveSettingModel *preModel = self.settings[0];
            preModel.isOn = YES;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kYCAssistiveMemoryLeakKey];
        }
    }
    
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
