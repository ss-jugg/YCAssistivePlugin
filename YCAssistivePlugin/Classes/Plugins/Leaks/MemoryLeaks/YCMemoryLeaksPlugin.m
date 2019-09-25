//
//  YCMemoryLeaksPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/20.
//

#import "YCMemoryLeaksPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"

@implementation YCMemoryLeaksPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory leaksPluginWindow]];
}

@end
