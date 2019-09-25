//
//  YCNetworkEnvironmentWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCNetworkEnvironmentWindow.h"
#import "YCNetworkEmvironmentViewController.h"

@implementation YCNetworkEnvironmentWindow

- (instancetype)initWithFrame:(CGRect)frame  {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [self navigationController:[[YCNetworkEmvironmentViewController alloc] init]];
    }
    return self;
}

@end
