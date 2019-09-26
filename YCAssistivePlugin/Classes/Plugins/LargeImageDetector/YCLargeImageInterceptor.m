//
//  YCLargeImageInterceptor.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import "YCLargeImageInterceptor.h"
#import "YCNetworkInterceptor.h"
#import "YCAssistiveURLUtil.h"

@interface YCLargeImageInterceptor ()<YCNetworkInterceptorDelegate>
{
    dispatch_semaphore_t semaphore;
}
@end

@implementation YCLargeImageInterceptor

+ (instancetype)shareInterceptor {
    
    static YCLargeImageInterceptor *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCLargeImageInterceptor alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.images = [[NSMutableArray alloc] init];
        self.minimumSize = 200 * 1024;
        self.canIntercept = NO;
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

- (void)addImageModel:(YCLargeImageModel *)imageModel {
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (![self.images containsObject:imageModel]) {
        [self.images insertObject:imageModel atIndex:0];
    }
    dispatch_semaphore_signal(semaphore);
}

- (void)removeAllImages {
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.images removeAllObjects];
    dispatch_semaphore_signal(semaphore);
}

#pragma mark - YCNetworkInterceptorDelegate
- (BOOL)shouldInterceptor {
    return _canIntercept;
}

- (void)interceptorDidReceiveData:(NSData *)responseData task:(NSURLSessionDataTask *)task startTime:(NSTimeInterval)startTime {
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    if (![response.MIMEType hasPrefix:@"image/"]) {
        return;
    }
    NSInteger byte = [YCAssistiveURLUtil getResponseLength:response data:responseData];
    if (byte < self.minimumSize) {
        return;
    }
    NSURLRequest *request = task.originalRequest?:task.currentRequest;
    YCLargeImageModel *model = [[YCLargeImageModel alloc] init];
    model.url = request.URL;
    model.imageData = responseData;
    model.size = [NSByteCountFormatter stringFromByteCount:byte countStyle: NSByteCountFormatterCountStyleBinary];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self addImageModel:model];
    dispatch_semaphore_signal(semaphore);
}

@end
