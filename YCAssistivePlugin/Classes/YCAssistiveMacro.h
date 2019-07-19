//
//  YCAssistiveMacro.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import <Foundation/Foundation.h>

extern NSString *const kYCAssistiveMemoryLeakKey;
extern NSString *const kYCAssistiveRetainCycleKey;

#define weak(object) __weak __typeof(object)weak = object;
#define strong(object) __weak __typeof(object)object = weak;

CF_EXPORT void YCSwizzleInstanceMethod(Class cls, SEL originalSelector, SEL swizzledSelector);

extern NSString *const kAppEnvironmentApiKey;

@interface YCAssistiveMacro : NSObject

+ (BOOL)debug;
+ (void)debugExecute:(void(^)(void))debugExecute elseExecute:(void(^)(void))elseExecute;

@end

