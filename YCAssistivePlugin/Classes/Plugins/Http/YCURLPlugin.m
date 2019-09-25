//
//  YCURLPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCURLPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"

@implementation YCURLPlugin

- (void)pluginDidLoad {

    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory urlPluginWindow]];
}

@end
