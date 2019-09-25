//
//  YCAssistiveMacro.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import "YCAssistiveMacro.h"


@implementation YCAssistiveMacro

+ (BOOL)debug {
    
#if DEBUG
    return YES;
#else
    return NO;
#endif
    
}

+ (void)debugExecute:(void(^)(void))debugExecute elseExecute:(void(^)(void))elseExecute {
    
    if ([self debug]) {
        !debugExecute ? : debugExecute();
    }else {
        !elseExecute ? : elseExecute();
    }
}
@end
