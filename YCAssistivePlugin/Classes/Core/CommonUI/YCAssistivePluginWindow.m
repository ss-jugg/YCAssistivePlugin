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

- (void)pluginWindowDidClosed {
    
    [[YCAssistiveManager sharedManager] showAssistive];
}

@end
