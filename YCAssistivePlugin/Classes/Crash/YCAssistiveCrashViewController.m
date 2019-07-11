//
//  YCAssistiveCrashViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/4.
//

#import "YCAssistiveCrashViewController.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveCrashPlugin.h"
#import "YCAssistiveMacro.h"
#import "UIColor+AssistiveColor.h"
#import "YCAssistiveCrashCell.h"

@interface YCAssistiveCrashViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/* 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation YCAssistiveCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor as_backgroudColor];
    self.tableView.frame = CGRectMake(0, NAV_BAR_H, SCREEN_W, SCREE_SAFE_H);
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCAssistiveCrashCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCAssistiveCrashCell"];
    if (!cell) {
        cell = [[YCAssistiveCrashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCAssistiveCrashCell"];
    }
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *infoDict = self.datas[indexPath.row];
    NSString *key = infoDict[@"date"];
    if (!key) {
        return nil;
    }
    UITableViewRowAction *remove_action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"移除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    return @[];
}

//MARK:删除
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath forKey:(NSString *)key {
    
}

#pragma mark - getter
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 60.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}


- (NSMutableArray *)datas {
    
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithArray:[[YCAssistiveCrashPlugin sharedPlugin] crashLogs]];
    }
    return _datas;
}

@end
