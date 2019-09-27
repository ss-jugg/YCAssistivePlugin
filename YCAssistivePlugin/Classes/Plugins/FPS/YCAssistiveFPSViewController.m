//
//  YCAssistiveFPSViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveFPSViewController.h"
#import "YCAssistiveFPSHelper.h"
#import "YCAssistiveDetectionInfoView.h"
#import "YCAssistiveDefine.h"
#import "UIViewController+AssistiveUtil.h"
#import "UIView+AssistiveUtils.h"

@interface YCAssistiveFPSViewController ()

@property (nonatomic, strong) YCAssistiveFPSHelper *fpsHelper;

@property (nonatomic, strong) YCAssistiveDetectionInfoView *infoView;

@end

@implementation YCAssistiveFPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self startRecord];
}

- (void)setupUI {
    
    self.infoView = [[YCAssistiveDetectionInfoView alloc] initWithFrame:CGRectMake(10, 44, AS_ScreenWidth-20, 90)];
    [self.infoView setDetectionInfoViewTitle:@"帧率检测"];
    weak(self);
    [self.infoView setCloseBlock:^{
        strong(self);
        [self.fpsHelper endFPS];
        [self.infoView.detectionView resetDetectionView];
        [self pluginWindowDidClosed];
    }];
    [self.view addSubview:self.infoView];
}


- (void)startRecord {
    
    if (!self.fpsHelper) {
        
        __weak typeof(self) weakSelf = self;
        self.fpsHelper = [YCAssistiveFPSHelper fpsWithBlock:^(NSInteger fps) {
            NSString *value = [NSString stringWithFormat:@"%zi",fps];
            [weakSelf.infoView.detectionView addValue:value atHeight:fps*self.infoView.detectionView.as_height/60];
        }];
    }
    [self.fpsHelper startFPS];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint p = [self.view convertPoint:point toView:self.infoView];
    if (CGRectContainsPoint(self.infoView.bounds, p)) {
        return YES;
    }
    return NO;
}

@end
