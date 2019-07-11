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
#import "UIImage+AssistiveBundle.h"
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"

@interface YCNetworkDetailCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UIImageView *selectedImg;

+ (CGFloat)heightForCell;
@end

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
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self as_setRightBarItemTitle:@"新增"];
    [self.tableView reloadData];
}

- (void)as_viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    
    [self addConfigurButtonOnClicked];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemConfigurs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YCNetworkDetailCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCNetworkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCNetworkDetailCell"];
    if (!cell) {
        cell = [[YCNetworkDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCNetworkDetailCell"];
    }
    YCNetworkConfigur *configur = self.itemConfigurs[indexPath.row];
    cell.titleLbl.text = configur.address;
    cell.detailLbl.text = configur.remark;
    cell.selectedImg.hidden = !configur.selected;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (NSInteger idx = 0; idx < self.itemConfigurs.count; idx++) {
        self.itemConfigurs[idx].selected = (idx == indexPath.row);
        self.itemConfigurs[idx].app = self.identifier;
    }
    [self changeIpAddress];
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
        [self.itemConfigurs addObject:configur];
        [self.tableView reloadData];
    }];
    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - exchange item
- (void)changeIpAddress{

    if (self.selectHandler) {
        self.selectHandler(self.itemConfigurs);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}

@end


@implementation YCNetworkDetailCell

+ (CGFloat)heightForCell {
    return 92.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.iconImg];
        [self.containerView addSubview:self.titleLbl];
        [self.containerView addSubview:self.detailLbl];
        [self.containerView addSubview:self.selectedImg];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(12, 14, 0, 14));
        }];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(14);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(self.containerView);
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImg.mas_right).offset(8);
            make.top.mas_equalTo(16);
            make.right.lessThanOrEqualTo(self.selectedImg.mas_left);
        }];
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_left);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
            make.right.lessThanOrEqualTo(self.selectedImg.mas_left);
        }];
        [self.selectedImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(-14);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(self.containerView);
        }];
    }
    return self;
}

- (UIView *)containerView {
    
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 4.0;
    }
    return _containerView;
}

- (UIImageView *)iconImg {
    
    if (_iconImg == nil) {
        _iconImg = [[UIImageView alloc] init];
        
    }
    return _iconImg;
}

- (UILabel *)titleLbl {
    
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor as_bodyColor];
        _titleLbl.font = [UIFont as_15];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLbl;
}
- (UILabel *)detailLbl {
    
    if (_detailLbl == nil) {
        _detailLbl = [[UILabel alloc] init];
        _detailLbl.textColor = [UIColor as_secondaryColor];
        _detailLbl.font = [UIFont as_13];
        _detailLbl.textAlignment = NSTextAlignmentLeft;
        _detailLbl.numberOfLines = 0;
    }
    return _detailLbl;
}

- (UIImageView *)selectedImg {
    
    if (_selectedImg == nil) {
        _selectedImg = [[UIImageView alloc] init];
        
    }
    return _selectedImg;
}

@end
