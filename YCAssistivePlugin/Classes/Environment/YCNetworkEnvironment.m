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

NSString *const kYCNetworkEnvironmentSwitchNotification = @"kYCNetworkEnvironmentSwitchNotification";

@implementation YCNetworkEnvironmentModel

+ (instancetype)environmentModelWithName:(NSString *)evnironmentName type:(YCNetworkEnvironmentType)environmentType {
    
    YCNetworkEnvironmentModel *environmentModel = [[YCNetworkEnvironmentModel alloc] init];
    environmentModel.environmentName = evnironmentName;
    environmentModel.environmentType = environmentType;
    return environmentModel;
}

@end

static NSString *kYCCurrentNetworkEnvironment = @"YCCurrentNetworkEnvironment";

@interface YCNetworkEnvironment ()

/* ns */
@property (nonatomic, strong, readwrite) NSArray<YCNetworkEnvironmentModel *> *environmentSources;
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

- (void)install {
    
    [self configNetworkAddressByCache];
}

#pragma mark - 当前环境
- (YCNetworkEnvironmentModel *)currentEnvironment {
    
    YCNetworkEnvironmentType environmentType = [self getCurrentEnvironmentType];
    for (YCNetworkEnvironmentModel *model in self.environmentSources) {
        if (model.environmentType == environmentType) {
            return model;
        }
    }
    return [YCNetworkEnvironmentModel environmentModelWithName:@"测试环境" type:YCNetworkEnvironmentTypeProject];
}

- (YCNetworkEnvironmentType)getCurrentEnvironmentType {
    return (YCNetworkEnvironmentType) [[[NSUserDefaults standardUserDefaults] valueForKey:(NSString *) kYCCurrentNetworkEnvironment] integerValue];
}

- (void)configNetworkAddressByCache {
    
    BOOL isProject = YCNetworkEnvironmentTypeProject == [self getCurrentEnvironmentType];
    //合伙人app，获取缓存中测试环境地址
    if ([self.storage configursForKey:kPartnerApiKey].count > 0 && isProject) {
        YCSetProjectAPIRoot([self.storage configursForKey:kPartnerApiKey].firstObject.address);
    }else {
        [self addAddress:[self addressStringForApi:kYCProjectAPIRoot] forKey:kPartnerApiKey];
    }
    //车商app地址，获取缓存中测试环境地址
    if ([self.storage configursForKey:kDealerApiKey].count > 0 && isProject) {
        YCSetProjectAPIRoot([self.storage configursForKey:kDealerApiKey].firstObject.address);
    }else {
        [self addAddress:[self addressStringForApi:kYCProjectAPIRoot] forKey:kDealerApiKey];
    }
}

- (void)addAddress:(NSString *)address forKey:(NSString *)key {
    
    NSParameterAssert(address);
    
    YCNetworkConfigur *configur = [YCNetworkConfigur configurWithAddress:address remark:@""];
    configur.selected = YES;
    [self.storage addConfigur:configur forKey:key];
}

- (NSString *)addressStringForApi:(NSString *)api {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9](.*?):(.*)[0-9]" options:0 error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:api options:0 range:NSMakeRange(0, api.length)];
    if (range.length + range.location > api.length) {
        return api;
    }
    return [api substringWithRange:range];
}

#pragma mark - 环境
- (NSArray<YCNetworkEnvironmentModel *> *)environmentSources {
    
    if (_environmentSources == nil) {
        _environmentSources = @[[YCNetworkEnvironmentModel environmentModelWithName:@"测试环境" type:YCNetworkEnvironmentTypeProject],
                                [YCNetworkEnvironmentModel environmentModelWithName:@"线上环境" type:YCNetworkEnvironmentTypeRelease]];
        
    }
    return _environmentSources;
}

- (YCNetworkConfigStorage *)storage {
    
    return [YCNetworkConfigStorage sharedInstance];
}
@end
