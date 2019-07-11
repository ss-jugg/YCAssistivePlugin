//
//  UIViewController+AssistiveNavigation.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/10.
//

#import <UIKit/UIKit.h>

@protocol YCAssistiveNavigationProtocol <NSObject>

@optional
- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController;
- (void)as_viewControllerDidTriggerRightClick:(UIViewController *)viewController;

@end

@interface UIViewController (AssistiveNavigation)<YCAssistiveNavigationProtocol>

@property (nonatomic, weak) id<YCAssistiveNavigationProtocol> navigationDelegate;

@property (nonatomic, strong) UIButton *as_leftButton;

@property (nonatomic, strong) UIButton *as_rightButton;

- (void)as_setNavigationBarTitle:(NSString *)title;

- (void)as_setLeftBarItemTitle:(NSString *)title;
- (void)as_setLeftBarItemImage:(UIImage *)image;
- (void)as_setLeftBarItemTitle:(NSString *)title image:(UIImage *)image;

- (void)as_setRightBarItemTitle:(NSString *)title;
- (void)as_setRightBarItemImage:(UIImage *)image;
- (void)as_setRightBarItemTitle:(NSString *)title image:(UIImage *)image;

@end

