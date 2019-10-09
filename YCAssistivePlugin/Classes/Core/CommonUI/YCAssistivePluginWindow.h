//
//  YCAssistivePluginWindow.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCAssistiveBaseWindow.h"
#import "YCAssistiveNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCAssistivePluginWindowDelegate <NSObject>

- (void)pluginWindowDidClosed;

@end

@interface YCAssistivePluginWindow : YCAssistiveBaseWindow<YCAssistivePluginWindowDelegate>

- (YCAssistiveNavigationController *)navigationController:(UIViewController *)vc;
- (YCAssistiveNavigationController *)navigationControllerByClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
