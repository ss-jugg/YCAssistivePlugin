//
//  YCNetworkEnvironmentCell.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/11.
//

#import "YCNetworkEnvironmentCell.h"
#import <Masonry/Masonry.h>
#import "UIImage+AssistiveBundle.h"
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"

@interface YCNetworkEnvironmentCell ()

@end
@implementation YCNetworkEnvironmentCell

+ (CGFloat)heightFoNetworkCell {
    return 92.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.iconImg];
        [self.containerView addSubview:self.titleLbl];
        [self.containerView addSubview:self.detailLbl];
        [self.containerView addSubview:self.nextImg];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 1, 0));
        }];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 18));
            make.centerY.equalTo(self.containerView);
            make.leading.offset(10);
        }];
        [self.nextImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView);
            make.size.mas_equalTo(CGSizeMake(10, 16));
            make.trailing.offset(-10);
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImg.mas_right).offset(16);
            make.top.mas_equalTo(16);
            make.right.lessThanOrEqualTo(self.nextImg.mas_left);
            make.height.mas_equalTo(20);
        }];
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_left);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
            make.right.lessThanOrEqualTo(self.nextImg.mas_left);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIView *)containerView {
    
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor as_cellColor];
    }
    return _containerView;
}

- (UIImageView *)iconImg {
    
    if (_iconImg == nil) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.image = [UIImage  as_imageWithName:@"icon_ip"];
    }
    return _iconImg;
}
- (UIImageView *)nextImg {
    
    if (_nextImg == nil) {
        _nextImg = [[UIImageView alloc] init];
        _nextImg.image = [UIImage as_imageWithName:@"icon_next_white"];
    }
    return _nextImg;
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

@end
