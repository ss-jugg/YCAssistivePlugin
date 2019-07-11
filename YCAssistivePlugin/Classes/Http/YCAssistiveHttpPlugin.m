
//
//  YCAssistiveHttpHelper.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import "YCAssistiveHttpPlugin.h"
#import "YCAssistiveHttpModel.h"

NSString *const kAssistiveHttpNotificationName = @"kAssistiveHttpNotificationName";

@interface YCAssistiveHttpPlugin ()

@property (nonatomic, strong, readwrite) NSMutableArray<YCAssistiveHttpModel *> *httpModels;

@end

@implementation YCAssistiveHttpPlugin

+ (instancetype)sharedInstance {
    
    static YCAssistiveHttpPlugin *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCAssistiveHttpPlugin alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.debugHosts = @[@"http://192.168.2.16"];
        self.httpModels = [NSMutableArray array];
    }
    return self;
}

- (void)addHttpModel:(YCAssistiveHttpModel *)model {
    @synchronized (self.httpModels) {
        if (![self.httpModels containsObject:model]) {
            [self.httpModels addObject:model];
        }
    }
}

- (void)clearAll {
    
    @synchronized (self.httpModels) {
        [self.httpModels removeAllObjects];
    }
}

+ (NSString *)prettyJSONStringFromData:(NSData *)data {
    
    if (data == nil || data.length <= 0) {
        return nil;
    }
    NSString *prettyString = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        prettyString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
        // NSJSONSerialization转义正斜杠。 我们想要漂亮的json，所以通过并避开斜杠。
        prettyString = [prettyString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    } else {
        prettyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return prettyString;
}

@end
