//
//  YCScreenShotToolBar.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import "YCScreenShotToolBar.h"
#import "YCScreenShotStyleView.h"
#import "YCScreenShotActionView.h"
#import "UIImage+AssistiveBundle.h"

@interface YCScreenShotToolBar ()<YCScreenShotActionViewDelegate>

@property (nonatomic, strong) YCScreenShotActionView *actionView;

@property (nonatomic, strong) YCScreenShotStyleView *styleView;

@property (nonatomic, strong) UIView *styleBackgroundView;

@property (nonatomic, strong) UIImageView *triangleView;

@property (nonatomic, assign) BOOL styleViewShowed;

@end

@implementation YCScreenShotToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    
    CGFloat itemHeight = (self.frame.size.height - 10) /2.0;
    
    self.actionView = [[YCScreenShotActionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), itemHeight)];
    self.actionView.actionDelegate = self;
    [self addSubview:self.actionView];
    
    self.styleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-itemHeight)];
    [self addSubview:self.styleBackgroundView];
    
    CGFloat triangleHeight = 12.0;
    self.triangleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, triangleHeight * 2, triangleHeight)];
    self.triangleView.image = [UIImage as_imageWithName:@"icon_arrow"];
    [self.styleBackgroundView addSubview:self.triangleView];
    
    self.styleView = [[YCScreenShotStyleView alloc] initWithFrame:CGRectMake(0, triangleHeight, CGRectGetWidth(self.styleBackgroundView.frame), CGRectGetHeight(self.styleBackgroundView.frame) - triangleHeight)];
    [self.styleBackgroundView addSubview:self.styleView];
    self.styleBackgroundView.hidden = YES;
}


- (void)showStyleViewAtIndex:(NSInteger)index atPosition:(CGFloat)position {
    
    self.styleBackgroundView.hidden = NO;
    [self.styleView resetStyleView];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect oriFrame = self.triangleView.frame;
        CGFloat actionViewBottom = self.actionView.frame.size.height + self.actionView.frame.origin.y;
        self.triangleView.frame = CGRectMake(position - oriFrame.size.width / 2.0, oriFrame.origin.y, oriFrame.size.width, oriFrame.size.height);
        self.styleBackgroundView.frame = CGRectMake(0, actionViewBottom, self.styleBackgroundView.frame.size.width, self.styleBackgroundView.frame.size.height);
    } completion:^(BOOL finished) {
        self.styleViewShowed = YES;
    }];
}

- (void)hideStyleView {
    
    if (self.styleViewShowed) {
        CGRect orFrame = self.styleBackgroundView.frame;
        [UIView animateWithDuration:0.25 animations:^{
            self.styleBackgroundView.frame = CGRectMake(orFrame.origin.x, CGRectGetHeight(self.frame), CGRectGetWidth(orFrame), CGRectGetHeight(orFrame));
        } completion:^(BOOL finished) {
            self.styleViewShowed = NO;
            self.styleBackgroundView.hidden = YES;
        }];
    }
}

- (void)screenShotActionView:(YCScreenShotActionView *)view didSelectedAction:(YCScreenShotAction)action isSelected:(BOOL)isSelected atPosition:(CGFloat)position {
    
    switch (action) {
        case YCScreenShotActionRect:
        case YCScreenShotActionRound:
        case YCScreenShotActionLine:
        case YCScreenShotActionDraw:
        case YCScreenShotActionText:{

            if (isSelected) {
                [self showStyleViewAtIndex:action atPosition:position];
            }else {
                [self hideStyleView];
            }
        }
            break;
        case YCScreenShotActionRevoke:{
            
        }
            break;
        case YCScreenShotActionCancel:{
            
        }
            break;
        case YCScreenShotActionConfirm:{
            
        }
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(screenShotToolBar:didSeletAction:styleModel:)]) {
        YCScreenShotStyleModel *model = nil;
        if (action < YCScreenShotActionRevoke) {
            if (isSelected) {
                model = [self.styleView currentStyleModel];
            } else {
                action = YCScreenShotActionNone;
            }
        }
        [self.delegate screenShotToolBar:self didSeletAction:action styleModel:model];
    }
}

@end
