//
//  YCAssistiveMemoryPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveMemoryPlugin.h"
#import "YCAssistiveMemoryPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCAssistiveMemoryPlugin

- (void)pluginDidLoad {
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCAssistiveMemoryPluginWindow.class)];
}
@end
