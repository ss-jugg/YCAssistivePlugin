//
//  YCAssistiveDebuggerPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAssistiveDebuggerPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"
@implementation YCAssistiveDebuggerPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory debuggerPluginWindow]];
}
@end
