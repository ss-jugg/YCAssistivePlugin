//
//  YCLoggerCell.m
//  YCLogger
//
//  Created by shenweihang on 2019/8/26.
//

#import "YCLoggerCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"
#import "UIImage+AssistiveBundle.h"

@interface YCLoggerCell ()


@end

@implementation YCLoggerCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.titleLbl];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(12, 14, 0, 14));
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView);
            make.leading.offset(14);
        }];
        [self.containerView addSubview:self.nextImgView];
        [self.nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(-14);
            make.centerY.equalTo(self.containerView);
            make.size.mas_equalTo(CGSizeMake(10, 16));
        }];
    }
    return self;
}

- (UIView *)containerView {
    
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor as_cellColor];
        _containerView.layer.cornerRadius = 4.0;
    }
    return _containerView;
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

- (UIImageView *)nextImgView {
    
    if (!_nextImgView) {
        _nextImgView = [[UIImageView alloc] init];
        _nextImgView.image = [UIImage as_imageWithName:@"icon_next_white"];
    }
    return _nextImgView;
}

@end
