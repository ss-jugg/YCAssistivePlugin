//
//  YCAssistiveManager.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "YCAssistiveManager.h"
#import "YCAssistivePluginViewController.h"
@interface YCAssistiveManager ()<YCAssistiveWindowDelegate>

/* <#mark#> */
@property (nonatomic, assign) BOOL yc_canBecomeKeyWindow;

/* 原始window */
@property (nonatomic, strong) UIWindow *originWindow;
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

#pragma mark - public
- (void)showAssistive {

    if (!self.yc_canBecomeKeyWindow) {
        [self makeAssistiveWindowKeyWindow];
    }
    self.assistiveWindow.hidden = NO;
}

- (void)hideAssistive {
    
    if (self.yc_canBecomeKeyWindow) {
        self.yc_canBecomeKeyWindow = NO;
        [self returnToOriginKeyWindow];
    }
    self.assistiveWindow.hidden = YES;
}

- (void)makeAssistiveWindowKeyWindow {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow != self.assistiveWindow) {
        self.originWindow = keyWindow;
        [keyWindow resignFirstResponder];
        [self.assistiveWindow makeKeyWindow];
        self.yc_canBecomeKeyWindow = YES;
    }
}

- (void)returnToOriginKeyWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow == self.assistiveWindow) {
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
