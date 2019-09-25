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
#import "UIImage+AssistiveBundle.h"

@interface YCAssistiveHttpCell ()

/* <#mark#> */
@property (nonatomic, strong) UIView *containerView;

/* uiim */
@property (nonatomic, strong) UIImageView *flagImg;
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
        [self.containerView addSubview:self.flagImg];
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
        [self.flagImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView);
            make.trailing.offset(-14);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
    }
    return self;
}

- (void)bindHttpModel:(YCAssistiveHttpModel *)model {
    
    self.titleLbl.text = model.url.host;
    self.detailLbl.text = [model.url.path substringWithRange:NSMakeRange(1, model.url.path.length-1)];
    self.flagImg.image = model.readFlag == 1 ? [UIImage as_imageWithName:@"icon_read_tag"]:[UIImage as_imageWithName:@"icon_unread_tag"];
}

#pragma mark - getter
- (UIView *)containerView {
    
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor as_cellColor];
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

- (UIImageView *)flagImg {
    
    if (_flagImg == nil) {
        _flagImg = [[UIImageView alloc] init];
        
    }
    return _flagImg;
}
@end
