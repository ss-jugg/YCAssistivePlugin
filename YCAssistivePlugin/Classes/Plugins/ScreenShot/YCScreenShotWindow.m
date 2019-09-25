//
//  YCScreenShotWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCScreenShotWindow.h"
#import "YCScreenShotPreviewViewController.h"
#import "YCAssistiveManager.h"

@implementation YCScreenShotWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    if (!self.rootViewController) {
        self.rootViewController = [[YCScreenShotPreviewViewController alloc] init];
    }
}

@end
