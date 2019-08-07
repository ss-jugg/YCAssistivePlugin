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
#import "YCAssistiveDisplayView.h"
#import "YCAssistiveItemPlugin.h"
#import <ReactiveObjC/ReactiveObjC.h>

static NSString *rotationAnimationKey = @"TabBarButtonTransformRotationAnimationKey";

@interface YCAssistivePluginViewController ()

/* 辅助 */
@property (nonatomic, strong) YCAssistiveTouch *assisticeTouch;
/* 展示图 */
@property (nonatomic, strong) YCAssistiveDisplayView *displayView;

@end

@implementation YCAssistivePluginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.assisticeTouch];
    [self.view addSubview:self.displayView];
}

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow {
    
    BOOL shouldHandleTouch = NO;
    if (CGRectContainsPoint(self.assisticeTouch.frame, pointInWindow) && !self.assisticeTouch.hidden) {
        shouldHandleTouch = YES;
    }
    if (CGRectContainsPoint(self.displayView.frame, pointInWindow) && !self.displayView.hidden) {
        shouldHandleTouch = YES;
    }
    if (self.presentedViewController) {
        shouldHandleTouch = YES;
    }
    return shouldHandleTouch;
}


- (void)openPluginItemsDisplayView:(BOOL)needOpen {
    
    self.assisticeTouch.hidden = needOpen;
    self.displayView.hidden = !needOpen;
}

#pragma mark - view
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
        [_assisticeTouch.longPressSubject subscribeNext:^(id  _Nullable x) {
            strong(self)
            [self openPluginItemsDisplayView:YES];
        }];
    }
    return _assisticeTouch;
}

- (YCAssistiveDisplayView *)displayView {
    
    if (_displayView == nil) {
        _displayView = [[YCAssistiveDisplayView alloc] initWithFrame:CGRectMake(0, 100, 150, 150)];
        _displayView.longPressSubject = [RACSubject subject];
        _displayView.hidden = YES;
        weak(self);
        [_displayView.longPressSubject subscribeNext:^(id  _Nullable x) {
            strong(self);
            [self openPluginItemsDisplayView:NO];
        }];
    }
    return _displayView;
}

@end
