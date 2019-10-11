//
//  YCAssistiveCache.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveCache : NSObject

+ (YCAssistiveCache *)shareInstance;

- (void)saveFPSSwitch:(BOOL)isOn;
- (BOOL)fpsSwitch;

- (void)saveCPUSwitch:(BOOL)isOn;
- (BOOL)cpuSwitch;

- (void)saveMemorySwitch:(BOOL)isOn;
- (BOOL)memorySwitch;

- (void)saveLeakDetectionSwitch:(BOOL)isOn;
- (BOOL)leakDetectionSwitch;


- (void)saveLargeImageDetectionSwitch:(BOOL)isOn;
- (BOOL)largeImageDetectionSwitch;

- (void)saveViewFrameSwitch:(BOOL)isOn;
- (BOOL)viewFrameSwitch;


@end

NS_ASSUME_NONNULL_END
