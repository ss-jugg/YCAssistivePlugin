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
#import "YCAssistiveCache.h"
#import "YCLargeImageInterceptor.h"
#import "YCViewFrameManager.h"
#import "UIViewController+AssistiveUtil.h"
//#import <YCLogger/YCLogger.h>

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
    [self as_setNavigationBarTitle:@"设置"];
    [self as_setLeftBarItemTitle:@"关闭"];
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController {
    
    [self pluginWindowDidClosed];
}

- (void)setupSettings {
    
    YCAssistiveSettingModel *leakModel = [YCAssistiveSettingModel settingModelWithTitle:@"是否开启内存检测" detail:@"默认关闭；开启内存检测，若出现内存泄漏，会弹框提示，同时记录泄漏信息，在【泄漏检测】可查看。"];
    leakModel.isOn = [[YCAssistiveCache shareInstance] leakDetectionSwitch];
    [leakModel.switchSignal subscribeNext:^(id  _Nullable x) {
        [YCAssistiveLeaksManager shareManager].enableLeaks = [x boolValue];
        [[YCAssistiveCache shareInstance] saveLeakDetectionSwitch:[x boolValue]];
    }];
    
    YCAssistiveSettingModel *largeImageModel = [YCAssistiveSettingModel settingModelWithTitle:@"是否开启大图检测" detail:@"默认关闭；开启大图检测，若图片超过指定大小会被标记，同时记录图片，在【大图检测】可查看。"];
    largeImageModel.isOn = [[YCAssistiveCache shareInstance] largeImageDetectionSwitch];
    [largeImageModel.switchSignal subscribeNext:^(id  _Nullable x) {
        [[YCLargeImageInterceptor shareInterceptor] setCanIntercept:[x boolValue]];
        [[YCAssistiveCache shareInstance] saveLargeImageDetectionSwitch:[x boolValue]];
    }];
    
    YCAssistiveSettingModel *viewFrameModel = [YCAssistiveSettingModel settingModelWithTitle:@"是否展示视图边框" detail:@" 默认关闭；开启视图边框，可绘制UI组件的边框。"];
    viewFrameModel.isOn = [[YCAssistiveCache shareInstance] viewFrameSwitch];
    [viewFrameModel.switchSignal subscribeNext:^(id  _Nullable x) {
        [[YCViewFrameManager defaultManager] setEnable:[x boolValue]];
        [[YCAssistiveCache shareInstance] saveViewFrameSwitch:[x boolValue]];
    }];
    
//    YCAssistiveSettingModel *apiLoggerModel = [YCAssistiveSettingModel settingModelWithTitle:@"是否打印网络请求日志" detail:@"默认关闭；开启后可在控制台查看网络日志"];
//    apiLoggerModel.isOn = [[YCAssistiveCache shareInstance] APILoggerSwitch];
//    [apiLoggerModel.switchSignal subscribeNext:^(id  _Nullable x) {
//        YCAPILoggerEnabled = [x boolValue];
//        [[YCAssistiveCache shareInstance] saveAPILoggerSwitch:[x boolValue]];
//    }];
    self.settings = @[leakModel,largeImageModel,viewFrameModel];

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
