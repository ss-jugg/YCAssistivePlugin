//
//  YCAssistiveFPSPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveFPSPlugin.h"
#import "YCAssistiveFPSPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCAssistiveFPSPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCAssistiveFPSPluginWindow.class)];
}
@end
