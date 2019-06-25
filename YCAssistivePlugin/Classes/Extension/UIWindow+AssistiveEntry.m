//
//  UIWindow+AssistiveEntry.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "UIWindow+AssistiveEntry.h"
#import "YCAssistiveMacro.h"
#import "YCAssistiveManager.h"
@implementation UIWindow (AssistiveEntry)
#if DEBUG
+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YCSwizzleInstanceMethod([self class], @selector(motionBegan:withEvent:), @selector(yc_at_entry_motionBegan:withEvent:));
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
#endif
@end
