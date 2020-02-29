//
//  YCColorSnapPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCColorSnapPlugin.h"
#import "YCColorSnapWindow.h"
#import "YCAssistiveManager.h"
#import "YCAssistiveDefine.h"
@implementation YCColorSnapPlugin

- (void)pluginDidLoad {

    [[YCAssistiveManager sharedManager] showPluginWindow:YCPluginWindow(YCColorSnapWindow.class)];
}

@end
