//
//  YCAssistivePluginViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import "YCAssistivePluginViewController.h"
#import "YCAssistiveTouch.h"
#import "YCAssistiveMacro.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "YCAssistivePluginItem.h"
#import "YCAssistiveManager.h"
#import "YCAssistivePluginFactory.h"

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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint activePoint = [self.view convertPoint:point toView:self.assisticeTouch];
    if ([self.assisticeTouch pointInside:activePoint withEvent:event]) {
        return YES;
    }
    return NO;
}

#pragma mark - view
- (YCAssistiveTouch *)assisticeTouch {
    
    if (_assisticeTouch == nil) {
        _assisticeTouch = [[YCAssistiveTouch alloc] initWithPluginItems:[YCAssistivePluginFactory pluginItems]];
        _assisticeTouch.tapSubject = [RACSubject subject];
        [_assisticeTouch.tapSubject subscribeNext:^(id  _Nullable x) {
            [[YCAssistiveManager sharedManager] showHomeWindow];
        }];
    }
    return _assisticeTouch;
}


@end
