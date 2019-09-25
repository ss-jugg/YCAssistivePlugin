//
//  YCNetworkConfigStorage.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import "YCNetworkConfigStorage.h"
#import "YCNetworkConfigur.h"

static NSString *const kYCNetworkConfigurStorageSuffixKey = @"_network_configur_";

#define YC_REAL_KEY(key) [key stringByAppendingString:kYCNetworkConfigurStorageSuffixKey]

@interface YCNetworkConfigStorage ()
/* nsu */
@property (nonatomic, strong, readonly) NSUserDefaults *userDefaults;
@end
@implementation YCNetworkConfigStorage

+ (instancetype)sharedInstance {
    
    static YCNetworkConfigStorage *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCNetworkConfigStorage alloc] init];
        
    });
    return _instance;
}


- (void)setConfigurs:(NSArray <YCNetworkConfigur *> *)configurs forKey:(NSString *)key {
    
    NSParameterAssert(configurs);
    
    NSData *configurData = [NSKeyedArchiver archivedDataWithRootObject:configurs];
    [self.userDefaults setObject:configurData forKey:YC_REAL_KEY(key)];
}

- (void)addConfigur:(YCNetworkConfigur *)configur forKey:(NSString *)key {
    
    NSParameterAssert(configur);
    
    if (![configur isValid]) return;
    
    NSArray <YCNetworkConfigur *> *configurs = [self configursForKey:key] ?: @[];
    if (![configurs containsObject:configur]) {
        [self setConfigurs:[configurs arrayByAddingObject:configur] forKey:key];
    }
}

- (void)removeConfigur:(YCNetworkConfigur *)configur forKey:(NSString *)key {
    
    NSParameterAssert(configur);
    if (![configur isValid]) {
        return;
    }
    NSMutableArray <YCNetworkConfigur *> *configurs = [self configursForKey:key].mutableCopy;
    if ([configurs containsObject:configur]) {
        [configurs removeObject:configur];
        [self setConfigurs:configurs forKey:key];
    }
}

- (void)removeAllConfigursForKey:(NSString *)key {
    
    [self setConfigurs:@[] forKey:key];
}

- (NSArray <YCNetworkConfigur *> *)configursForKey:(NSString *)key {
    
    NSData *configurData = [self.userDefaults objectForKey:YC_REAL_KEY(key)];
    
    if (!configurData.length) {
        return @[];
    }
    
    NSArray *configurs = [NSKeyedUnarchiver unarchiveObjectWithData:configurData];
    
    // compat old version
    for (YCNetworkConfigur *configur in configurs) {
        if (![configur isKindOfClass:[YCNetworkConfigur class]]) {
            [self.userDefaults removeObjectForKey:YC_REAL_KEY(key)];
            return @[];
        }
    }
    
    return configurs;
}

- (YCNetworkConfigur *)selectedConfigurForKey:(NSString *)key {
    
    NSArray *configurs = [self configursForKey:key];
    for (YCNetworkConfigur *configur in configurs) {
        if (configur.isSelected) {
            return configur;
        }
    }
    return nil;
}


- (NSUserDefaults *)userDefaults {
    return [NSUserDefaults standardUserDefaults];
}
@end
