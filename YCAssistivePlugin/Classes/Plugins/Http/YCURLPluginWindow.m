//
//  YCURLPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/20.
//

#import "YCURLPluginWindow.h"
#import "YCAssistiveNetworkMainViewController.h"
@implementation YCURLPluginWindow

- (instancetype)initWithFrame:(CGRect)frame  {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [[YCAssistiveNetworkMainViewController alloc] init];
    }
    return self;
}

@end
