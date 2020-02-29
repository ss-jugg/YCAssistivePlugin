//
//  YCSandBoxPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/8.
//

#import "YCSandBoxPlugin.h"
#import "YCSandBoxPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCSandBoxPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCSandBoxPluginWindow.class)];
}

@end
