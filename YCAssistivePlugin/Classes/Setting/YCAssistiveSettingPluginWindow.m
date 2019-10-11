//
//  YCAssistiveSettingPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/11.
//

#import "YCAssistiveSettingPluginWindow.h"

@implementation YCAssistiveSettingPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.rootViewController = [self navigationControllerByClass:NSClassFromString(@"YCAssistiveSettingViewController")];
    }
    return self;
}

@end
