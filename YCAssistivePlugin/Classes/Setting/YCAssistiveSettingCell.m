//
//  YCAssistiveSettingCell.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/19.
//

#import "YCAssistiveSettingCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"
#import "YCAssistiveSettingModel.h"
#import "YCAssistiveMacro.h"

@interface YCAssistiveSettingCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UISwitch *settingSwitch;

@property (nonatomic, strong) YCAssistiveSettingModel *bindedModel;
@end

@implementation YCAssistiveSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.detailLbl];
        [self.contentView addSubview:self.settingSwitch];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 1, 0));
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(10);
            make.top.mas_equalTo(10);
            make.right.lessThanOrEqualTo(self.contentView.mas_centerX);
        }];
        [self.settingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 40));
            make.trailing.offset(-10);
            make.centerY.equalTo(self.titleLbl);
        }];
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_left);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        self.switchSignal = [RACSubject subject];
    }
    return self;
}

- (void)bindSettingModel:(YCAssistiveSettingModel *)model {
    
    self.bindedModel = model;
    self.titleLbl.text = model.title;
    self.settingSwitch.on = model.isOn;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.detail];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.detail length])];
    self.detailLbl.attributedText = attributedString;
    attributedString = nil;
}

#pragma mark - getter
- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor as_cellColor];
    }
    return _bgView;
}
- (UILabel *)titleLbl {
    
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont as_15];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}

- (UILabel *)detailLbl {
    
    if (_detailLbl == nil) {
        _detailLbl = [[UILabel alloc] init];
        _detailLbl.textColor = [UIColor whiteColor];
        _detailLbl.font = [UIFont as_11];
        _detailLbl.textAlignment = NSTextAlignmentLeft;
        _detailLbl.numberOfLines = 0;
    }
    return _detailLbl;
}
- (UISwitch *)settingSwitch {
    
    if (_settingSwitch == nil) {
        _settingSwitch = [[UISwitch alloc] init];
        weak(self);
        [[_settingSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISwitch * _Nullable x) {
            strong(self);
            [self.bindedModel.switchSignal sendNext:@(x.isOn)];
        }];
        _settingSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    return _settingSwitch;
}

@end
