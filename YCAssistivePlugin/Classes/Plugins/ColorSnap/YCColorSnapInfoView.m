//
//  YCColorSnapInfoView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import "YCColorSnapInfoView.h"
#import "UIColor+AssistiveColor.h"
#import "UIView+AssistiveUtils.h"

@interface YCColorSnapInfoView ()

@property (nonatomic, strong) UIView *colorView;

@property (nonatomic, strong) UILabel *colorLbl;

@property (nonatomic, strong) UIButton *closeButton;

@end
@implementation YCColorSnapInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    
    self.colorView = [[UIView alloc] initWithFrame:CGRectMake(20, (self.as_height-20)/2.0, 20, 20)];
    self.colorView.layer.borderWidth = 0.5;
    self.colorView.layer.borderColor = [UIColor as_mainColor].CGColor;
    [self addSubview:self.colorView];
    
    self.colorLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.colorView.as_right+20, 0, self.as_width-self.colorView.as_right-20, self.as_height)];
    self.colorLbl.textColor = [UIColor as_mainColor];
    self.colorLbl.numberOfLines = 0;
    [self addSubview:self.colorLbl];
}

- (void)updateColor:(NSString *)hexColor atPoint:(CGPoint)point {
    
    self.colorView.backgroundColor = [UIColor as_colorWithHex:hexColor];
    self.colorLbl.text = [NSString stringWithFormat:@"%@\nX: %0.1f, Y: %0.1f",hexColor,point.x,point.y];
}

- (void)viewDidClose {
    [self.delegate colorSnapInfoViewDidClose:self];
}

@end
