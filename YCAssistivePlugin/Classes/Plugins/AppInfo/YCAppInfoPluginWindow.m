//
//  YCAppInfoPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAppInfoPluginWindow.h"
#import "YCAppInfoViewController.h"

@implementation YCAppInfoPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [self navigationController:[[YCAppInfoViewController alloc] init]];
    }
    return self;
}

@end
