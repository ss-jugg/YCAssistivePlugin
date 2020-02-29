//
//  YCViewHierarchyPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCViewHierarchyPlugin.h"
#import "YCViewHierarchyPluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCViewHierarchyPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCViewHierarchyPluginWindow.class)];
}

@end
