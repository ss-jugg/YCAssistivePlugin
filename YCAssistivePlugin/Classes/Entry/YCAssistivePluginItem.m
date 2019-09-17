//
//  YCAssistivePluginItem.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/17.
//

#import "YCAssistivePluginItem.h"
#import "UIImage+AssistiveBundle.h"

@implementation YCAssistivePluginItem

+ (instancetype)pluginItemWithType:(YCAssistivePluginType)type imageName:(NSString *)imageName {
    
    YCAssistivePluginItem *item = [[YCAssistivePluginItem alloc] init];
    item.pluginType = type;
    item.pluginImage = [UIImage as_imageWithName:imageName];
    item.tapSubject = [RACSubject subject];
    return item;
}
@end
