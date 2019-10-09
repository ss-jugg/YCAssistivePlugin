//
//  YCAssistiveUtil.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveUtil : NSObject

+ (NSUInteger)fetchFileSizeAtPath:(NSString *)filePath;

// byte格式化为 B KB MB 方便流量查看
+ (NSString *)formatByte:(CGFloat)byte;

@end

NS_ASSUME_NONNULL_END
