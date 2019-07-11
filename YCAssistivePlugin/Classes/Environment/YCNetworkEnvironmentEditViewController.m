//
//  YCNetworkEnvironmentEditViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "YCNetworkEnvironmentEditViewController.h"
#import <Masonry/Masonry.h>
#import "YCNetworkConfigurItem.h"
#import "YCNetworkConfigur.h"
#import "YCNetworkConfigStorage.h"
#import "YCAssistiveMacro.h"
#import "YCNetworkEnvironment.h"

@interface YCNetworkEnvironmentEditViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <YCNetworkConfigur *> *itemConfigurs;
@property (copy, nonatomic) NSString *identifier;

@end

@implementation YCNetworkEnvironmentEditViewController

- (instancetype)initWithIdentifier:(NSString *)identifier configurs:(NSArray<YCNetworkConfigur *> *)configurs {
    
    if (self = [super init]) {
        _identifier = identifier;
        _itemConfigurs = [configurs mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self as_setRightBarItemTitle:@"确定"];
}

- (void)as_viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    
    [[YCNetworkEnvironment sharedInstance] switchEnvironmentForKey:self.identifier];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOut" object:nil];
    }];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemConfigurs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    YCNetworkConfigur *configur = self.itemConfigurs[indexPath.row];
    cell.backgroundColor = configur.selected ? [[UIColor orangeColor] colorWithAlphaComponent:0.3] : [UIColor whiteColor];
    cell.textLabel.text = configur.displayText;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger seletedIndex = 0;
    for (NSInteger idx = 0; idx < self.itemConfigurs.count; idx++) {
        self.itemConfigurs[idx].selected = idx == indexPath.row;
        if (idx == indexPath.row) {
            seletedIndex = idx;
            self.itemConfigurs[idx].app = self.identifier;
        } else {
            self.itemConfigurs[idx].app = @"";
        }
    }
    [self exchangeConfigurItemAtNewIndex:seletedIndex];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.itemConfigurs removeObjectAtIndex:indexPath.row];
        self.itemConfigurs.firstObject.selected = YES;
        [self.tableView reloadData];
    }]];
}

- (void)addConfigurButtonOnClicked {
    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:@"配置信息" message:@"确认配置信息(地址/ID等)" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.placeholder = @"输入配置信息(地址/ID等)";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.placeholder = @"输入描述(可选，备忘)";
    }];
    __weak typeof(alertController) walertController = alertController;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        YCNetworkConfigur *configur = [YCNetworkConfigur configurWithAddress:walertController.textFields.firstObject.text remark:walertController.textFields.lastObject.text];
        configur.app = self.identifier;
        if (![configur isValid]) {
            return;
        }
        for (YCNetworkConfigur *conf in self.itemConfigurs) {
            conf.selected = NO;
        }
        configur.selected = YES;
        [self.itemConfigurs insertObject:configur atIndex:0];
        
        [self exchangeConfigurItemAtNewIndex:0];
    }];
    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (UIButton *)tableFooterView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:@" ➕ 添加 " forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addConfigurButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = (CGRect){
        .origin = CGPointZero,
        .size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50)
    };
    return button;
}

#pragma mark - exchange item
- (void)exchangeConfigurItemAtNewIndex:(NSInteger)index {
    
    [self.itemConfigurs exchangeObjectAtIndex:0 withObjectAtIndex:index];
    [[YCNetworkConfigStorage sharedInstance] setConfigurs:self.itemConfigurs forKey:self.identifier];
    [self.tableView reloadData];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_BAR_H, SCREEN_W, SCREE_SAFE_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.tableFooterView = [self tableFooterView];
    }
    
    return _tableView;
}

@end
