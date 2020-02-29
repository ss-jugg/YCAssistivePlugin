//
//  YCCrashPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/20.
//

#import "YCCrashPlugin.h"
#import "YCCrashPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"

@implementation YCCrashPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCCrashPluginWindow.class)];
}

@end
