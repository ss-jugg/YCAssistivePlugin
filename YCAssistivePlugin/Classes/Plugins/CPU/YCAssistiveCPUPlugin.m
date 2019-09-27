//
//  YCAssistiveCPUPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveCPUPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"
@implementation YCAssistiveCPUPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory cpuPluginWindow]];
}

@end
