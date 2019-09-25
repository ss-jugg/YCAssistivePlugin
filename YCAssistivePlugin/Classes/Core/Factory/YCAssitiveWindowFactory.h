//
//  YCAssitiveWindowFactory.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import <Foundation/Foundation.h>
#import "YCAssistiveHomeWindow.h"
#import "YCScreenShotWindow.h"
#import "YCColorSnapWindow.h"
#import "YCNetworkEnvironmentWindow.h"
#import "YCURLPluginWindow.h"
#import "YCCrashPluginWindow.h"
#import "YCLoggerPluginWindow.h"
#import "YCMemoryLeaksPluginWindow.h"
#import "YCAppInfoPluginWindow.h"
#import "YCAssistiveDebuggerPluginWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCAssitiveWindowFactory : NSObject

+ (YCAssistiveHomeWindow *)pluginHomeWindow;

+ (YCScreenShotWindow *)screenShotWindow;

+ (YCColorSnapWindow *)colorSnapWindow;

+ (YCNetworkEnvironmentWindow *)networkEnvironmentWindow;

+ (YCURLPluginWindow *)urlPluginWindow;

+ (YCCrashPluginWindow *)crashPluginWindow;

+ (YCLoggerPluginWindow *)loggerPluginWindow;

+ (YCMemoryLeaksPluginWindow *)leaksPluginWindow;

+ (YCAppInfoPluginWindow *)appInfoPluginWindow;

+ (YCAssistiveDebuggerPluginWindow *)debuggerPluginWindow;
@end

NS_ASSUME_NONNULL_END