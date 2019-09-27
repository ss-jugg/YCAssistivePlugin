//
//  YCAssistiveMemoryPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveMemoryPluginWindow.h"
#import "YCAssistiveMemoryViewController.h"
@implementation YCAssistiveMemoryPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [[YCAssistiveMemoryViewController alloc] init];
    }
    return self;
}

@end
