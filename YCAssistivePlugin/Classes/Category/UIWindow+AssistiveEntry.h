//
//  UIWindow+AssistiveEntry.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (AssistiveEntry)

/**
 Current visiable viewController.
 
 @return UIViewController.
 */
- (UIViewController *)yc_currentShowingViewController;

@end

NS_ASSUME_NONNULL_END
