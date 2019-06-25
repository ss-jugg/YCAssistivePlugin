//
//  YCAssistiveMacro.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import <Foundation/Foundation.h>

#define ISIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//状态栏高度
#define STATUS_BAR_H [UIApplication sharedApplication].statusBarFrame.size.height
//导航栏高度
#define NAV_BAR_H (STATUS_BAR_H + 44)

#define SCREE_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREE_SAFE_H (ISIphoneX?(SCREE_H-34-NAV_BAR_H):SCREE_H-NAV_BAR_H)

#define weak(object) __weak __typeof(object)weak = object;
#define strong(object) __weak __typeof(object)object = weak;

CF_EXPORT void YCSwizzleInstanceMethod(Class cls, SEL originalSelector, SEL swizzledSelector);

extern NSString *const kPartnerApiKey;
extern NSString *const kDealerApiKey;

@interface YCAssistiveMacro : NSObject

+ (BOOL)debug;
+ (void)debugExecute:(void(^)(void))debugExecute elseExecute:(void(^)(void))elseExecute;

@end

