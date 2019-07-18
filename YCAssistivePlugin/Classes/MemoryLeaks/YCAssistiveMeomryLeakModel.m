//
//  YCAssistiveMeomryLeakModel.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/18.
//

#import "YCAssistiveMeomryLeakModel.h"

@implementation YCAssistiveMeomryLeakModel

- (NSString *)displayText {

    if (self.isRetainCycle) {
        return [self.retainCycle componentsJoinedByString:@""];
    }
    return [self.viewStack componentsJoinedByString:@" -> "];
}

@end
