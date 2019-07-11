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

/* 当前环境地址 */
@property (nonatomic, copy, readonly) NSString *environmentAddress;

+ (instancetype)sharedInstance;

/* 环境地址 */
@property (nonatomic, strong) NSMutableArray *environmentAddresses;

- (void)install;

- (void)switchEnvironmentForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
