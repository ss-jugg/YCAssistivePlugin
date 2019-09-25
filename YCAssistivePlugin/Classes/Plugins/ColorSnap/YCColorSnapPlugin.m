//
//  YCColorSnapPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCColorSnapPlugin.h"
#import "YCAssitiveWindowFactory.h"
#import "YCAssistiveManager.h"
@implementation YCColorSnapPlugin

- (void)pluginDidLoad {

    [[YCAssistiveManager sharedManager] showPluginWindow:[YCAssitiveWindowFactory colorSnapWindow]];
}

@end
