//
//  YCAssistiveHttpDetailViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/8.
//

#import "YCAssistiveHttpDetailViewController.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveMacro.h"
#import "UIColor+AssistiveColor.h"
#import "UIFont+AssistiveFont.h"
#import "YCAssistiveHttpModel.h"
#import "UIImage+AssistiveBundle.h"
#import "YCAssistiveContentViewController.h"
#import "YCAssistiveURLUtil.h"

@interface YCAssistiveDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UIImageView *nextImg;
@property (nonatomic, strong) UIView *hLine;
@end

#define HttpTitles @[@"Request Url",@"Method",@"Status Code",@"Mine Type",@"Start Time",@"Total Duration",@"Request Headers",@"Request Body",@"Response Body",@"Data Flow"]

@interface YCAssistiveHttpDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
/* 数据 */
@property (nonatomic, strong) YCAssistiveHttpModel *httpModel;
@end

@implementation YCAssistiveHttpDetailViewController

- (instancetype)initWithHttpModel:(YCAssistiveHttpModel *)model {

    if (self = [super init]) {
        self.httpModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self.tableView reloadData];
    [self as_setNavigationBarTitle:@"详情"];
    self.httpModel.readFlag = 1;
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController {
    
    if (self.readHttpBlock) {
        self.readHttpBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return HttpTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCAssistiveDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCAssistiveDetailCell"];
    if (!cell) {
        cell = [[YCAssistiveDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCAssistiveDetailCell"];
    }
    cell.titleLbl.text = HttpTitles[indexPath.row];
    cell.nextImg.hidden = YES;
    NSString *value = @"";
    if (indexPath.row == 0) {
        value = self.httpModel.url.absoluteString;
        cell.nextImg.hidden = NO;
    }
    if (indexPath.row == 1) {
        value = self.httpModel.method;
    }
    if (indexPath.row == 2) {
        value = self.httpModel.statusCode;
    }
    if (indexPath.row == 3) {
        value = self.httpModel.mineType;
    }
    if (indexPath.row == 4) {
        value = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.httpModel.startTime.doubleValue]];
    }
    if (indexPath.row == 5) {
        value = self.httpModel.totalDuration;
    }
    if (indexPath.row == 6) {
        if (self.httpModel.headerFields) {
            cell.nextImg.hidden = NO;
            value = @"tap me";
        }else {
            value = @"empty";
        }
        cell.nextImg.hidden = NO;
    }
    if (indexPath.row == 7) {
        if (self.httpModel.requestBody.length > 0) {
            cell.nextImg.hidden = NO;
            value = @"tap me";
        }else {
            value = @"empty";
        }
    }
    if (indexPath.row == 8) {
        NSInteger length = self.httpModel.responseData.length;
        if (length > 0) {
            value = @"tap me";
            cell.nextImg.hidden = NO;
        }else {
            value = @"empty";
        }
    }
    if (indexPath.row == 9) {
        NSInteger dataFlow = self.httpModel.uploadFlow.integerValue + self.httpModel.downFlow.integerValue;
        if (dataFlow < 1024) {
            value = [NSString stringWithFormat:@"%ldB",dataFlow];
        }else {
            value = [NSString stringWithFormat:@"%.2fKB",dataFlow/1024.00];
        }
    }
    cell.detailLbl.text = value;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YCAssistiveContentViewController *vc = nil;
    if (indexPath.row == 0) {
        vc = [[YCAssistiveContentViewController alloc] init];
        vc.content = self.httpModel.url.absoluteString;
    }
    if (indexPath.row == 6 && self.httpModel.headerFields) {
        NSMutableString *headerStr = [[NSMutableString alloc] init];
        [self.httpModel.headerFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [headerStr appendFormat:@"\n\"%@\" = \"%@\"", key, obj];
        }];
        vc = [[YCAssistiveContentViewController alloc] init];
        vc.content = headerStr;
    }
    if (indexPath.row == 7 && self.httpModel.requestBody.length > 0) {
        vc = [[YCAssistiveContentViewController alloc] init];
        vc.content = self.httpModel.requestBody;
    }
    if (indexPath.row == 8 && self.httpModel.responseData.length > 0) {
        vc = [[YCAssistiveContentViewController alloc] init];
        if (self.httpModel.isImage) {
            vc.image = self.httpModel.image;
        }else {
            vc.content = [YCAssistiveURLUtil convertJsonFromData:self.httpModel.responseData];
        }
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 64;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (NSDateFormatter *)dateFormatter {
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _dateFormatter;
}

@end

@implementation YCAssistiveDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.detailLbl];
        [self.contentView addSubview:self.nextImg];
        [self.contentView addSubview:self.hLine];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(14);
            make.top.mas_offset(8);
            make.height.mas_offset(20);
        }];
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(14);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
            make.right.equalTo(self.nextImg.mas_left).offset(-8);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-8).priorityHigh();
        }];
        [self.nextImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(8, 16));
            make.trailing.offset(-14);
        }];
        [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(14);
            make.trailing.offset(-14);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}


- (UILabel *)titleLbl {
    
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont as_15_bold];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLbl;
}
- (UILabel *)detailLbl {
    
    if (_detailLbl == nil) {
        _detailLbl = [[UILabel alloc] init];
        _detailLbl.textColor = [UIColor whiteColor];
        _detailLbl.font = [UIFont as_13];
        _detailLbl.textAlignment = NSTextAlignmentLeft;
        _detailLbl.numberOfLines = 0;
    }
    return _detailLbl;
}
- (UIView *)hLine {
    
    if (_hLine == nil) {
        _hLine = [[UIView alloc] init];
        _hLine.backgroundColor = [UIColor whiteColor];
    }
    return _hLine;
}

- (UIImageView *)nextImg {
    
    if (_nextImg == nil) {
        _nextImg = [[UIImageView alloc] init];
        _nextImg.image = [UIImage as_imageWithName:@"icon_next_white"];
    }
    return _nextImg;
}
@end
