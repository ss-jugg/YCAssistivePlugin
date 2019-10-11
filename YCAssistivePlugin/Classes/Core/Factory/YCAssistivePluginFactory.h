//
//  YCAssistivePluginFactory.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/11.
//

#import <Foundation/Foundation.h>
#import "YCAssistiveFunctionModel.h"
#import "YCAssistivePluginItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistivePluginFactory : NSObject

+ (NSMutableArray<YCAssistiveFunctionViewModel *> *)homeFunctions;

+ (NSArray<YCAssistivePluginItem *> *)pluginItems;

@end

NS_ASSUME_NONNULL_END
