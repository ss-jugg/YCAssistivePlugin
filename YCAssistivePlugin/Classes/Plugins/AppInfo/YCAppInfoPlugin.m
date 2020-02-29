//
//  YCAppInfoPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAppInfoPlugin.h"
#import "YCAppInfoPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"

@implementation YCAppInfoPlugin

- (void)pluginDidLoad {
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCAppInfoPluginWindow.class)];
}

@end
