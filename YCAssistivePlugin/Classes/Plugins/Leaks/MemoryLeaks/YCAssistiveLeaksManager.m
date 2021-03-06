//
//  YCAssistiveLeaksManager.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/16.
//

#import "YCAssistiveLeaksManager.h"
#import "YCAssistiveMeomryLeakModel.h"
#import "YCAssistiveMacro.h"

@interface YCAssistiveLeaksManager ()
/* 内存泄漏对象 */
@property (nonatomic, strong, readwrite) NSMutableArray *leakObjects;
@end
@implementation YCAssistiveLeaksManager

+ (instancetype)shareManager {

    static YCAssistiveLeaksManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCAssistiveLeaksManager alloc] init];
        _instance.leakObjects = [[NSMutableArray alloc] init];
    });
    return _instance;
}

- (void)addLeakObject:(YCAssistiveMeomryLeakModel *)leakObj {
    [self.leakObjects addObject:leakObj];
}

@end

