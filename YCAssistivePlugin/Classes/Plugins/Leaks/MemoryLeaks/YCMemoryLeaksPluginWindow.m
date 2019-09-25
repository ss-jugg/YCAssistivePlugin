//
//  YCMemoryLeaksPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/20.
//

#import "YCMemoryLeaksPluginWindow.h"
#import "YCAssistiveMemoryLeakViewController.h"

@implementation YCMemoryLeaksPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [self navigationController:[[YCAssistiveNavigationController alloc] init]];
    }
    return self;
}

@end
