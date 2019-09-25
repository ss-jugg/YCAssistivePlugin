//
//  YCAssistivePluginItem.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/17.
//

#import <Foundation/Foundation.h>
#import "YCAssistivePluginProtocol.h"
typedef NS_ENUM(NSUInteger, YCAssistivePluginType) {
    YCAssistivePluginTypeScreenShot,    //截图
    YCAssistivePluginTypeFindVC,        //当前试图控制器
    YCAssistivePluginTypeHierarchy,     //层级
    YCAssistivePluginTypePerformance    //性能
};
NS_ASSUME_NONNULL_BEGIN

@interface YCAssistivePluginItem : NSObject

/* 图标 */
@property (nonatomic, strong) UIImage *pluginImage;
/* 类型 */
@property (nonatomic, assign) YCAssistivePluginType pluginType;
/* 点击信号 */
@property (nonatomic, strong) id<YCAssistivePluginProtocol> plugin;

+ (instancetype)pluginItemWithType:(YCAssistivePluginType)type imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
