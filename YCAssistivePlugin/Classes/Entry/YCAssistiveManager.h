//
//  YCAssistiveManager.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import <Foundation/Foundation.h>
#import "YCAssistiveWindow.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveManager : NSObject

/* 原window */
@property (nonatomic, strong, readonly) UIWindow *originWindow;
/* 辅助window */
@property (nonatomic, strong, readonly) YCAssistiveWindow *assistiveWindow;

+ (instancetype)sharedManager;

- (void)installPlugins;

- (void)showAssistive;
- (void)makeAssistiveWindowAsKeyWindow;

- (void)hideAssistive;
- (void)revokeToOriginKeyWindow;

@end

NS_ASSUME_NONNULL_END
