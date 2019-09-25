//
//  YCAssistiveHomeWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCAssistiveHomeWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveNavigationController.h"
#import "YCAssistivePluginHomeViewController.h"

@implementation YCAssistiveHomeWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initial];
        self.windowLevel = UIWindowLevelStatusBar + 200;
    }
    return self;
}

- (void)initial {
    
    if (!self.rootViewController) {
        YCAssistivePluginHomeViewController *homeVC = [[YCAssistivePluginHomeViewController alloc] init];
        YCAssistiveNavigationController *nav = [[YCAssistiveNavigationController alloc] initWithRootViewController:homeVC];
        self.rootViewController = nav;
    }
}

@end
