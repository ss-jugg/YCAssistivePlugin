//
//  YCAssistiveSessionConfigurationSwizzle.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import "YCAssistiveSessionConfigurationSwizzle.h"
#import <objc/runtime.h>
#import "YCAssistiveSessionProtocol.h"
@implementation YCAssistiveSessionConfigurationSwizzle

+ (instancetype)sharedInstance {
    static YCAssistiveSessionConfigurationSwizzle *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCAssistiveSessionConfigurationSwizzle alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.swizzling = NO;
    }
    return self;
}


- (void)sw_protocolClasses {
    
    self.swizzling=YES;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
    
}

- (void)unsw_protocolClasses {
    
    self.swizzling=NO;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub {
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    // 如果还有其他的监控protocol，也可以在这里加进去
    return @[[YCAssistiveSessionProtocol class]];
}


@end
