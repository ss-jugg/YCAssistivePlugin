//
//  YCLargeImagePlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import "YCLargeImagePlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"

@implementation YCLargeImagePlugin

- (void)pluginDidLoad {

    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory largeImagePluginWindow]];
}

@end
