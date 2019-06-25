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

@property (nonatomic, strong, readonly) YCAssistiveWindow *assistiveWindow;

+ (instancetype)sharedManager;

- (void)showAssistive;

- (void)hideAssistive;

@end

NS_ASSUME_NONNULL_END
