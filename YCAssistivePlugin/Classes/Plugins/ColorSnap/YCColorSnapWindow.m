//
//  YCColorSnapWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCColorSnapWindow.h"
#import "YCAssistiveColorSnapViewController.h"
@implementation YCColorSnapWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.rootViewController = [[YCAssistiveColorSnapViewController alloc] init];
    }
    return self;
}

- (BOOL)yc_canBecomeKeyWindow {
    return NO;
}

@end
