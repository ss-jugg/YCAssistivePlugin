//
//  YCAssistiveSessionProtocol.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import "YCAssistiveSessionProtocol.h"
#import "YCAssistiveURLSessionDemux.h"
#import "YCNetworkInterceptor.h"

static NSString *kUrlProtocolKey = @"YCAssistiveSessionProtocol";

@interface YCAssistiveSessionProtocol ()<NSURLSessionDataDelegate>
@property (atomic, strong, readwrite) NSThread *                        clientThread;       ///< The thread on which we should call the client.
@property (atomic, copy,   readwrite) NSArray *                         modes;
@property (atomic, assign, readwrite) NSTimeInterval                    startTime;          ///< The start time of the request; written by client thread only; read by any thread.
@property (atomic, strong, readwrite) NSURLSessionDataTask *            task;               ///< The NSURLSession task for that request; client thread only.
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation YCAssistiveSessionProtocol

+ (YCAssistiveURLSessionDemux *)sharedDemux {
    
    static dispatch_once_t      sOnceToken;
    static YCAssistiveURLSessionDemux * sDemux;
    dispatch_once(&sOnceToken, ^{
        NSURLSessionConfiguration *     config;
        
        config = [NSURLSessionConfiguration defaultSessionConfiguration];
        sDemux = [[YCAssistiveURLSessionDemux alloc] initWithConfiguration:config];
    });
    return sDemux;
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    NSURLRequest *request = task.currentRequest;
    return request == nil ? NO : [self canInitWithRequest:request];
}

//MARK:过滤请求
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    if ([NSURLProtocol propertyForKey:kUrlProtocolKey inRequest:request]) {
        return NO;
    }
    
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }

    //文件类型不作处理
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    if (contentType && ([contentType containsString:@"multipart/form-data"])) {
        return NO;
    }

    return YES;
}

//MARK:返回请求
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@(YES) forKey:kUrlProtocolKey inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id <NSURLProtocolClient>)client {
    
    assert(request != nil);
    // cachedResponse may be nil
    assert(client != nil);
    // can be called on any thread
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

- (void)dealloc {
    self.task = nil;
    // can be called on any thread
    assert(self.task == nil);                     // we should have cleared it by now
}


- (void)startLoading {
    
    self.responseData = [NSMutableData data];
    NSMutableURLRequest *   recursiveRequest;
    NSMutableArray *        calculatedModes;
    NSString *              currentMode;
    
    assert(self.clientThread == nil);           // you can't call -startLoading twice
    assert(self.task == nil);

    assert(self.modes == nil);
    calculatedModes = [NSMutableArray array];
    [calculatedModes addObject:NSDefaultRunLoopMode];
    currentMode = [[NSRunLoop currentRunLoop] currentMode];
    if ( (currentMode != nil) && ! [currentMode isEqual:NSDefaultRunLoopMode] ) {
        [calculatedModes addObject:currentMode];
    }
    self.modes = calculatedModes;
    assert([self.modes count] > 0);
    
    recursiveRequest = [[self request] mutableCopy];
    assert(recursiveRequest != nil);
    
    [[self class] setProperty:@YES forKey:kUrlProtocolKey inRequest:recursiveRequest];
    
    self.startTime = [[NSDate date] timeIntervalSince1970];
    
    self.clientThread = [NSThread currentThread];
    
    // Once everything is ready to go, create a data task with the new request.
    self.task = [[[self class] sharedDemux] dataTaskWithRequest:recursiveRequest delegate:self modes:self.modes];
    assert(self.task != nil);
    [self.task resume];
}

- (void)stopLoading {
    
    assert(self.clientThread != nil);           // someone must have called -startLoading
    assert([NSThread currentThread] == self.clientThread);
    
    [[YCNetworkInterceptor shareInterceptor] interceptorDidReceiveData:self.responseData task:self.task startTime:self.startTime];
    if (self.task != nil) {
        [self.task cancel];
    }
}

#pragma mark * NSURLSession delegate callbacks

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest *    redirectRequest;
    
#pragma unused(session)
#pragma unused(task)
    assert(task == self.task);
    assert(response != nil);
    assert(newRequest != nil);
#pragma unused(completionHandler)
    assert(completionHandler != nil);
    assert([NSThread currentThread] == self.clientThread);
    
    // The new request was copied from our old request, so it has our magic property.  We actually
    // have to remove that so that, when the client starts the new request, we see it.  If we
    // don't do this then we never see the new request and thus don't get a chance to change
    // its caching behaviour.
    //
    // We also cancel our current connection because the client is going to start a new request for
    // us anyway.
    
    assert([[self class] propertyForKey:kUrlProtocolKey inRequest:newRequest] != nil);
    
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:kUrlProtocolKey inRequest:redirectRequest];
    
    // Tell the client about the redirect.
    
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    // Stop our load.  The CFNetwork infrastructure will create a new NSURLProtocol instance to run
    // the load of the redirect.
    
    // The following ends up calling -URLSession:task:didCompleteWithError: with NSURLErrorDomain / NSURLErrorCancelled,
    // which specificallys traps and ignores the error.
    
    [self.task cancel];
    
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
#pragma unused(session)
#pragma unused(dataTask)
    assert(dataTask == self.task);
    assert(response != nil);
    assert(completionHandler != nil);
    assert([NSThread currentThread] == self.clientThread);
    
    // Pass the call on to our client.  The only tricky thing is that we have to decide on a
    // cache storage policy, which is based on the actual request we issued, not the request
    // we were given.
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
#pragma unused(session)
#pragma unused(dataTask)
    assert(dataTask == self.task);
    assert(data != nil);
    assert([NSThread currentThread] == self.clientThread);
    
    [self.responseData appendData:data];
    // Just pass the call on to our client.
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *))completionHandler
{
#pragma unused(session)
#pragma unused(dataTask)
    assert(dataTask == self.task);
    assert(proposedResponse != nil);
    assert(completionHandler != nil);
    assert([NSThread currentThread] == self.clientThread);
    
    // We implement this delegate callback purely for the purposes of logging.
    
    completionHandler(proposedResponse);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
// An NSURLSession delegate callback.  We pass this on to the client.
{
#pragma unused(session)
#pragma unused(task)
    assert( (self.task == nil) || (task == self.task) );        // can be nil in the 'cancel from -stopLoading' case
    assert([NSThread currentThread] == self.clientThread);
    
    // Just log and then, in most cases, pass the call on to our client.
    
    if (error == nil) {
        [[self client] URLProtocolDidFinishLoading:self];
    } else if ( [[error domain] isEqual:NSURLErrorDomain] && ([error code] == NSURLErrorCancelled) ) {
        // Do nothing.  This happens in two cases:
        //
        // o during a redirect, in which case the redirect code has already told the client about
        //   the failure
        //
        // o if the request is cancelled by a call to -stopLoading, in which case the client doesn't
        //   want to know about the failure
    } else {
        [[self client] URLProtocol:self didFailWithError:error];
    }
    
    // We don't need to clean up the connection here; the system will call, or has already called,
    // -stopLoading to do that.
}

@end
