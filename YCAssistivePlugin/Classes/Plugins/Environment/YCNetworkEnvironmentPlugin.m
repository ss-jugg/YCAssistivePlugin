//
//  YCNetworkEnvironmentPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCNetworkEnvironmentPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"

@implementation YCNetworkEnvironmentPlugin

- (void)pluginDidLoad {
    
    [[YCAssistiveManager sharedManager]showPluginWindow:[YCAssitiveWindowFactory networkEnvironmentWindow]];
}

@end
