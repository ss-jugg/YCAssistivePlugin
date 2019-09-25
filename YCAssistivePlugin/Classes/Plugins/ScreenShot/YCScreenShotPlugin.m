//
//  YCScreenShotPlugin.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/19.
//

#import "YCScreenShotPlugin.h"
#import "YCAssistiveManager.h"
#import "YCAssitiveWindowFactory.h"
#import "YCScreenShotPreviewViewController.h"
#import "YCScreenShotHelper.h"

@implementation YCScreenShotPlugin

- (void)pluginDidLoad {
    
    UIImage *image = [[YCScreenShotHelper sharedInstance] imageFromCurrentScreen];
    NSDictionary *data = @{@"shotImage": image};
    [self pluginDidLoad:data];
}

- (void)pluginDidLoad:(NSDictionary *)data {
    
    YCScreenShotWindow *window = [YCAssitiveWindowFactory screenShotWindow];
    YCScreenShotPreviewViewController *rootVC = (YCScreenShotPreviewViewController *)window.rootViewController;
    rootVC.shotImage = data[@"shotImage"];
    [[YCAssistiveManager sharedManager] showPluginWindow:window];
}

@end
