//
//  YCAssistiveBaseWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCAssistiveBaseWindow.h"
#import "UIWindow+AssistiveEntry.h"
#import "UIViewController+AssistiveUtil.h"

@implementation YCAssistiveBaseWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.windowLevel = UIWindowLevelStatusBar + 119;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIViewController *vc = [self yc_currentShowingViewController];
    return [vc pointInside:point withEvent:event];
}

- (BOOL)yc_canBecomeKeyWindow {
    return YES;
}

@end
