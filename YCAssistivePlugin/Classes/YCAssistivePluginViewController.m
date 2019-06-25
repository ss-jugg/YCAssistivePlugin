//
//  YCAssistivePluginViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import "YCAssistivePluginViewController.h"
#import "YCAssistivePluginCenterViewController.h"
#import "YCAssistiveTouch.h"
#import "YCAssistiveMacro.h"
#import <ReactiveObjC/ReactiveObjC.h>

static NSString *rotationAnimationKey = @"TabBarButtonTransformRotationAnimationKey";

@interface YCAssistivePluginViewController ()

/* 辅助 */
@property (nonatomic, strong) YCAssistiveTouch *assisticeTouch;

@end

@implementation YCAssistivePluginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.assisticeTouch];
}

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow {
    
    BOOL shouldHandleTouch = NO;
    if (CGRectContainsPoint(self.assisticeTouch.frame, pointInWindow)) {
        shouldHandleTouch = YES;
    }
    if (self.presentedViewController) {
        shouldHandleTouch = YES;
    }
    return shouldHandleTouch;
}

- (YCAssistiveTouch *)assisticeTouch {
    
    if (_assisticeTouch == nil) {
        _assisticeTouch = [[YCAssistiveTouch alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([UIScreen mainScreen].bounds)/2.0 - kAssistiveTouchW/2.0, kAssistiveTouchW, kAssistiveTouchW)];
        _assisticeTouch.tapSubject = [RACSubject subject];
        _assisticeTouch.longPressSubject = [RACSubject subject];
        weak(self);
        [_assisticeTouch.tapSubject subscribeNext:^(id  _Nullable x) {
            strong(self);
            if (!self.presentedViewController) {
                YCAssistivePluginCenterViewController *centerVC = [[YCAssistivePluginCenterViewController alloc] init];
                [self presentViewController:centerVC animated:YES completion:nil];
            }
        }];
    }
    return _assisticeTouch;
}

@end
