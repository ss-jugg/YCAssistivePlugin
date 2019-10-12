//
//  YCAssistiveExceptionCrashHandler.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCAssistiveExceptionCrashHandler.h"
#import "YCAssistiveCrashPlugin.h"

// 记录之前的崩溃回调函数
static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler = NULL;

@implementation YCAssistiveExceptionCrashHandler

+ (void)registerExceptionHandler {
    
    //获取之前注册的回调
    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&assistiveExceptionCrashHandler);
}

static void assistiveExceptionCrashHandler(NSException *exception) {
    
    [[YCAssistiveCrashPlugin sharedPlugin] saveException:exception];
    if (previousUncaughtExceptionHandler) {
        previousUncaughtExceptionHandler(exception);
    }
    kill(getpid(), SIGKILL);
}

@end
