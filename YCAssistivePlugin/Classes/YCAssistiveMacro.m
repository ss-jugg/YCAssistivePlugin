//
//  YCAssistiveMacro.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import "YCAssistiveMacro.h"
#import <objc/runtime.h>

void YCSwizzleInstanceMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    BOOL didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

NSString *const kAppEnvironmentApiKey = @"kAppEnvironmentApiKey";

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
