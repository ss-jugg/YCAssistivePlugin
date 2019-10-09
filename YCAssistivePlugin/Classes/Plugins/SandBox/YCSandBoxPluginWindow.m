//
//  YCSandBoxPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/8.
//

#import "YCSandBoxPluginWindow.h"
#import "YCSandBoxViewController.h"
@implementation YCSandBoxPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [self navigationControllerByClass:YCSandBoxViewController.class];
    }
    return self;
}

@end
