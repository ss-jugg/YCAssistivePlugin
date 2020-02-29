//
//  YCLoggerPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/20.
//

#import "YCLoggerPlugin.h"
#import "YCLoggerPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCLoggerPlugin

- (void)pluginDidLoad {

    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCLoggerPluginWindow.class)];
}

@end
