//
//  YCAssitiveWindowFactory.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCAssitiveWindowFactory.h"

@implementation YCAssitiveWindowFactory

+ (YCAssistiveHomeWindow *)pluginHomeWindow {
    
    return (YCAssistiveHomeWindow *)[self createWindowWithClassName:NSStringFromClass(YCAssistiveHomeWindow.class)];
}

+ (YCScreenShotWindow *)screenShotWindow {
    return (YCScreenShotWindow *)[self createWindowWithClassName:NSStringFromClass([YCScreenShotWindow class])];
}

+ (YCColorSnapWindow *)colorSnapWindow {
    
    return (YCColorSnapWindow *)[self createWindowWithClassName:NSStringFromClass(YCColorSnapWindow.class)];
}

+ (YCNetworkEnvironmentWindow *)networkEnvironmentWindow {
    return (YCNetworkEnvironmentWindow *)[self createWindowWithClassName:NSStringFromClass(YCNetworkEnvironmentWindow.class)];
}

+ (YCURLPluginWindow *)urlPluginWindow {
    return (YCURLPluginWindow *)[self createWindowWithClassName:NSStringFromClass(YCURLPluginWindow.class)];
}

+ (YCCrashPluginWindow *)crashPluginWindow {
    return (YCCrashPluginWindow *)[self createWindowWithClassName:NSStringFromClass(YCCrashPluginWindow.class)];
}

+ (YCLoggerPluginWindow *)loggerPluginWindow {
    
    return (YCLoggerPluginWindow *)[self createWindowWithClassName:NSStringFromClass(YCLoggerPluginWindow.class)];
}

+ (YCMemoryLeaksPluginWindow *)leaksPluginWindow {
    return (YCMemoryLeaksPluginWindow *)[self createWindowWithClassName:NSStringFromClass(YCMemoryLeaksPluginWindow.class)];
}

+ (YCAppInfoPluginWindow *)appInfoPluginWindow {
    
    return (YCAppInfoPluginWindow *)[self createWindowWithClassName:NSStringFromClass(YCAppInfoPluginWindow.class)];
}

+ (YCAssistiveDebuggerPluginWindow *)debuggerPluginWindow {
    
    return (YCAssistiveDebuggerPluginWindow *)[self createWindowWithClassName:NSStringFromClass(YCAssistiveDebuggerPluginWindow.class)];
}

+ (YCLargeImagePluginWindow *)largeImagePluginWindow {
    
    return (YCLargeImagePluginWindow *)[self createWindowWithClassName:NSStringFromClass(YCLargeImagePluginWindow.class)];
}

+ (YCAssistiveBaseWindow *)createWindowWithClassName:(NSString *)className {
    NSAssert(className, ([NSString stringWithFormat:@"%@ can't register a class.",className]));
    Class cls = NSClassFromString(className);
    __block YCAssistiveBaseWindow *window = nil;
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            window = [[cls alloc] initWithFrame:[UIScreen mainScreen].bounds];
        });
    } else {
        window = [[cls alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    NSAssert([window isKindOfClass:[YCAssistiveBaseWindow class]], ([NSString stringWithFormat:@"%@ isn't a YCAssistiveBaseWindow class",className]));
    return window;
}

@end
