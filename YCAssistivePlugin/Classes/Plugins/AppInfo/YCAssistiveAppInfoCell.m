//
//  YCAppInfoCell.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAssistiveAppInfoCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+AssistiveColor.h"
#import "UIFont+AssistiveFont.h"

@interface YCAssistiveAppInfoCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *valueLbl;

@end

@implementation YCAssistiveAppInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.valueLbl];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 1, 0));
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.leading.offset(10);
        }];
        [self.valueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.trailing.offset(-10);
        }];
    }
    return self;
}

- (void)renderUIWithModel:(YCAppInfoModel *)model {
    
    self.titleLbl.text = model.name;
    self.valueLbl.text = [model infoValue];
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
    
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont as_15];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLbl;
}
- (UILabel *)valueLbl {
    
    if (!_valueLbl) {
        _valueLbl = [[UILabel alloc] init];
        _valueLbl.font = [UIFont as_15];
        _valueLbl.textColor = [UIColor whiteColor];
        _valueLbl.textAlignment = NSTextAlignmentRight;
    }
    return _valueLbl;
}

@end

@implementation  YCAppInfoModel

+ (instancetype)modelWithName:(NSString *)name value:(NSString *)value {
    YCAppInfoModel *model = [[YCAppInfoModel alloc] init];
    model.name = name;
    model.value = value;
    return model;
}

- (NSString  *)infoValue {
    
    NSString *value = nil;
    if([self.value isEqualToString:@"NotDetermined"]){
        value = @"用户没有选择";
    }else if([self.value isEqualToString:@"Restricted"]){
        value = @"家长控制";
    }else if([self.value isEqualToString:@"Denied"]){
        value = @"用户没有授权";
    }else if([self.value isEqualToString:@"Authorized"]){
        value = @"用户已经授权";
    }else if([self.value isEqualToString:@"Always"]){
        value = @"总是开启";
    }else if ([self.value isEqualToString:@"WhenInUse"]) {
        value = @"使用时开启";
    }else {
        value = self.value;
    }
    return value;
}
@end
