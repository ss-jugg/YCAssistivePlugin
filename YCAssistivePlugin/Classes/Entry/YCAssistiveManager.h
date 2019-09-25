//
//  YCAssistiveManager.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import <Foundation/Foundation.h>
#import "YCAssistiveWindow.h"
#import "YCScreenShotWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveManager : NSObject

/* 原window */
@property (nonatomic, strong, readonly) UIWindow *originWindow;
/* 辅助window */
@property (nonatomic, strong, readonly) YCAssistiveWindow *assistiveWindow;

+ (instancetype)sharedManager;

- (void)installPlugins;

- (void)showPluginWindow:(YCAssistiveBaseWindow *)window;

- (void)showPluginWindow:(YCAssistiveBaseWindow *)window completion:(void(^_Nullable)(void))completion;

- (void)hidePluginWindow:(YCAssistiveBaseWindow *)window;

- (void)hidePluginWindow:(YCAssistiveBaseWindow *)window completion:(void(^_Nullable)(void))completion;

- (void)showHomeWindow;

- (void)showAssistive;

- (void)hideAssistive;




@end

NS_ASSUME_NONNULL_END
