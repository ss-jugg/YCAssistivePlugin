//
//  YCAssistiveCPUPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveCPUPlugin.h"
#import "YCAssistiveCPUPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCAssistiveCPUPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCAssistiveCPUPluginWindow.class)];
}

@end
