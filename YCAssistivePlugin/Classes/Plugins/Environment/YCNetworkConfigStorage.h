//
//  YCNetworkConfigStorage.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YCNetworkConfigur;
@interface YCNetworkConfigStorage : NSObject

+ (instancetype)sharedInstance;

- (void)addConfigur:(YCNetworkConfigur *)configur forKey:(NSString *)key;
- (void)removeConfigur:(YCNetworkConfigur *)configur forKey:(NSString *)key;
- (void)removeAllConfigursForKey:(NSString *)key;
- (void)setConfigurs:(NSArray <YCNetworkConfigur *> *)configurs forKey:(NSString *)key;

- (NSArray <YCNetworkConfigur *> *)configursForKey:(NSString *)key;
- (YCNetworkConfigur *)selectedConfigurForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
