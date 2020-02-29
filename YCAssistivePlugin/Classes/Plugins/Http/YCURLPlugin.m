//
//  YCURLPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCURLPlugin.h"
#import "YCURLPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCURLPlugin

- (void)pluginDidLoad {

    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCURLPluginWindow.class)];
}

@end
