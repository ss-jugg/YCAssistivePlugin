//
//  YCAssistiveFPSHelper.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FPSBlock)(NSInteger fps);
@interface YCAssistiveFPSHelper : NSObject

- (void)startFPS;
- (void)endFPS;

+ (instancetype)fpsWithBlock:(FPSBlock)block;

@end

NS_ASSUME_NONNULL_END
