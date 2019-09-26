//
//  YCLargeImagePluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import "YCLargeImagePluginWindow.h"
#import "YCLargeImageViewController.h"
@implementation YCLargeImagePluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [self navigationController:[[YCLargeImageViewController alloc] init]];
    }
    return self;
}


@end
