//
//  YCAssistiveCPUViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveCPUViewController.h"
#import "YCAssistiveDetectionInfoView.h"
#import "YCAssistiveDefine.h"
#import "UIViewController+AssistiveUtil.h"
#import "UIView+AssistiveUtils.h"
#import "YCAssistiveCPUHelper.h"
@interface YCAssistiveCPUViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) YCAssistiveDetectionInfoView *cpuView;

@end

@implementation YCAssistiveCPUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self startRecord];
}

- (void)setupUI {
    
    self.cpuView = [[YCAssistiveDetectionInfoView alloc] initWithFrame:CGRectMake(10, AS_ScreenHeight-90, AS_ScreenWidth, 90)];
    [self.cpuView setDetectionInfoViewTitle:@"cpu检测"];
    [self.view addSubview:self.cpuView];
    weak(self);
    [self.cpuView setCloseBlock:^{
        strong(self);
        [self stopRecord];
        [self pluginWindowDidClosed];
    }];
}

- (void)startRecord{
    if(!self.timer){
        self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(doSecondFunction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)doSecondFunction {
    
    CGFloat cpuUsage = [YCAssistiveCPUHelper cpuUsageOfApp];
    [self.cpuView.detectionView addValue:[NSString stringWithFormat:@"%.1f%%",cpuUsage] atHeight:cpuUsage*self.cpuView.detectionView.as_height/100];
}

- (void)stopRecord {
    
    [self.timer invalidate];
    self.timer = nil;
    [self.cpuView.detectionView resetDetectionView];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint p = [self.view convertPoint:point toView:self.cpuView];
    if (CGRectContainsPoint(self.cpuView.bounds, p)) {
        return YES;
    }
    return NO;
}

- (void)dealloc {
    [self stopRecord];
}
@end
