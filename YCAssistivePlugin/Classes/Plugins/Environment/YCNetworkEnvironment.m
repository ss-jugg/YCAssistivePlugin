//
//  YCNetworkEnvironment.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import "YCNetworkEnvironment.h"
#import "YCNetworkConfigur.h"
#import "YCNetworkConfigStorage.h"
#import "YCAssistiveMacro.h"
#import <YCNetworking/YCNetworking.h>

#define YC_ENV_FORMAT(a) ({ \
NSString *r = a; \
if (![a hasPrefix:@"http://"]) { \
r = [NSString stringWithFormat:@"http://%@", a]; \
} \
r; \
})

@interface YCNetworkEnvironment ()

/* yc */
@property (nonatomic, strong) YCNetworkConfigStorage *storage;

@end

@implementation YCNetworkEnvironment

+ (instancetype)sharedInstance {
    
    static YCNetworkEnvironment *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCNetworkEnvironment alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.environmentAddresses = [@[@{@"title":@"测试环境",
                                         @"address":@"http://192.168.2.16"},
                                       @{@"title":@"其他环境1",
                                         @"address":@"http://192.168.2.11"},
                                        @{@"title":@"预发环境",
                                          @"address":@"http://demo.yunchejinrong.com"},
                                       @{@"title":@"线上环境",
                                         @"address":@"http://system.yunchejinrong.com"}] mutableCopy];
    }
    return self;
}

- (void)install {
    
    [self configNetworkAddressByCache];
}

#pragma mark - 当前环境

- (void)configNetworkAddressByCache {
    
    //app，获取缓存中测试环境地址
    if ([self.storage configursForKey:kAppEnvironmentApiKey].count > 0) {
        kProjectAPIRoot = YC_ENV_FORMAT([self.storage configursForKey:kAppEnvironmentApiKey].firstObject.address);
    }else {
        kProjectAPIRoot = kYCProjectAPIRoot;
        [self addDefaultAPIAddressesForKey:kAppEnvironmentApiKey];
    }
}

- (void)addDefaultAPIAddressesForKey:(NSString *)key {
    
    YCNetworkConfigur *configur = [YCNetworkConfigur configurWithAddress:[self addressStringForApi:kYCProjectAPIRoot] remark:@"测试环境"];
    configur.selected = YES;
    [self.storage addConfigur:configur forKey:key];
    
    if (self.environmentAddresses.count > 0) {
        [self.environmentAddresses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YCNetworkConfigur *configur = [YCNetworkConfigur configurWithAddress:[self addressStringForApi:obj[@"address"]] remark:obj[@"title"]];
            [self.storage addConfigur:configur forKey:key];
        }];
    }
}

- (NSString *)addressStringForApi:(NSString *)api {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9](.*?):(.*)[0-9]" options:0 error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:api options:0 range:NSMakeRange(0, api.length)];
    if (range.length + range.location > api.length) {
        return api;
    }
    return [api substringWithRange:range];
}

- (void)switchEnvironmentForKey:(NSString *)key {
    
    YCNetworkConfigur *con = [self.storage selectedConfigurForKey:key];
    kProjectAPIRoot = YC_ENV_FORMAT(con.address);
}

#pragma mark - 环境
- (YCNetworkConfigStorage *)storage {
    
    return [YCNetworkConfigStorage sharedInstance];
}
@end
