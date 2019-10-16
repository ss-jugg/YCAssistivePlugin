//
//  YCAssistiveDebuggerPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAssistiveDebuggerPluginWindow.h"
#import "YCDisplayNameViewController.h"
@implementation YCAssistiveDebuggerPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.rootViewController = [[YCDisplayNameViewController alloc] init];
    }
    return self;
}

- (BOOL)yc_canBecomeKeyWindow {
    return NO;
}

@end
