//
//  YCCrashPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/20.
//

#import "YCCrashPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"

@implementation YCCrashPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory crashPluginWindow]];
}

@end
