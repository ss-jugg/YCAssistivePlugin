//
//  YCAssistiveManager.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import "YCAssistiveManager.h"
#import "YCNetworkEnvironment.h"
#import "YCAssistiveCrashPlugin.h"
//#import <YCLogger/YCLogger.h>
#import "YCScreenShotHelper.h"
#import "YCAssistiveNetworkManager.h"
#import "YCLargeImageInterceptor.h"
#import "YCAssistiveLeaksManager.h"
#import "YCAssistiveCache.h"
#import "YCAssistiveDefine.h"
@interface YCAssistiveManager ()

/* 避免重复 */
@property (nonatomic, assign) BOOL hasInstalled;

/* 原始window */
@property (nonatomic, strong, readwrite) UIWindow *keyWindow;
/* 辅助window */
@property (nonatomic, strong, readwrite) YCAssistiveWindow *assistiveWindow;

@property (nonatomic, strong) NSMutableArray *visibleWindows;

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
        self.hasInstalled = NO;
        //支持摇一摇显示
        [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
        self.visibleWindows = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)installPlugins {
    
    //保证installPlugins只执行一次
    if (self.hasInstalled) {
        return;
    }
    self.hasInstalled = YES;
    //开启日志
//    [[YCLoggerManager shareManager] startLogger];
    
    //开启crash捕捉
    [[YCAssistiveCrashPlugin sharedPlugin] install];
    
    //开启切换环境
    [[YCNetworkEnvironment sharedInstance] install];
    
    //开启网络检测
    [[YCAssistiveNetworkManager shareManager] setCanIntercept:YES];
    
    //大图检测
    BOOL isLargeImageDetectionOn = [[YCAssistiveCache shareInstance] largeImageDetectionSwitch];
    [[YCLargeImageInterceptor shareInterceptor] setCanIntercept:isLargeImageDetectionOn];
    
    //内存泄漏检测
    BOOL isLeakDetectionOn = [[YCAssistiveCache shareInstance] leakDetectionSwitch];
    [[YCAssistiveLeaksManager shareManager] setEnableLeaks:isLeakDetectionOn];
    
    //开启网络日志
    BOOL isAPILogger = [[YCAssistiveCache shareInstance] APILoggerSwitch];
//    YCAPILoggerEnabled = isAPILogger;

    [[YCScreenShotHelper sharedInstance] setEnable:YES];
}

#pragma mark - public
- (void)showHomeWindow {
    [self addWindow:YCPluginWindow(NSClassFromString(@"YCAssistiveHomeWindow")) completion:nil];
}
- (void)showAssistive {
    [self addWindow:self.assistiveWindow completion:nil];
}

- (void)hideAssistive {
    [self removeVisibleWindow:self.assistiveWindow automaticallyShow:NO completion:nil];
}

- (void)showPluginWindow:(YCAssistiveBaseWindow *)window {
    [self showPluginWindow:window completion:nil];
}

- (void)showPluginWindow:(YCAssistiveBaseWindow *)window completion:(void(^)(void))completion {
    [self addWindow:window completion:completion];
}

- (void)addWindow:(YCAssistiveBaseWindow *)window completion:(void(^)(void))completion {
    
    if (!window) {
        return;
    }
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addWindow:window completion:completion];
        });
        return;
    }
    [self removeAllVisibleWindows];
    window.hidden = NO;
    if (window == self.assistiveWindow) {
        [self.keyWindow makeKeyWindow];
        self.keyWindow = nil;
    }else {
        if (![[UIApplication sharedApplication].keyWindow isKindOfClass:[YCAssistiveBaseWindow class]]) {
            self.keyWindow = [UIApplication sharedApplication].keyWindow;
        }
        if ([window yc_canBecomeKeyWindow]) {
            [window makeKeyAndVisible];
        }else {
            [self.keyWindow makeKeyAndVisible];
            self.keyWindow = nil;
        }
    }
    [self.visibleWindows addObject:window];
    
    [UIView animateWithDuration:0.25 animations:^{
        window.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)removeVisibleWindow:(YCAssistiveBaseWindow *)window automaticallyShow:(BOOL)isAutomaticallyShow completion:(void(^)(void))completion {
    
    if (!window) {
        return;
    }
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeVisibleWindow:window automaticallyShow:isAutomaticallyShow completion:completion];
        });
        return;
    }
    [self.visibleWindows removeObject:window];
    if (self.visibleWindows.count == 0 && isAutomaticallyShow) {
        [self showAssistive];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        window.hidden = YES;
    }];
}

- (void)removeAllVisibleWindows {
    
    for (YCAssistiveBaseWindow *window in self.visibleWindows) {
        [self removeVisibleWindow:window automaticallyShow:NO completion:nil];
    }
    [self.visibleWindows removeAllObjects];
}

#pragma mark - getter
- (YCAssistiveWindow *)assistiveWindow {
    
    if (_assistiveWindow == nil) {
        _assistiveWindow = [[YCAssistiveWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _assistiveWindow;
}
@end
