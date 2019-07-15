//
//  YCNetworkEnvironment.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kYCNetworkEnvironmentSwitchNotification;

typedef NS_ENUM(NSUInteger, YCNetworkEnvironmentType) {
    YCNetworkEnvironmentTypeProject,    //测试环境，自定义
    YCNetworkEnvironmentTypeRelease,    //生产环境，配置
};

@interface YCNetworkEnvironment : NSObject

+ (instancetype)sharedInstance;

/* 可切换的环境地址 */
@property (nonatomic, strong) NSMutableArray *environmentAddresses;

/**
 安装切换环境插件
 */
- (void)install;

/**
 切换环境地址

 @param key 对应app
 */
- (void)switchEnvironmentForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
