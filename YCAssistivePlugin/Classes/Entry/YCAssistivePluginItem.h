//
//  YCAssistivePluginItem.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/17.
//

#import <Foundation/Foundation.h>
#import "YCAssistivePluginProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistivePluginItem : NSObject

/* 图标 */
@property (nonatomic, strong) UIImage *pluginImage;
/* 点击信号 */
@property (nonatomic, strong) id<YCAssistivePluginProtocol> plugin;

+ (instancetype)pluginItemWithImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
