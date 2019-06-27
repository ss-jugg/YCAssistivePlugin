//
//  YCAssistiveItemPlugin.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/26.
//

#import <Foundation/Foundation.h>
#import "YCAssistiveDisplayView.h"
@protocol YCAssistiveItemPluginProtocol <NSObject>

@required
+ (NSString *)title;
+ (NSInteger)sortNumber;
+ (void)reactTapForAssistantView:(YCAssistiveDisplayView *)assistiveTouch;

@end

CF_EXPORT NSMutableArray<Class<YCAssistiveItemPluginProtocol>> const *kYCAssistivePlugins;

@interface YCAssistiveItemPlugin : NSObject

+ (void)registerPlugin;
@end
