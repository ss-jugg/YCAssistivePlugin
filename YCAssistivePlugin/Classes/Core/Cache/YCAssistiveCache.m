//
//  YCAssistiveCache.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/8.
//

#import "YCAssistiveCache.h"

static NSString * const kYCAssistiveFPSKey = @"assistive_fps";
static NSString * const kYCAssistiveCPUKey = @"assistive_cpu";
static NSString * const kYCAssistiveMemoryKey = @"assistive_memory";
static NSString * const kYCAssistiveLeakKey = @"assistive_leak";
static NSString * const kYCAssistiveLargeImageDetectionKey = @"assistive_largeImageDetection";
static NSString * const kYCAssistiveScreenShotKey = @"assistive_screenShot";

@interface YCAssistiveCache ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation YCAssistiveCache

+ (YCAssistiveCache *)shareInstance {
    
    static YCAssistiveCache *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YCAssistiveCache alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)saveFPSSwitch:(BOOL)isOn {
    [self.userDefaults setObject:@(isOn) forKey:kYCAssistiveFPSKey];
}
- (BOOL)fpsSwitch {
    return [[self.userDefaults objectForKey:kYCAssistiveFPSKey] boolValue];
}

- (void)saveCPUSwitch:(BOOL)isOn {
    [self.userDefaults setObject:@(isOn) forKey:kYCAssistiveCPUKey];
}
- (BOOL)cpuSwitch {
   return [[self.userDefaults objectForKey:kYCAssistiveCPUKey] boolValue];
}

- (void)saveMemorySwitch:(BOOL)isOn {
    [self.userDefaults setObject:@(isOn) forKey:kYCAssistiveMemoryKey];
}
- (BOOL)memorySwitch {
  return  [[self.userDefaults objectForKey:kYCAssistiveMemoryKey] boolValue];
}

- (void)saveLeakDetectionSwitch:(BOOL)isOn {
    [self.userDefaults setObject:@(isOn) forKey:kYCAssistiveLeakKey];
}
- (BOOL)leakDetectionSwitch {
   return [[self.userDefaults objectForKey:kYCAssistiveLeakKey] boolValue];
}

- (void)saveLargeImageDetectionSwitch:(BOOL)isOn {
    [self.userDefaults setObject:@(isOn) forKey:kYCAssistiveLargeImageDetectionKey];
}
- (BOOL)largeImageDetectionSwitch {
   return [[self.userDefaults objectForKey:kYCAssistiveLargeImageDetectionKey] boolValue];
}


- (void)saveScreenShotSwitch:(BOOL)isOn {
    [self.userDefaults setObject:@(isOn) forKey:kYCAssistiveScreenShotKey];
}
- (BOOL)screenShotSwitch {
    return [[self.userDefaults objectForKey:kYCAssistiveScreenShotKey] boolValue];
}

@end
