//
//  YCNetworkEnvironmentPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCNetworkEnvironmentPlugin.h"
#import "YCNetworkEnvironmentWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"

@implementation YCNetworkEnvironmentPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager]showPluginWindow:YCPluginWindow(YCNetworkEnvironmentWindow.class)];
}

@end
