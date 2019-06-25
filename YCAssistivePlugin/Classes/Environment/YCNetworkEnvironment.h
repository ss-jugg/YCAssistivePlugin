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

@interface YCNetworkEnvironmentModel : NSObject
@property (nonatomic, copy) NSString *environmentName;
@property (nonatomic, assign) YCNetworkEnvironmentType environmentType;

+ (instancetype)environmentModelWithName:(NSString *)evnironmentName type:(YCNetworkEnvironmentType)environmentType;

@end

@interface YCNetworkEnvironment : NSObject

@property (nonatomic, strong, readonly) NSArray<YCNetworkEnvironmentModel *> *environmentSources;

+ (instancetype)sharedInstance;

- (void)install;

- (YCNetworkEnvironmentModel *)currentEnvironment;

@end

NS_ASSUME_NONNULL_END
