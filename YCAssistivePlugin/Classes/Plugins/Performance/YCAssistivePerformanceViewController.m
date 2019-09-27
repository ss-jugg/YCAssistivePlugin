//
//  YCAssistivePerformanceViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistivePerformanceViewController.h"
#import "YCAssistiveDefine.h"
#import "UIViewController+AssistiveUtil.h"

@interface YCAssistivePerformanceViewController ()

/* 定时器 */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *infoViews;

@end

@implementation YCAssistivePerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSString *)titleForView {
    
    YCMethodNotImplemented();
}

- (void)showFPSView {
    
    if (!self.fpsView.superview) {
        [self.view addSubview:self.fpsView];
        [self.infoViews addObject:self.fpsView];
    }
    self.fpsView.hidden = NO;
    [self resetSubViews];
}

- (void)showCPUView {
    
    if (!self.cpuView.superview) {
        [self.view addSubview:self.cpuView];
        [self.infoViews addObject:self.cpuView];
    }
    self.cpuView.hidden = NO;
    [self resetSubViews];
}

- (void)showMemoryView {
    if (!self.memoryView.superview) {
        [self.view addSubview:self.memoryView];
        [self.infoViews addObject:self.memoryView];
    }
    self.memoryView.hidden = NO;
    [self resetSubViews];
}

- (void)resetSubViews {
    
    CGFloat y = 44;
    for (UIView *view in self.infoViews) {
        view.frame = CGRectMake(10, y, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        y+=(CGRectGetHeight(view.bounds) + 8);
    }
}

- (void)closeInfoView {
    
    [self resetSubViews];
    if (self.infoViews.count == 0) {
        [self pluginWindowDidClosed];
    }
}


- (YCAssistiveDetectionInfoView *)fpsView {
    
    if (!_fpsView) {
        _fpsView = [[YCAssistiveDetectionInfoView alloc] initWithFrame:CGRectMake(0, 0, AS_ScreenWidth-20, 90)];
        weak(self);
        [_fpsView setCloseBlock:^{
            strong(self);
            [self closeInfoView];
        }];
    }
    return _fpsView;
}

- (YCAssistiveDetectionInfoView *)cpuView {
    
    if (!_cpuView) {
        _cpuView = [[YCAssistiveDetectionInfoView alloc] initWithFrame:CGRectMake(0, 0, AS_ScreenWidth-20, 90)];
        weak(self);
        [_cpuView setCloseBlock:^{
            strong(self);
            [self closeInfoView];
        }];
    }
    return _cpuView;
}

- (YCAssistiveDetectionInfoView *)memoryView {
    
    if (!_memoryView) {
        _memoryView = [[YCAssistiveDetectionInfoView alloc] initWithFrame:CGRectMake(0, 0, AS_ScreenWidth-20, 90)];
        weak(self);
        [_memoryView setCloseBlock:^{
            strong(self);
            [self closeInfoView];
        }];
    }
    return _memoryView;
}

- (NSMutableArray *)infoViews {
    
    if (!_infoViews) {
        _infoViews = [[NSMutableArray alloc] init];
    }
    return _infoViews;
}

- (void)dealloc {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
