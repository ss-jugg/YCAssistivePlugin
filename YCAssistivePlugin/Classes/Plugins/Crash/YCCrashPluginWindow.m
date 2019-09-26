//
//  YCCrashPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/20.
//

#import "YCCrashPluginWindow.h"
#import "YCAssistiveCrashViewController.h"
@implementation YCCrashPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [self navigationController:[[YCAssistiveCrashViewController alloc] init]];
    }
    return self;
}

@end
