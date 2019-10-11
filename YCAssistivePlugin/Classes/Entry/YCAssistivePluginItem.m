//
//  YCAssistivePluginItem.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/17.
//

#import "YCAssistivePluginItem.h"
#import "UIImage+AssistiveBundle.h"

@implementation YCAssistivePluginItem

+ (instancetype)pluginItemWithImageName:(NSString *)imageName {
    
    YCAssistivePluginItem *item = [[YCAssistivePluginItem alloc] init];
    item.pluginImage = [UIImage as_imageWithName:imageName];
    return item;
}
@end
