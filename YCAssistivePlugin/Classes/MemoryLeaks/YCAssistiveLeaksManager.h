//
//  YCAssistiveLeaksManager.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveMeomryLeakModel : NSObject

/* 内存泄漏类 */
@property (nonatomic, copy) NSString *className;
/* 泄漏内容 */
@property (nonatomic, copy) NSString *viewStackContent;
/* 是否循环引用 */
@property (nonatomic, assign) BOOL isRetainCycle;
/* 循环引用对象树 */
@property (nonatomic, copy) NSString *retainCycleContent;
@end

@interface YCAssistiveLeaksManager : NSObject

/* 是否检测内存泄漏,默认YES */
@property (nonatomic, assign) BOOL enableLeaks;
/* 是否开启循环引用检测，默认YES */
@property (nonatomic, assign) BOOL enableRetainCycle;

@property (nonatomic, strong, readonly) NSMutableArray *leakObjects;

+ (instancetype)shareManager;

- (void)addLeakObject:(YCAssistiveMeomryLeakModel *)leakObj;

@end

NS_ASSUME_NONNULL_END
