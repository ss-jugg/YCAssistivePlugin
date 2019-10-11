//
//  YCAssistiveUtil.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveUtil : NSObject


/**
 计算文件大小

 @param filePath 文件路径
 @return 文件大小
 */
+ (NSUInteger)fetchFileSizeAtPath:(NSString *)filePath;

/**
 格式化流量显示

 @param byte 流量
 @return 格式化
 */
+ (NSString *)formatByte:(CGFloat)byte;

@end

NS_ASSUME_NONNULL_END
