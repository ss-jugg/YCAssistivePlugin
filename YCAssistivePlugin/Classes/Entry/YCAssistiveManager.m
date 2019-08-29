//
//  YCAssistiveManager.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "YCAssistiveManager.h"
#import "YCNetworkEnvironment.h"
#import "YCAssistiveSessionProtocol.h"
#import "YCAssistivePluginViewController.h"
#import "YCAssistiveCrashPlugin.h"
#import <YCLogger/YCLogger.h>

@interface YCAssistiveManager ()<YCAssistiveWindowDelegate>

@property (nonatomic, assign) BOOL yc_canBecomeKeyWindow;

/* 原始window */
@property (nonatomic, strong, readwrite) UIWindow *originWindow;
/* 辅助window */
@property (nonatomic, strong, readwrite) YCAssistiveWindow *assistiveWindow;
/* 控制器 */
@property (nonatomic, strong) YCAssistivePluginViewController *pluginViewController;

@end

@implementation YCAssistiveManager

+ (instancetype)sharedManager {
    
    static YCAssistiveManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCAssistiveManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.yc_canBecomeKeyWindow = NO;
        //支持摇一摇显示
        [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    }
    return self;
}

- (void)installPlugins {
    
    //开启日志
    [[YCLoggerManager shareManager] startLogger];
    
    //开启crash捕捉
    [[YCAssistiveCrashPlugin sharedPlugin] install];
    
    //开启切换环境
    [[YCNetworkEnvironment sharedInstance] install];
    
    //开启网络监测
    [YCAssistiveSessionProtocol startInterceptor];
    
}

#pragma mark - public
- (void)showAssistive {

    self.assistiveWindow.hidden = NO;
}

- (void)hideAssistive {
    
    self.assistiveWindow.hidden = YES;
}

- (void)makeAssistiveWindowAsKeyWindow {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!self.yc_canBecomeKeyWindow && keyWindow != self.assistiveWindow) {
        self.originWindow = keyWindow;
        [keyWindow resignFirstResponder];
        [self.assistiveWindow makeKeyWindow];
        self.yc_canBecomeKeyWindow = YES;
    }
}

- (void)revokeToOriginKeyWindow {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (self.yc_canBecomeKeyWindow && keyWindow == self.assistiveWindow) {
        [keyWindow resignFirstResponder];
        [self.originWindow makeKeyWindow];
        self.yc_canBecomeKeyWindow = NO;
    }
}

#pragma mark - YCAssistiveWindowDelegate
- (BOOL)window:(YCAssistiveWindow *)window shouldHandleTouchAtPoint:(CGPoint)pointInWindow {
    return [self.pluginViewController shouldHandleTouchAtPoint:pointInWindow];
}

- (BOOL)canBecomeKeyWindow:(YCAssistiveWindow *)window {
    return self.yc_canBecomeKeyWindow;
}

#pragma mark - getter
- (YCAssistiveWindow *)assistiveWindow {
    
    if (_assistiveWindow == nil) {
        _assistiveWindow = [[YCAssistiveWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _assistiveWindow.rootViewController = self.pluginViewController;
        _assistiveWindow.yc_delegate = self;
    }
    return _assistiveWindow;
}

- (YCAssistivePluginViewController *)pluginViewController {
    
    if (_pluginViewController == nil) {
        _pluginViewController = [[YCAssistivePluginViewController alloc] init];
        
    }
    return _pluginViewController;
}
@end
