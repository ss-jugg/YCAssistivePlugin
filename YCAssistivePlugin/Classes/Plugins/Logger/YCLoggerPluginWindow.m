//
//  YCLoggerPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/20.
//

#import "YCLoggerPluginWindow.h"
#import "YCLoggerViewController.h"

@implementation YCLoggerPluginWindow

- (instancetype)initWithFrame:(CGRect)frame  {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [self navigationController:[[YCLoggerViewController alloc] init]];
    }
    return self;
}

@end
