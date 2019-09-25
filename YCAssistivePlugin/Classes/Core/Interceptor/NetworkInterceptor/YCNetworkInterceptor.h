//
//  YCNetworkInterceptor.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YCNetworkInterceptorDelegate <NSObject>

- (BOOL)shouldInterceptor;

- (void)interceptorDidReceiveData:(NSData *)responseData task:(NSURLSessionDataTask *)task startTime:(NSTimeInterval)startTime;

@end

@interface YCNetworkInterceptor : NSObject

@property (nonatomic, assign) BOOL shouldInterceptor;

+ (instancetype)shareInterceptor;

- (void)addInterceptor:(id<YCNetworkInterceptorDelegate>)interceptor;
- (void)removeInterceptor:(id<YCNetworkInterceptorDelegate>)interceptor;
- (void)interceptorDidReceiveData:(NSData *)responseData task:(NSURLSessionDataTask *)task startTime:(NSTimeInterval)startTime;
@end

NS_ASSUME_NONNULL_END
