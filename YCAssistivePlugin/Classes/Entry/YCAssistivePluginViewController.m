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
#import "YCScreenShotPlugin.h"
#import "YCColorSnapPlugin.h"
#import "YCAssistiveDebuggerPlugin.h"
#import "YCNetworkEnvironmentPlugin.h"
#import "YCURLPlugin.h"

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

#pragma mark - 配置插件
- (NSArray *)pluginItems {
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    //截图
    YCAssistivePluginItem *screenshotItem = [YCAssistivePluginItem pluginItemWithType:YCAssistivePluginTypeScreenShot imageName:@"icon_button_screenshot"];
    screenshotItem.plugin = [[YCScreenShotPlugin alloc] init];
    [items addObject:screenshotItem];
    
    //环境切换
    YCAssistivePluginItem *switcherItem = [YCAssistivePluginItem pluginItemWithType:YCAssistivePluginTypeHierarchy imageName:@"icon_button_switcher"];
    switcherItem.plugin = [[YCNetworkEnvironmentPlugin alloc] init];
    [items addObject:switcherItem];
    
    //网络
    YCAssistivePluginItem *networkItem = [YCAssistivePluginItem pluginItemWithType:YCAssistivePluginTypePerformance imageName:@"icon_button_network"];
    networkItem.plugin = [[YCURLPlugin alloc] init];
    [items addObject:networkItem];
    
    //定位当前视图VC
    YCAssistivePluginItem *findVCItem = [YCAssistivePluginItem pluginItemWithType:YCAssistivePluginTypeFindVC imageName:@"icon_button_findVC"];
    findVCItem.plugin = [[YCAssistiveDebuggerPlugin alloc] init];
    [items addObject:findVCItem];
    
    return items.copy;
}

#pragma mark - view
- (YCAssistiveTouch *)assisticeTouch {
    
    if (_assisticeTouch == nil) {
        _assisticeTouch = [[YCAssistiveTouch alloc] initWithPluginItems:[self pluginItems]];
        _assisticeTouch.tapSubject = [RACSubject subject];
        [_assisticeTouch.tapSubject subscribeNext:^(id  _Nullable x) {
            [[YCAssistiveManager sharedManager] showHomeWindow];
        }];
    }
    return _assisticeTouch;
}


@end
