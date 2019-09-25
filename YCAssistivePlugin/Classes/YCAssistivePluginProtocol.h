//
//  YCAssistivePluginProtocol.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YCAssistivePluginProtocol <NSObject>

@optional
- (void)pluginDidLoad;

- (void)pluginDidLoad:(NSDictionary *_Nullable)data;

@end

NS_ASSUME_NONNULL_END
