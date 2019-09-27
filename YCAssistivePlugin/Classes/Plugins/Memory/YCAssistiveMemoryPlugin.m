//
//  YCAssistiveMemoryPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveMemoryPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"
@implementation YCAssistiveMemoryPlugin

- (void)pluginDidLoad {
    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory memoryPluginWindow]];
}
@end
