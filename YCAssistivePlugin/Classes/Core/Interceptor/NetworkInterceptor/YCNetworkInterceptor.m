//
//  YCNetworkInterceptor.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/25.
//

#import "YCNetworkInterceptor.h"

@interface YCNetworkInterceptor ()

@property (nonatomic, strong) NSMutableSet *listeners;

@end

@implementation YCNetworkInterceptor

+ (instancetype)shareInterceptor {
    
    static YCNetworkInterceptor *_intance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _intance = [[YCNetworkInterceptor alloc] init];
    });
    return _intance;
}

- (BOOL)shouldInterceptor {
    
    BOOL shouldInterceptor = NO;
    for (id<YCNetworkInterceptorDelegate> delegate in self.listeners) {
        if ([delegate shouldInterceptor]) {
            shouldInterceptor = YES;
        }
    }
    return shouldInterceptor;
}

- (void)addInterceptor:(id<YCNetworkInterceptorDelegate>)interceptor {
    [self.listeners addObject:interceptor];
}

- (void)removeInterceptor:(id<YCNetworkInterceptorDelegate>)interceptor {
    [self.listeners removeObject:interceptor];
}

- (void)interceptorDidReceiveData:(NSData *)responseData task:(NSURLSessionDataTask *)task startTime:(NSTimeInterval)startTime {
    for (id<YCNetworkInterceptorDelegate> delegate in self.listeners) {
        if ([delegate respondsToSelector:@selector(interceptorDidReceiveData:task:startTime:)]) {
            [delegate interceptorDidReceiveData:responseData task:task startTime:startTime];
        }
    }
}

- (NSMutableSet *)listeners {
    
    if (!_listeners) {
        _listeners = [[NSMutableSet alloc] init];
    }
    return _listeners;
}

@end
