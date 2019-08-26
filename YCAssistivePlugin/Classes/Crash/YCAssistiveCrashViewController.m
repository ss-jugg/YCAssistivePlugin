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
#import "YCAssistiveContentViewController.h"

@interface YCAssistiveCrashViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/* 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation YCAssistiveCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"奔溃日志";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottomMargin);
    }];
    [self.tableView reloadData];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    for (UIView *subView in self.tableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
            CGRect frame = subView.frame;
            subView.frame = CGRectMake(frame.origin.x, frame.origin.y+12, CGRectGetWidth(frame), CGRectGetHeight(frame)-12);
        }
    }
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
    [cell bindDict:self.datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view setNeedsLayout];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *infoDict = self.datas[indexPath.row];
    NSString *key = infoDict[@"date"];
    if (!key) {
        return nil;
    }
    NSMutableArray *actions = [NSMutableArray array];
    UITableViewRowAction *action_remove = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"移除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteRowAtIndexPath:indexPath forKey:key];
    }];
    action_remove.backgroundColor = [UIColor as_redColor];
    [actions addObject:action_remove];
    
    
    UITableViewRowAction *action_evaluate = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"评估" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self evaluateSutiationLevelAtIndexPath:indexPath forKey:key];
    }];
    action_evaluate.backgroundColor = [UIColor as_mainColor];
    [actions addObject:action_evaluate];
    
    if (![infoDict[@"resolve"] boolValue]) {
        UITableViewRowAction *action_fix = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修复" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [infoDict setObject:@1 forKey:@"resolve"];
            [[YCAssistiveCrashPlugin sharedPlugin] replaceCrashLogToFileByKey:key withDict:infoDict];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            tableView.editing = NO;
        }];
        action_fix.backgroundColor = [UIColor as_greenColor];
        [actions addObject:action_fix];
    }
    
    UITableViewRowAction *action_des = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"描述" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self describeSutiationAtIndexPath:indexPath forKey:key];
    }];
    action_des.backgroundColor = [UIColor as_customColor:0x108eff];
    [actions addObject:action_des];
    return actions;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YCAssistiveContentViewController *contentVC = [[YCAssistiveContentViewController alloc] init];
    NSMutableDictionary *dict = self.datas[indexPath.row];
    NSMutableDictionary *infoDict = dict[@"info"];
    NSMutableString *contentStr = @"".mutableCopy;
    [contentStr appendFormat:@"崩溃类型：%@\n\n",dict[@"typeName"]];
    [contentStr appendFormat:@"日期：%@\n\n",dict[@"date"]];
    [contentStr appendFormat:@"名称：%@\n\n",infoDict[@"name"]];
    [contentStr appendFormat:@"原因：%@\n\n",infoDict[@"reason"]];
    [contentStr appendFormat:@"难易度：%@\n\n",dict[@"level"]];
    [contentStr appendFormat:@"是否解决：%@\n\n",dict[@"resolve"]];
    [contentStr appendFormat:@"堆栈信息：%@\n",infoDict[@"backtrace"]];
    contentVC.content = contentStr;
    [self.navigationController pushViewController:contentVC animated:YES];
}

//MARK:删除
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath forKey:(NSString *)key {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该问题吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[YCAssistiveCrashPlugin sharedPlugin] deleteCrashLogFromDateKey:key];
        [self.datas removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        self.tableView.editing = NO;
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//MARK:评估
- (void)evaluateSutiationLevelAtIndexPath:(NSIndexPath *)indexPath forKey:(NSString *)key {
    
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"预估难易度" message:@"请选择难易程度，‘三级’>'二级'>‘一级’！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *simpleAction = [UIAlertAction actionWithTitle:@"一级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateSutiationLevelAtIndexPath:indexPath type:YCAssistiveCrashSituationLevelSimple forKey:key];
    }];
    UIAlertAction *mediumAction = [UIAlertAction actionWithTitle:@"二级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateSutiationLevelAtIndexPath:indexPath type:YCAssistiveCrashSituationLevelMedium forKey:key];
    }];
    UIAlertAction *difficuteAction = [UIAlertAction actionWithTitle:@"三级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateSutiationLevelAtIndexPath:indexPath type:YCAssistiveCrashSituationLevelDifficult forKey:key];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:simpleAction];
    [alertVC addAction:mediumAction];
    [alertVC addAction:difficuteAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)updateSutiationLevelAtIndexPath:(NSIndexPath *)indexPath type:(YCAssistiveCrashSituationLevel)level forKey:(NSString *)key {
    
    NSMutableDictionary *infoDict = self.datas[indexPath.row];
    if (level == YCAssistiveCrashSituationLevelSimple) {
        [infoDict setObject:@0 forKey:@"level"];
    }else if (level == YCAssistiveCrashSituationLevelMedium) {
        [infoDict setObject:@1 forKey:@"level"];
    }else {
        [infoDict setObject:@2 forKey:@"level"];
    }
    [[YCAssistiveCrashPlugin sharedPlugin] replaceCrashLogToFileByKey:key withDict:infoDict];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    self.tableView.editing = NO;
}

//MARK:描述
- (void)describeSutiationAtIndexPath:(NSIndexPath *)indexPath forKey:(NSString *)key {
    
    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:@"描述问题" message:@"请详细描述问题发生时的情况，以便开发人员找原因。" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.placeholder = @"描述问题情况";
    }];
    __weak typeof(alertController) walertController = alertController;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    NSMutableDictionary *dict = self.datas[indexPath.row];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *description = walertController.textFields.firstObject.text;
        [dict setValue:description forKey:@"des"];
        [[YCAssistiveCrashPlugin sharedPlugin] replaceCrashLogToFileByKey:key withDict:dict];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        self.tableView.editing = NO;
    }];
    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
