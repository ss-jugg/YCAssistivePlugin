//
//  YCAssistiveWindow.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "YCAssistiveWindow.h"

@implementation YCAssistiveWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 119;
    }
    return self;
}

#if DEBUG
- (BOOL)_canBecomeKeyWindow {
    return [self.yc_delegate canBecomeKeyWindow:self];
}


- (BOOL)_canAffectStatusBarAppearance {
    return [self isKeyWindow];
}
#endif


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointInside = NO;
    if ([self.yc_delegate window:self shouldHandleTouchAtPoint:point]) {
        pointInside = [super pointInside:point withEvent:event];
    }
    return pointInside;
}

@end
