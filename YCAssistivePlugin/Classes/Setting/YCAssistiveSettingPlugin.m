//
//  YCAssistiveSettingPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/11.
//

#import "YCAssistiveSettingPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"
@implementation YCAssistiveSettingPlugin

- (void)pluginDidLoad {
    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory settingPluginWindow]];
}

@end
