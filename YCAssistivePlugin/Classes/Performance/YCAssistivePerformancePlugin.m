//
//  YCAssistivePerformancePlugin.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/15.
//

#import "YCAssistivePerformancePlugin.h"
#import "YCAssistivePerformanceView.h"

@implementation YCAssistivePerformancePlugin

#if DEBUG
+ (void)load {
    [self registerPlugin];
}
#endif

+ (NSString *)title {
    return @"performance plugin";
}
+ (NSInteger)sortNumber {
    return 2;
}
+ (void)reactTapForAssistantView:(YCAssistiveDisplayView *)assistiveTouch {
    [assistiveTouch reactTapWithCls:[YCAssistivePerformanceView class]];
}
@end
