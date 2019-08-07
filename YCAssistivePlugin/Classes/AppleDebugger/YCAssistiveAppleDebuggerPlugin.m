//
//  YCAssistiveAppleDebuggerPlugin.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/26.
//

#import "YCAssistiveAppleDebuggerPlugin.h"
#import "YCAssistiveAppleDebuggerView.h"

@implementation YCAssistiveAppleDebuggerPlugin

#if DEBUG
+ (void)load {
    [self registerPlugin];
}
#endif


+ (NSString *)title {
    return @"VC plugin";
}

+ (NSInteger)sortNumber {
    return 1;
}

+ (void)reactTapForAssistantView:(YCAssistiveDisplayView *)displayView {
    
    [displayView reactTapWithCls:[YCAssistiveAppleDebuggerView class]];
}

@end
