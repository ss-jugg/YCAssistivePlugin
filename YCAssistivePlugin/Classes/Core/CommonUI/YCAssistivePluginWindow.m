//
//  YCAssistivePluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCAssistivePluginWindow.h"
#import "YCAssistiveManager.h"

@implementation YCAssistivePluginWindow

- (YCAssistiveNavigationController *)navigationController:(UIViewController *)vc {
    YCAssistiveNavigationController *nav = [[YCAssistiveNavigationController alloc] initWithRootViewController:vc];
    return nav;
}

- (YCAssistiveNavigationController *)navigationControllerByClass:(Class)cls {
    UIViewController *vc = [[cls alloc] init];
    return [self navigationController:vc];
}

- (void)pluginWindowDidClosed {
    
    [[YCAssistiveManager sharedManager] showAssistive];
}

@end
