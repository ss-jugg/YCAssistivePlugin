//
//  YCAssistiveDebuggerPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAssistiveDebuggerPlugin.h"
#import "YCAssistiveDebuggerPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCAssistiveDebuggerPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCAssistiveDebuggerPluginWindow.class)];
}
@end
