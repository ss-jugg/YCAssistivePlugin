//
//  YCAssistiveMacro.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import <Foundation/Foundation.h>
#import "YCAssistiveDefine.h"



@interface YCAssistiveMacro : NSObject

+ (BOOL)debug;
+ (void)debugExecute:(void(^)(void))debugExecute elseExecute:(void(^)(void))elseExecute;

@end

