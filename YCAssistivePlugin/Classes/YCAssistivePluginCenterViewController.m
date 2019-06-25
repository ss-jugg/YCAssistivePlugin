//
//  YCAssistivePluginCenterViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "YCAssistivePluginCenterViewController.h"

@interface YCAssistivePluginCenterViewController ()

@end

@implementation YCAssistivePluginCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self addChildrenControllers];
}

- (void)addChildrenControllers {
    
    NSArray *viewControllers = @[@"YCNetworkEmvironmentViewController"];
    NSArray *titles = @[@"server"];
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController;
        viewController = [[NSClassFromString(obj) alloc] init];
        viewController.title = titles[idx];
//        viewController.tabBarItem.image = [[UIImage imageWithContentsOfFile:normalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        viewController.tabBarItem.selectedImage = [[UIImage imageWithContentsOfFile:selectedImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        nav.navigationBar.translucent = YES;
        [self addChildViewController:nav];
    }];
    
}

@end
