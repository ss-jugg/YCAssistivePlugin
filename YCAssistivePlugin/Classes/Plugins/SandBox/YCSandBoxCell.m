//
//  YCSandBoxCell.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/8.
//

#import "YCSandBoxCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"
#import "UIImage+AssistiveBundle.h"
#import "YCSandBoxModel.h"
#import "YCAssistiveUtil.h"

@interface YCSandBoxCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *fileLbl;
@property (nonatomic, strong) UILabel *sizeLbl;

@end

@implementation YCSandBoxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.fileLbl];
        [self.contentView addSubview:self.sizeLbl];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 1, 0));
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.leading.offset(10);
        }];
        [self.fileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.iconImageView.mas_right).offset(8);
            make.right.equalTo(self.sizeLbl.mas_left).offset(-50);
        }];
        [self.sizeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.trailing.offset(-10);
        }];
        [self.fileLbl setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.sizeLbl setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

+ (CGFloat)heightForCell {
    return 48.0;
}

- (void)renderUIWithModel:(YCSandBoxModel *)model {
    
    if (model.fileType == YCSandBoxFileTypeFile) {
        self.iconImageView.image = [UIImage as_imageWithName:@"icon_wenjian"];
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 28));
        }];
    }else  {
        self.imageView.image = [UIImage as_imageWithName:@"icon_wenjianjia"];
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 18));
        }];
    }
    self.fileLbl.text = model.name;
    NSUInteger size = [YCAssistiveUtil fetchFileSizeAtPath:model.path];
    self.sizeLbl.text = [YCAssistiveUtil formatByte:size];
}

- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor as_cellColor];
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)fileLbl {
    
    if (!_fileLbl) {
        _fileLbl = [[UILabel alloc] init];
        _fileLbl.font = [UIFont as_15];
        _fileLbl.textColor = [UIColor whiteColor];
        _fileLbl.textAlignment = NSTextAlignmentLeft;
        _fileLbl.numberOfLines = 0;
    }
    return _fileLbl;
}

- (UILabel *)sizeLbl {
    
    if (!_sizeLbl) {
        _sizeLbl = [[UILabel alloc] init];
        _sizeLbl.font = [UIFont as_13];
        _sizeLbl.textColor = [UIColor whiteColor];
        _sizeLbl.textAlignment = NSTextAlignmentRight;
    }
    return _sizeLbl;
}

@end
