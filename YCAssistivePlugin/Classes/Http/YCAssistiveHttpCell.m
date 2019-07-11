//
//  YCAssistiveHttpCell.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/3.
//

#import "YCAssistiveHttpCell.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveHttpModel.h"
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"

@interface YCAssistiveHttpCell ()

/* <#mark#> */
@property (nonatomic, strong) UIView *containerView;


@end

@implementation YCAssistiveHttpCell

+ (CGFloat)heightForHttpCell {
    return 92.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.titleLbl];
        [self.containerView addSubview:self.detailLbl];
        [self.containerView addSubview:self.readLbl];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(14);
            make.top.mas_equalTo(12);
            make.trailing.offset(-14);
            make.height.mas_equalTo(80);
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(14);
            make.top.equalTo(self.containerView).offset(16);
            make.height.mas_equalTo(20);
        }];
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
            make.height.mas_equalTo(20);
        }];
        [self.readLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView);
            make.trailing.offset(-14);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
    }
    return self;
}

- (void)bindHttpModel:(YCAssistiveHttpModel *)model {
    
    self.titleLbl.text = model.url.host;
    self.detailLbl.text = [model.url.path substringWithRange:NSMakeRange(1, model.url.path.length-1)];
    self.readLbl.text = (model.readFlag == 0) ? @"未读" : @"已读";
    self.readLbl.textColor = (model.readFlag == 0)?[UIColor as_redColor]:[UIColor as_greenColor];
    self.readLbl.layer.borderColor = (model.readFlag == 0)?[UIColor as_redColor].CGColor:[UIColor as_greenColor].CGColor;
    
}

#pragma mark - getter
- (UIView *)containerView {
    
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor as_httpCellColor];
        _containerView.layer.cornerRadius = 4.0;
    }
    return _containerView;
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
- (UILabel *)detailLbl {
    
    if (_detailLbl == nil) {
        _detailLbl = [[UILabel alloc] init];
        _detailLbl.textColor = [UIColor whiteColor];
        _detailLbl.font = [UIFont as_13];
        _detailLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _detailLbl;
}

- (UILabel *)readLbl {
    
    if (_readLbl == nil) {
        _readLbl = [[UILabel alloc] init];
        _readLbl.textColor = [UIColor as_redColor];
        _readLbl.font = [UIFont as_13];
        _readLbl.textAlignment = NSTextAlignmentCenter;
        _readLbl.layer.cornerRadius = 4.0;
        _readLbl.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _readLbl.layer.borderColor = [UIColor as_redColor].CGColor;
    }
    return _readLbl;
}

@end
