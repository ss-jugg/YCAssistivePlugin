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

/* 环境地址 */
@property (nonatomic, copy, readwrite) NSString *environmentAddress;

@end

@implementation YCNetworkEnvironment

#if DEBUG
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[YCNetworkEnvironment sharedInstance] install];
    });
}
#endif

+ (instancetype)sharedInstance {
    
    static YCNetworkEnvironment *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCNetworkEnvironment alloc] init];
    });
    return _instance;
}

- (void)install {
    
    [self configNetworkAddressByCache];
}

#pragma mark - 当前环境

- (void)configNetworkAddressByCache {
    
    //合伙人app，获取缓存中测试环境地址
    if ([self.storage configursForKey:kPartnerApiKey].count > 0) {
        self.environmentAddress = YC_ENV_FORMAT([self.storage configursForKey:kPartnerApiKey].firstObject.address);
    }else {
        [self addDefaultAPIAddressesForKey:kPartnerApiKey];
    }
    //车商app地址，获取缓存中测试环境地址
    if ([self.storage configursForKey:kDealerApiKey].count > 0) {
        self.environmentAddress = YC_ENV_FORMAT([self.storage configursForKey:kDealerApiKey].firstObject.address);
    }else {
        [self addDefaultAPIAddressesForKey:kDealerApiKey];
    }
}

- (void)addDefaultAPIAddressesForKey:(NSString *)key {
    
   
    NSArray *addresses =@[ @{@"title":@"测试环境",
                             @"address":@"http://192.168.2.11"},
                           @{@"title":@"其他环境1",
                             @"address":@"http://192.168.2.17"},
                           @{@"title":@"其他环境2",
                             @"address":@"http://192.168.2.16"},
                           @{@"title":@"线上环境",
                             @"address":@"http://www.yuncheok.com"}];
    [addresses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YCNetworkConfigur *configur = [YCNetworkConfigur configurWithAddress:[self addressStringForApi:obj[@"address"]] remark:obj[@"title"]];
        configur.selected = (idx == 0);
        [self.storage addConfigur:configur forKey:key];
    }];
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
    self.environmentAddress = YC_ENV_FORMAT(con.address);
}

#pragma mark - 环境
- (YCNetworkConfigStorage *)storage {
    
    return [YCNetworkConfigStorage sharedInstance];
}
@end
