//
//  YCAssistiveURLSessionDemux.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import "YCAssistiveURLSessionDemux.h"

@interface YCUrlSessionDemuxTaskInfo : NSObject

- (instancetype)initWithTask:(NSURLSessionDataTask *)task delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes;

@property (nonatomic, strong, readonly)  NSURLSessionDataTask *        task;
@property (nonatomic, strong, readonly)  id<NSURLSessionDataDelegate>  delegate;
@property (nonatomic, strong, readonly)  NSThread *                    thread;
@property (nonatomic, copy, readonly)    NSArray *                     modes;

- (void)performBlock:(dispatch_block_t)block;

- (void)invalidate;

@end

@interface YCUrlSessionDemuxTaskInfo ()
@property (nonatomic, strong, readwrite)  NSURLSessionDataTask *        task;
@property (nonatomic, strong, readwrite)  id<NSURLSessionDataDelegate>  delegate;
@property (nonatomic, strong, readwrite)  NSThread *                    thread;
@property (nonatomic, copy, readwrite)    NSArray *                     modes;

@end

@implementation YCUrlSessionDemuxTaskInfo

- (instancetype)initWithTask:(NSURLSessionDataTask *)task delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes {
    
    assert(task != nil);
    assert(delegate != nil);
    assert(modes != nil);
    if (self = [super init]) {
        self.task = task;
        self.delegate = delegate;
        self.thread = [NSThread currentThread];
        self.modes = [modes copy];
    }
    return self;
}


- (void)performBlock:(dispatch_block_t)block {
    
    assert(self.delegate != nil);
    assert(self.thread != nil);
    [self performSelector:@selector(performBlockOnClientThread:) onThread:self.thread withObject:[block copy] waitUntilDone:NO modes:self.modes];
}

- (void)performBlockOnClientThread:(dispatch_block_t)block {
    
    assert([NSThread currentThread] == self.thread);
    block();
}

- (void)invalidate {
    
    self.delegate = nil;
    self.thread = nil;
}

@end

@interface YCAssistiveURLSessionDemux ()<NSURLSessionDataDelegate>
@property (nonatomic, strong, readwrite) NSURLSession *                session;
@property (nonatomic, copy, readwrite) NSURLSessionConfiguration   *configuration;
@property (nonatomic, strong) NSMutableDictionary                  *taskInfoByTaskID;       // keys NSURLSessionTask taskIdentifier, values are SessionManager
@property (nonatomic, strong) NSOperationQueue                     *sessionDelegateQueue;
@end

@implementation YCAssistiveURLSessionDemux

- (instancetype)init {
    
    return [self initWithConfiguration:nil];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration {
    
    self = [super init];
    if (self != nil) {
        if (!configuration) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        self.configuration = [configuration copy];
        self.taskInfoByTaskID = [[NSMutableDictionary alloc] init];
        
        self.sessionDelegateQueue = [[NSOperationQueue alloc] init];
        [self.sessionDelegateQueue setMaxConcurrentOperationCount:1];
        [self.sessionDelegateQueue setName:@"SSUrlSessionDemux"];
        //监听AFNETWorking网络请求时，以NSURLSessionConfiguration得到的session,不能使用自定义NSURLProtocol进行拦截，会使用
        //NSURLSessionConfiguration中protocolClasses里的默认第一个NSURLProtocol进行处理
        self.session = [NSURLSession sessionWithConfiguration:self.configuration delegate:self delegateQueue:self.sessionDelegateQueue];
        self.session.sessionDescription = @"SSUrlSessionDemux";
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes {
    
    NSURLSessionDataTask *task;
    YCUrlSessionDemuxTaskInfo *taskInfo;
    assert(request != nil);
    assert(delegate != nil);
    // modes may be nil
    
    if (modes.count == 0) {
        modes = @[NSDefaultRunLoopMode];
    }
    task = [self.session dataTaskWithRequest:request];
    assert(task!=nil);
    taskInfo = [[YCUrlSessionDemuxTaskInfo alloc] initWithTask:task delegate:delegate modes:modes];
    @synchronized (self) {
        self.taskInfoByTaskID[@(task.taskIdentifier)] = taskInfo;
    }
    return task;
}

- (YCUrlSessionDemuxTaskInfo *)taskInfoForTask:(NSURLSessionTask *)task {
    
    assert(task!=nil);
    YCUrlSessionDemuxTaskInfo *result;
    @synchronized (self) {
        result = self.taskInfoByTaskID[@(task.taskIdentifier)];
        assert(result != nil);
    }
    return result;
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    YCUrlSessionDemuxTaskInfo *    taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    YCUrlSessionDemuxTaskInfo *    taskInfo;
    taskInfo = [self taskInfoForTask:task];
    
    // This is our last delegate callback so we remove our task info record.
    
    @synchronized (self) {
        [self.taskInfoByTaskID removeObjectForKey:@(taskInfo.task.taskIdentifier)];
    }
    
    // Call the delegate if required.  In that case we invalidate the task info on the client thread
    // after calling the delegate, otherwise the client thread side of the -performBlock: code can
    // find itself with an invalidated task info.
    
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didCompleteWithError:error];
            [taskInfo invalidate];
        }];
    } else {
        [taskInfo invalidate];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    YCUrlSessionDemuxTaskInfo *    taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
        }];
    } else {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    YCUrlSessionDemuxTaskInfo *    taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didBecomeDownloadTask:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didBecomeDownloadTask:downloadTask];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    YCUrlSessionDemuxTaskInfo *    taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didReceiveData:data];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    YCUrlSessionDemuxTaskInfo *    taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:willCacheResponse:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
        }];
    } else {
        completionHandler(proposedResponse);
    }
}
@end
