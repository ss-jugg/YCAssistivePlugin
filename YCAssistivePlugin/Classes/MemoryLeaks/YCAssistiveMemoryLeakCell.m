//
//  YCAssistiveMemoryLeakCell.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/18.
//

#import "YCAssistiveMemoryLeakCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+AssistiveColor.h"
#import "UIFont+AssistiveFont.h"
#import "UIImage+AssistiveBundle.h"
#import "YCAssistiveMeomryLeakModel.h"

@interface YCAssistiveMemoryLeakCell ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *iconImg;

@property (nonatomic, strong) UILabel *stackLbl;

@end

@implementation YCAssistiveMemoryLeakCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor  = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.iconImg];
        [self.containerView addSubview:self.stackLbl];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.leading.offset(14);
            make.trailing.offset(-14);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView);
            make.leading.offset(14);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        [self.stackLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_top).offset(10);
            make.left.equalTo(self.iconImg.mas_right).offset(10);
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-10).priorityHigh();
            make.right.equalTo(self.containerView.mas_right).offset(-14);
        }];
    }
    return self;
}

- (void)bindModel:(YCAssistiveMeomryLeakModel *)model {
    
    self.iconImg.image = model.isRetainCycle ? [UIImage as_imageWithName:@"icon_xunhuan"] : [UIImage as_imageWithName:@"icon_xielou"];
    NSString *displayText = [model displayText];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [displayText length])];
    self.stackLbl.attributedText = attributedString;
}

- (UIView *)containerView {
    
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor as_cellColor];
        _containerView.layer.cornerRadius = 4.0;
    }
    return _containerView;
}

- (UILabel *)stackLbl {
    
    if (_stackLbl == nil) {
        _stackLbl = [[UILabel alloc] init];
        _stackLbl.textColor = [UIColor whiteColor];
        _stackLbl.font = [UIFont as_13];
        _stackLbl.textAlignment = NSTextAlignmentLeft;
        _stackLbl.numberOfLines = 0;
    }
    return _stackLbl;
}

- (UIImageView *)iconImg {
    
    if (_iconImg == nil) {
        _iconImg = [[UIImageView alloc] init];
    }
    return _iconImg;
}

@end
