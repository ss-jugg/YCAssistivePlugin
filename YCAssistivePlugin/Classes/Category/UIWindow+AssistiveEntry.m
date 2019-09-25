//
//  UIWindow+AssistiveEntry.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "UIWindow+AssistiveEntry.h"
#import "YCAssistiveMacro.h"
#import "YCAssistiveManager.h"
#import "UIViewController+AssistiveUtil.h"

@implementation UIWindow (AssistiveEntry)
#if DEBUG
+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YCSwizzleInstanceMethod([self class], @selector(motionBegan:withEvent:), @selector(yc_at_entry_motionBegan:withEvent:));
        
        NSString *canBecomeKeySelectorString = @"_canBecomeKeyWindow";
        SEL canBecomeKeySelector = NSSelectorFromString(canBecomeKeySelectorString);
        YCSwizzleInstanceMethod([self class], canBecomeKeySelector, @selector(_yc_canBecomeKeyWindow));
    });
}

- (void)yc_at_entry_motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    [self yc_at_entry_motionBegan:motion withEvent:event];
    
    if ([YCAssistiveManager sharedManager].assistiveWindow.hidden) {
        [[YCAssistiveManager sharedManager] showAssistive];
    }else {
        [[YCAssistiveManager sharedManager] hideAssistive];
    }
}

- (BOOL)yc_canBecomeKeyWindow {
    return [self _yc_canBecomeKeyWindow];
}

#pragma mark - Primary
- (BOOL)_yc_canBecomeKeyWindow {
    return [self yc_canBecomeKeyWindow];
}

- (UIViewController *)yc_currentShowingViewController {
    
    UIViewController *vc = [self.rootViewController as_topViewController];
    if (vc) {
        return vc;
    }
    return self.rootViewController;
}

#endif
@end
