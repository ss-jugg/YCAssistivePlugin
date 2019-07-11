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

@interface YCAssistiveDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UIImageView *nextImg;
@property (nonatomic, strong) UIView *hLine;
@end

#define HttpTitles @[@"Request Url",@"Method",@"Status Code",@"Mine Type",@"Start Time",@"Total Duration",@"Request Headers",@"Request Body",@"Response Body"]

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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return HttpTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56.0;
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
            if (length < 1024) {
                value = [NSString stringWithFormat:@"(%zdB)",length];
            }
            else {
                value = [NSString stringWithFormat:@"(%.2fKB)",1.0 * length / 1024];
            }
            cell.nextImg.hidden = NO;
        }else {
            value = @"empty";
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
        NSString *content = [NSString stringWithFormat:@"%@",self.httpModel.headerFields];
        vc = [[YCAssistiveContentViewController alloc] init];
        vc.content = content;
    }
    if (indexPath.row == 7 && self.httpModel.requestBody.length > 0) {
        vc = [[YCAssistiveContentViewController alloc] init];
        vc.content = self.httpModel.requestBody;
    }
    if (indexPath.row == 8 && self.httpModel.responseData.length > 0) {
        vc = [[YCAssistiveContentViewController alloc] init];
        vc.responseData = self.httpModel.responseData;
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
            make.height.mas_equalTo(20);
            make.trailing.offset(-14);
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
        _titleLbl.textColor = [UIColor as_bodyColor];
        _titleLbl.font = [UIFont as_15_bold];
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
    }
    return _detailLbl;
}
- (UIView *)hLine {
    
    if (_hLine == nil) {
        _hLine = [[UIView alloc] init];
        _hLine.backgroundColor = [UIColor as_lineColor];
    }
    return _hLine;
}

- (UIImageView *)nextImg {
    
    if (_nextImg == nil) {
        _nextImg = [[UIImageView alloc] init];
        _nextImg.image = [UIImage as_imageWithName:@"icon_next"];
    }
    return _nextImg;
}
@end
