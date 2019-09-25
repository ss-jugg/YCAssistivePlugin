//
//  YCAssistiveCrashCell.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/5.
//

#import "YCAssistiveCrashCell.h"
#import <Masonry/Masonry.h>
#import "UIImage+AssistiveBundle.h"
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"

@interface YCAssistiveCrashCell ()

/* <#mark#> */
@property (nonatomic, strong) UIView *containerView;

/* 图标 */
@property (nonatomic, strong) UIImageView *iconImg;
/* 奔溃标题 */
@property (nonatomic, strong) UILabel *titleLbl;
/* <#mark#> */
@property (nonatomic, strong) UILabel *nameLbl;
/* <#mark#> */
@property (nonatomic, strong) UILabel *dateLbl;
/* 奔溃原因 */
@property (nonatomic, strong) UILabel *reasonLbl;
/* 已处理 */
@property (nonatomic, strong) UIImageView *resolvedImg;
/* 困难等级 */
@property (nonatomic, strong) UIImageView *levelImg;
/* 是否已读 */
@property (nonatomic, strong) UIImageView *readImg;

@end

@implementation YCAssistiveCrashCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.iconImg];
        [self.containerView addSubview:self.titleLbl];
        [self.containerView addSubview:self.dateLbl];
        [self.containerView addSubview:self.nameLbl];
        [self.containerView addSubview:self.reasonLbl];
        [self.containerView addSubview:self.resolvedImg];
        [self.containerView addSubview:self.levelImg];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(12, 14, 0, 14));
        }];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(14);
            make.centerY.equalTo(self.containerView);
            make.size.mas_equalTo(CGSizeMake(16, 27));
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImg.mas_right).offset(16);
            make.top.mas_equalTo(16);
            make.height.mas_equalTo(20);
        }];
        [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
            make.height.mas_equalTo(20);
        }];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl);
            make.top.equalTo(self.dateLbl.mas_bottom).offset(8);
            make.height.mas_equalTo(20);
        }];
        [self.reasonLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl);
            make.top.equalTo(self.nameLbl.mas_bottom).offset(8);
            make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(-14);;
            make.bottom.lessThanOrEqualTo(self.containerView.mas_bottom).offset(-8).priorityHigh();
        }];
        [self.levelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.containerView);
            make.size.mas_equalTo(CGSizeMake(40, 39));
        }];
        [self.resolvedImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView);
            make.trailing.offset(-20);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
    return self;
}

#pragma mark - 绑定数据
- (void)bindDict:(NSDictionary *)dict {
    
    self.titleLbl.text = [NSString stringWithFormat:@"崩溃类型：%@",dict[@"typeName"]];
    self.dateLbl.text = dict[@"date"];
    NSDictionary *infoDic = dict[@"info"];
    self.nameLbl.text = infoDic[@"name"];
    self.reasonLbl.text = infoDic[@"reason"];
    NSInteger level = [dict[@"level"] integerValue];
    if (level == 0) {
        self.levelImg.image = [UIImage as_imageWithName:@"icon_level_simple"];
    }else if (level == 1) {
        self.levelImg.image = [UIImage as_imageWithName:@"icon_level_medium"];
    }else {
        self.levelImg.image = [UIImage as_imageWithName:@"icon_level_difficute"];
    }
    self.resolvedImg.hidden = ![dict[@"resolve"] boolValue];
}

#pragma mark - 重写

#pragma mark - getter
- (UIView *)containerView {
    
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor as_cellColor];
        _containerView.layer.cornerRadius = 4.0;
    }
    return _containerView;
}

- (UIImageView *)iconImg {
    
    if (_iconImg == nil) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.image = [UIImage as_imageWithName:@"icon_crash"];
    }
    return _iconImg;
}

- (UILabel *)titleLbl {
    
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont as_15];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLbl;
}
- (UILabel *)dateLbl {
    
    if (_dateLbl == nil) {
        _dateLbl = [[UILabel alloc] init];
        _dateLbl.textColor = [UIColor whiteColor];
        _dateLbl.font = [UIFont as_13];
        _dateLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLbl;
}
- (UILabel *)nameLbl {
    
    if (_nameLbl == nil) {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.textColor = [UIColor whiteColor];
        _nameLbl.font = [UIFont as_13];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLbl;
}
- (UILabel *)reasonLbl {
    
    if (_reasonLbl == nil) {
        _reasonLbl = [[UILabel alloc] init];
        _reasonLbl.textColor = [UIColor whiteColor];
        _reasonLbl.font = [UIFont as_13];
        _reasonLbl.textAlignment = NSTextAlignmentLeft;
        _reasonLbl.numberOfLines = 0;
    }
    return _reasonLbl;
}
- (UIImageView *)resolvedImg {
    
    if (_resolvedImg == nil) {
        _resolvedImg = [[UIImageView alloc] init];
        _resolvedImg.image = [UIImage as_imageWithName:@"icon_resolve"];
    }
    return _resolvedImg;
}
- (UIImageView *)levelImg {
    
    if (_levelImg == nil) {
        _levelImg = [[UIImageView alloc] init];
        
    }
    return _levelImg;
}

@end
