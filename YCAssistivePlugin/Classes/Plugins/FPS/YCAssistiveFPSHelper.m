//
//  YCAssistiveFPSHelper.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveFPSHelper.h"

@interface YCAssistiveFPSHelper ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;

@property (nonatomic, copy) FPSBlock fpsBlock;

@end

@implementation YCAssistiveFPSHelper

+ (instancetype)fpsWithBlock:(FPSBlock)block {
    
    YCAssistiveFPSHelper *helper = [[YCAssistiveFPSHelper alloc] init];
    helper.fpsBlock = block;
    return helper;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.count = 0;
        self.lastTime = 0;
    }
    return self;
}

- (void)startFPS {
    
    if (self.displayLink) {
        self.displayLink.paused = YES;
    }else {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)endFPS {
    
    if (self.displayLink) {
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
        self.displayLink = nil;
        self.count = 0;
        self.lastTime = 0;
    }
}

- (void)displayLinkTick:(CADisplayLink *)link {
    
    if (self.lastTime == 0) {
        self.lastTime = link.timestamp;
        return;
    }
    self.count++;
    NSTimeInterval delta = link.timestamp - self.lastTime;
    if (delta < 1) return;
    self.lastTime = link.timestamp;
    CGFloat fps = self.count / delta;
    self.count = 0;
    NSInteger intFps = (NSInteger)(fps+0.5);
    if (self.fpsBlock) {
        self.fpsBlock(intFps);
    }
}

@end
