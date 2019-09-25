//
//  YCConsoleLoggerCell.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/8/26.
//

#import "YCConsoleLoggerCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"
#import "UIImage+AssistiveBundle.h"

@interface YCConsoleLoggerCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *desLbl;

@end

@implementation YCConsoleLoggerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(12, 14, 0, 14));
        }];
        [self.containerView addSubview:self.desLbl];
        [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(14);
            make.trailing.offset(-14);
            make.top.mas_equalTo(10);
            make.bottom.lessThanOrEqualTo(self.containerView.mas_bottom).offset(-10);
        }];
    }
    return self;
}

- (void)bindDescribeValue:(NSString *)des {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0;  //设置行间距
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:des];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [des length])];
    self.desLbl.attributedText = attributedString;
    attributedString = nil;
}

#pragma mark - getter
- (UIView *)containerView {
    
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor as_cellColor];
        _containerView.layer.cornerRadius = 4.0;
    }
    return _containerView;
}

- (UILabel *)desLbl {
    
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.font = [UIFont as_15];
        _desLbl.textColor = [UIColor whiteColor];
        _desLbl.textAlignment = NSTextAlignmentLeft;
        _desLbl.numberOfLines = 0;
    }
    return _desLbl;
}

@end
