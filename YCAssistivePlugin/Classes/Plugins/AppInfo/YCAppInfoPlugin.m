//
//  YCAppInfoPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAppInfoPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"

@implementation YCAppInfoPlugin

- (void)pluginDidLoad {

    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory appInfoPluginWindow]];
}

@end
