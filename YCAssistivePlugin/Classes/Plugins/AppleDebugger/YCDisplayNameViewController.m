//
//  YCDisplayNameViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCDisplayNameViewController.h"
#import "YCAssistiveDebuggerView.h"
#import "UIViewController+AssistiveUtil.h"
#import "YCAssistiveDefine.h"
@interface YCDisplayNameViewController ()

@property (nonatomic, strong) YCAssistiveDebuggerView *debuggerView;

@end

@implementation YCDisplayNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
}

- (void)initializeUI {
    
    self.debuggerView = [[YCAssistiveDebuggerView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([UIScreen mainScreen].bounds)-80-10, CGRectGetWidth([UIScreen mainScreen].bounds)-20, 80)];
    [self.view addSubview:self.debuggerView];
    weak(self);
    [self.debuggerView setCloseHandler:^{
        strong(self);
        [self pluginWindowDidClosed];
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint p = [self.view convertPoint:point toView:self.debuggerView];
    if (CGRectContainsPoint(self.debuggerView.bounds, p)) {
        return YES;
    }
    return NO;
}

@end
