//
//  YCAssistivePluginCenterViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "YCAssistivePluginCenterViewController.h"
#import "YCAssistiveManager.h"
#import "UIImage+AssistiveBundle.h"
#import "YCAssistiveNavigationController.h"
#import "UIColor+AssistiveColor.h"
#import "UIFont+AssistiveFont.h"

@interface YCAssistivePluginCenterViewController ()<UINavigationBarDelegate>

@end

@implementation YCAssistivePluginCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[YCAssistiveManager sharedManager] makeAssistiveWindowAsKeyWindow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    [self.tabBar setBarTintColor:[UIColor as_mainColor]];
    [self addChildrenControllers];
    [self setTabbarTopLineColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[YCAssistiveManager sharedManager] revokeToOriginKeyWindow];
}

- (void)addChildrenControllers {
    
    NSArray *viewControllers = @[@"YCNetworkEmvironmentViewController",@"YCAssistiveHttpViewController",@"YCAssistiveCrashViewController",@"YCAssistiveMemoryLeakViewController"];
    NSArray *titles = @[@"server",@"http",@"crash",@"leak"];
    
    NSArray *normalImages = @[@"qiehuan_default",@"icon_http_default",@"icon_crash_default",@"icon_leak_default"];
    NSArray *selectedImages = @[@"qiehuan_selected",@"icon_http_selected",@"icon_crash_selected",@"icon_leak_selected"];
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController;
        viewController = [[NSClassFromString(obj) alloc] init];
        viewController.title = titles[idx];
        viewController.tabBarItem.image = [[UIImage as_imageWithName:normalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.selectedImage = [[UIImage as_imageWithName:selectedImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor as_customColor:0x108eff]} forState:UIControlStateSelected];
        YCAssistiveNavigationController *nav = [[YCAssistiveNavigationController alloc] initWithRootViewController:viewController];
        [self addChildViewController:nav];
    }];
}

#pragma mark -- 设置tabbar顶部的线
- (void)setTabbarTopLineColor {
    //该表tabbard线条的颜色
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1/[UIScreen mainScreen].scale);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //两个方法缺一不可，否则将无法改变分割线颜色
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    
}

@end
