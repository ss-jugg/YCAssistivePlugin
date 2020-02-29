//
//  YCMemoryLeaksPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/20.
//

#import "YCMemoryLeaksPlugin.h"
#import "YCMemoryLeaksPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCMemoryLeaksPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCMemoryLeaksPluginWindow.class)];
}

@end
