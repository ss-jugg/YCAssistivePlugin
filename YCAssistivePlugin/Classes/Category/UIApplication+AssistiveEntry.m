//
//  UIApplication+AssistiveEntry.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "UIApplication+AssistiveEntry.h"
#import "YCAssistiveMacro.h"
@implementation UIApplication (AssistiveEntry)
#if DEBUG
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YCSwizzleInstanceMethod([self class], @selector(motionBegan:withEvent:), @selector(yc_at_entry_motionBegan:withEvent:));
    });
}

- (void)yc_at_entry_motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    [self yc_at_entry_motionBegan:motion withEvent:event];
}
#endif
@end
