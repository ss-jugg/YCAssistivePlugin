//
//  YCAssistiveNetworkManager.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/25.
//

#import "YCAssistiveNetworkManager.h"
#import "YCNetworkInterceptor.h"
@interface YCAssistiveNetworkManager ()<YCNetworkInterceptorDelegate>
{
    dispatch_semaphore_t semaphore;
}
@property (nonatomic, strong, readwrite) NSMutableArray<YCAssistiveHttpModel *> *httpModels;
@end

@implementation YCAssistiveNetworkManager


+ (instancetype)shareManager {
    
    static YCAssistiveNetworkManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCAssistiveNetworkManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.httpModels = [[NSMutableArray alloc] init];
        semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)setCanIntercept:(BOOL)canIntercept {
    
    _canIntercept = canIntercept;
    if (canIntercept) {
        [[YCNetworkInterceptor shareInterceptor] addInterceptor:self];
    }else {
        [[YCNetworkInterceptor shareInterceptor] removeInterceptor:self];
    }
}

- (void)clearAll {
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.httpModels removeAllObjects];
    dispatch_semaphore_signal(semaphore);
}

#pragma mark - YCNetworkInterceptorDelegate
- (BOOL)shouldInterceptor {
    return _canIntercept;
}

- (void)interceptorDidReceiveData:(NSData *)responseData task:(NSURLSessionDataTask *)task startTime:(NSTimeInterval)startTime {
    
    NSURLRequest *request = task.originalRequest?:task.currentRequest;
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    YCAssistiveHttpModel *model = [YCAssistiveHttpModel httpModelWithResponseData:responseData response:response request:request];
    model.httpIndentifier = @(task.taskIdentifier).stringValue;
    model.startTime = [NSString stringWithFormat:@"%fs",startTime];
    model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - startTime];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.httpModels addObject:model];
    dispatch_semaphore_signal(semaphore);
}



@end
