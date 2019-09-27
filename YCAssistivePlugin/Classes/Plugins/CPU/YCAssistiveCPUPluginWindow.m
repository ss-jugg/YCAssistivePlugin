//
//  YCAssistiveCPUPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveCPUPluginWindow.h"
#import "YCAssistiveCPUViewController.h"

@implementation YCAssistiveCPUPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.rootViewController = [[YCAssistiveCPUViewController alloc] init];
    }
    return self;
}

@end
