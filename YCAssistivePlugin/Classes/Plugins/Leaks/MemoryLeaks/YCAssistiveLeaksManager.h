//
//  YCAssistiveLeaksManager.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/16.
//

#import <Foundation/Foundation.h>

extern NSString *kYCAssistiveMemoryLeakNotificationName;
@class YCAssistiveMeomryLeakModel;
@interface YCAssistiveLeaksManager : NSObject

/* 是否检测内存泄漏,默认YES */
@property (nonatomic, assign) BOOL enableLeaks;
/* 是否开启循环引用检测，默认YES */
@property (nonatomic, assign) BOOL enableRetainCycle;

@property (nonatomic, strong, readonly) NSMutableArray *leakObjects;

+ (instancetype)shareManager;

- (void)addLeakObject:(YCAssistiveMeomryLeakModel *)leakObj;

@end

