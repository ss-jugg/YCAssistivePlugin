//
//  YCAssistiveFPSPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveFPSPluginWindow.h"
#import "YCAssistiveFPSViewController.h"

@implementation YCAssistiveFPSPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.rootViewController = [[YCAssistiveFPSViewController alloc] init];
    }
    return self;
}

@end
