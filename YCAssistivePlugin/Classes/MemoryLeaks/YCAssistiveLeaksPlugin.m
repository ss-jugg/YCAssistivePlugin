//
//  YCAssistiveLeaksPlugin.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/16.
//

#import "YCAssistiveLeaksPlugin.h"
#import "YCAssistiveLeaksView.h"

@implementation YCAssistiveLeaksPlugin
+ (void)load {
    [self registerPlugin];
}
+ (NSString *)title {
    return @"memory leaks plugin";
}
+ (NSInteger)sortNumber {
    return 3;
}
+ (void)reactTapForAssistantView:(YCAssistiveDisplayView *)assistiveTouch {
    [assistiveTouch reactTapWithCls:[YCAssistiveLeaksView class]];
}
@end
