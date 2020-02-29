//
//  YCAssistiveDefine.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import <Foundation/Foundation.h>

//宏定义
#define weak(object) __weak __typeof(object)weak = object;
#define strong(object) __weak __typeof(object)object = weak;

#define AS_ScreenWidth      [UIScreen mainScreen].bounds.size.width
#define AS_ScreenHeight     [UIScreen mainScreen].bounds.size.height

#define YCMethodNotImplemented() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
userInfo:nil]

#define YCPluginWindow(cls) \
[[cls alloc] initWithFrame:[UIScreen mainScreen].bounds]

CF_EXPORT void YCSwizzleInstanceMethod(Class cls, SEL originalSelector, SEL swizzledSelector);

extern NSString *const kAppEnvironmentApiKey;

//常量定义
extern NSString *const kYCAssistiveMemoryLeakKey;
extern NSString *const kYCAssistiveRetainCycleKey;
