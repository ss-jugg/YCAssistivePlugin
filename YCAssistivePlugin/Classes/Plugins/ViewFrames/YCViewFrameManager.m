//
//  YCViewFrameManager.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/11.
//

#import "YCViewFrameManager.h"
#import "UIView+AssistiveFrames.h"
#import "UIColor+AssistiveColor.h"
#import "YCAssistiveCache.h"

@implementation YCViewFrameManager

+ (instancetype)defaultManager {
    
    static YCViewFrameManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YCViewFrameManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.enable = [[YCAssistiveCache shareInstance] viewFrameSwitch];
    }
    return self;
}

- (void)setEnable:(BOOL)enable {
    
    _enable = enable;
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        [window as_viewFrameEnable:enable];
    }
}

@end
