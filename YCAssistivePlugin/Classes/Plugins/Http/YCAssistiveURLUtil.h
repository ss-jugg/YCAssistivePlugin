//
//  YCAssistiveURLUtil.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveURLUtil : NSObject

+ (NSString *)convertJsonFromData:(NSData *)data;

+ (NSUInteger)getRequestLength:(NSURLRequest *)request;

+ (NSUInteger)getHeadersLength:(NSDictionary *)headers;

+ (NSDictionary<NSString *, NSString *> *)getCookies:(NSURLRequest *)request ;

+ (NSUInteger)getResponseLength:(NSHTTPURLResponse *)response data:(NSData *)responseData;

+ (NSData *)getHttpBodyFromRequest:(NSURLRequest *)request;

// byte格式化为 B KB MB 方便流量查看
+ (NSString *)formatByte:(CGFloat)byte;

@end

NS_ASSUME_NONNULL_END
