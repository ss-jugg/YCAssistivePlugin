//
//  YCAssistiveMemoryViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveMemoryViewController.h"
#import "YCAssistiveDetectionInfoView.h"
#import "YCAssistiveDefine.h"
#import "UIViewController+AssistiveUtil.h"
#import "UIView+AssistiveUtils.h"
#import "YCAssistiveMemoryHelper.h"

@interface YCAssistiveMemoryViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) YCAssistiveDetectionInfoView *memoryView;


@end

@implementation YCAssistiveMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self startRecord];
}

- (void)setupUI {
    
    self.memoryView = [[YCAssistiveDetectionInfoView alloc] initWithFrame:CGRectMake(10, AS_ScreenHeight-90, AS_ScreenWidth, 90)];
    [self.memoryView setDetectionInfoViewTitle:@"内存检测"];
    [self.view addSubview:self.memoryView];
    weak(self);
    [self.memoryView setCloseBlock:^{
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
    
    double memory = [YCAssistiveMemoryHelper usedMemory];
    [self.memoryView.detectionView addValue:[NSString stringWithFormat:@"%.2fM",memory] atHeight:memory*self.memoryView.detectionView.as_height/250];
}

- (void)stopRecord {
    
    [self.timer invalidate];
    self.timer = nil;
    [self.memoryView.detectionView resetDetectionView];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint p = [self.view convertPoint:point toView:self.memoryView];
    if (CGRectContainsPoint(self.memoryView.bounds, p)) {
        return YES;
    }
    return NO;
}

@end
