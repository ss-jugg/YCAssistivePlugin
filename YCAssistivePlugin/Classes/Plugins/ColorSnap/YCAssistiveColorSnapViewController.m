//
//  YCAssistiveColorSnapViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import "YCAssistiveColorSnapViewController.h"
#import "YCColorSnapView.h"
#import "YCColorSnapInfoView.h"
#import "UIViewController+AssistiveUtil.h"

@interface YCAssistiveColorSnapViewController ()<YCColorSnapInfoViewDelegate,YCAssistiveColorSnapViewDelegate>

/* 放大镜 */
@property (nonatomic, strong) YCColorSnapView *colorSnapView;

/* 详细信息 */
@property (nonatomic, strong) YCColorSnapInfoView *colorSnapInfoView;

@end

@implementation YCAssistiveColorSnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
}

- (void)initializeUI {
    
    self.colorSnapView = [[YCColorSnapView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.colorSnapView.delegate = self;
    [self.view addSubview:self.colorSnapView];
    [self.colorSnapView pointInSuperView:self.view.center];

    self.colorSnapInfoView = [[YCColorSnapInfoView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([UIScreen mainScreen].bounds)-80-10, CGRectGetWidth([UIScreen mainScreen].bounds)-20, 80)];
    self.colorSnapInfoView.delegate = self;
    [self.view addSubview:self.colorSnapInfoView];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint pPoint = [self.view convertPoint:point toView:self.colorSnapView];
    CGPoint iPoint = [self.view convertPoint:point toView:self.colorSnapInfoView];
    if ([self.colorSnapView pointInside:pPoint withEvent:nil] || [self.colorSnapInfoView pointInside:iPoint withEvent:nil]) {
        return YES;
    }
    return NO;
}

#pragma mark - YCAssistiveColorSnapViewDelegate
- (void)colorSnapView:(YCColorSnapView *)colorSnapView colorHex:(NSString *)colorHex atPosition:(CGPoint)point {
    [self.colorSnapInfoView updateColor:colorHex atPoint:point];
}

#pragma mark - YCColorSnapInfoViewDelegate
- (void)colorSnapInfoViewDidClose:(YCColorSnapInfoView *)infoView {
    
    [self pluginWindowDidClosed];
}


@end
