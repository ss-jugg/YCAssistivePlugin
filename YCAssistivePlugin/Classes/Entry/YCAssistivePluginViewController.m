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
#import <ReactiveObjC/ReactiveObjC.h>
#import "YCScreenShotHelper.h"
#import "YCScreenShotPreviewViewController.h"
#import "YCAssistivePluginItem.h"
#import "YCAssistiveAppleDebuggerView.h"
#import "YCAssistivePerformanceView.h"

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
    if ((CGRectContainsPoint(self.assisticeTouch.frame, pointInWindow) || [self.assisticeTouch  hitTest:[self.assisticeTouch convertPoint:pointInWindow fromView:nil] withEvent:nil]) && !self.assisticeTouch.hidden) {
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

#pragma mark - 配置插件
- (NSArray *)pluginItems {
    
    //截图
    YCAssistivePluginItem *screenshotItem = [YCAssistivePluginItem pluginItemWithType:YCAssistivePluginTypeScreenShot imageName:@"icon_button_screenshot"];
    weak(self);
    [screenshotItem.tapSubject subscribeNext:^(id  _Nullable x) {
        strong(self);
        YCScreenShotPreviewViewController *previewVC = [[YCScreenShotPreviewViewController alloc] init];
        previewVC.shotImage = [[YCScreenShotHelper sharedInstance] imageFromCurrentScreen];
        [self presentViewController:previewVC animated:YES completion:nil];
    }];
    //定位当前视图VC
    YCAssistivePluginItem *findVCItem = [YCAssistivePluginItem pluginItemWithType:YCAssistivePluginTypeFindVC imageName:@"icon_button_findVC"];
    [findVCItem.tapSubject subscribeNext:^(id  _Nullable x) {
        strong(self);
        [self.displayView reactTapWithCls:[YCAssistiveAppleDebuggerView class]];
    }];
    //查看视图层级
    YCAssistivePluginItem *hierarchyItem = [YCAssistivePluginItem pluginItemWithType:YCAssistivePluginTypeHierarchy imageName:@"icon_button_hierarchy"];
    [hierarchyItem.tapSubject subscribeNext:^(id  _Nullable x) {
        strong(self);
        
    }];
    //性能检测
    YCAssistivePluginItem *performanceItem = [YCAssistivePluginItem pluginItemWithType:YCAssistivePluginTypePerformance imageName:@"icon_button_performance"];
    [performanceItem.tapSubject subscribeNext:^(id  _Nullable x) {
        strong(self);
        [self.displayView reactTapWithCls:[YCAssistivePerformanceView class]];
    }];
    return @[screenshotItem,findVCItem,hierarchyItem,performanceItem];
}

#pragma mark - view
- (YCAssistiveTouch *)assisticeTouch {
    
    if (_assisticeTouch == nil) {
        _assisticeTouch = [[YCAssistiveTouch alloc] initWithPluginItems:[self pluginItems]];
        _assisticeTouch.tapSubject = [RACSubject subject];
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

- (YCAssistiveDisplayView *)displayView {
    
    if (_displayView == nil) {
        _displayView = [[YCAssistiveDisplayView alloc] initWithFrame:CGRectMake(0, 100, 150, 150)];
        _displayView.hidden = YES;
    }
    return _displayView;
}

@end
