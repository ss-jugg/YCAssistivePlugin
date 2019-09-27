//
//  YCAssistiveDetectionInfoView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveDetectionInfoView.h"
#import "UIColor+AssistiveColor.h"
#import "UIView+AssistiveUtils.h"

@interface YCAssistiveDetectionInfoView ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation YCAssistiveDetectionInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initial];
    }
    return self;
}

- (void)initial {
    
    self.backgroundColor = [[UIColor as_backgroudColor] colorWithAlphaComponent:0.6];
    self.layer.cornerRadius = 2.0;
    self.layer.borderColor = [UIColor as_mainColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.as_width, 20)];
    self.titleLbl.font = [UIFont systemFontOfSize:15];
    self.titleLbl.textColor = [UIColor as_mainColor];
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLbl];
    
    self.detectionView = [[YCAssisticeDetectionView alloc] initWithFrame:CGRectMake(10, self.titleLbl.as_bottom+8, self.as_width-10-50, self.as_height-self.titleLbl.as_bottom-8-8)];
    [self addSubview:self.detectionView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(self.as_width - 40 -10, 8, 40, 20);
    self.closeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.closeButton setTitle:@"关 闭" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor as_mainColor] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.layer.cornerRadius = 2.0;
    self.closeButton.layer.borderWidth = 1.0;
    self.closeButton.layer.borderColor = [UIColor as_mainColor].CGColor;
    [self addSubview:self.closeButton];
}

- (void)closeButtonClicked:(UIButton *)sender {
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
