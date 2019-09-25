//
//  YCAssistiveNetworkFlowViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/25.
//

#import "YCAssistiveNetworkFlowViewController.h"
#import "UIViewController+AssistiveUtil.h"
#import "YCAssistiveNetworkFlowDataView.h"
#import "UIView+AssistiveUtils.h"

@interface YCAssistiveNetworkFlowViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) YCAssistiveNetworkFlowDataView *flowDataView;

@end

@implementation YCAssistiveNetworkFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self as_setLeftBarItemTitle:@"关闭"];
    [self initial];
}

- (void)initial {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    self.flowDataView = [[YCAssistiveNetworkFlowDataView alloc] initWithFrame:CGRectMake(10, 20, self.view.as_width-20, 140)];
    [self.scrollView addSubview:self.flowDataView];
}


- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController  {
    
    [self pluginWindowDidClosed];
}

@end
