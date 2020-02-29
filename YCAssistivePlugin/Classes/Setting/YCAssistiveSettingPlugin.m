//
//  YCAssistiveSettingPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/11.
//

#import "YCAssistiveSettingPlugin.h"
#import "YCAssistiveSettingPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCAssistiveSettingPlugin

- (void)pluginDidLoad {
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCAssistiveSettingPluginWindow)];
}

@end
