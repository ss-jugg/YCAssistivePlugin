//
//  YCAssistiveMemoryHelper.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveMemoryHelper : NSObject
/**
 已使用内存，MB
 
 @return MB
 */
+ (double)usedMemory;

/**
 可使用内存
 
 @return MB
 */
+ (double)availableMemory;

/**
 cpu使用率
 
 @return 使用率
 */
+ (float)cpuUsage;
@end

NS_ASSUME_NONNULL_END
