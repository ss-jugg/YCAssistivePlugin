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

@interface YCSandBoxCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *fileLbl;

@end

@implementation YCSandBoxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor as_cellColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.fileLbl];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.leading.offset(10);
        }];
        [self.fileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.iconImageView.mas_right).offset(8);
            make.trailing.offset(-10);
        }];
    }
    return self;
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
    }
    return _fileLbl;
}

@end
