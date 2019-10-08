//
//  UIWindow+AssistiveEntry.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "UIWindow+AssistiveEntry.h"
#import "UIViewController+AssistiveUtil.h"

@implementation UIWindow (AssistiveEntry)

- (UIViewController *)yc_currentShowingViewController {
    
    UIViewController *vc = [self.rootViewController as_topViewController];
    if (vc) {
        return vc;
    }
    return self.rootViewController;
}

@end
