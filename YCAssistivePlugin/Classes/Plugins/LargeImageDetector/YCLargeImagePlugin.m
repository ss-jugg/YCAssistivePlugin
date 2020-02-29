//
//  YCLargeImagePlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import "YCLargeImagePlugin.h"
#import "YCLargeImagePluginWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCLargeImagePlugin

- (void)pluginDidLoad {

    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCLargeImagePluginWindow.class)];
}

@end
