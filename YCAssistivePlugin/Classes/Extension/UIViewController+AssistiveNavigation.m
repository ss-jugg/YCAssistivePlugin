//
//  UIViewController+AssistiveNavigation.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/10.
//

#import "UIViewController+AssistiveNavigation.h"
#import <objc/runtime.h>
#import "UIColor+AssistiveColor.h"
#import "UIFont+AssistiveFont.h"
#import "UIImage+AssistiveBundle.h"

static const CGFloat kASNBMaxButtonWidth = 150.0f;
static const CGFloat kASNBMinButtonWidth = 60.0f;
static const CGFloat kASNBButtonImageWidth = 25.0f;

static NSString *kASLeftButtonKey = @"kASLeftButtonKey";
static NSString *kASRightButtonKey = @"kASLeftButtonKey";

@implementation UIViewController (AssistiveNavigation)
@dynamic as_leftButton;
@dynamic as_rightButton;

#pragma mark - public

- (void)as_setNavigationBarTitle:(NSString *)title {
    self.navigationItem.title = title;
}
- (void)as_setLeftBarItemTitle:(NSString *)title {
    [self as_setLeftBarItemTitle:title image:nil];
}
- (void)as_setLeftBarItemImage:(UIImage *)image {
    [self as_setLeftBarItemTitle:nil image:image];
}
- (void)as_setLeftBarItemTitle:(NSString *)title image:(UIImage *)image {
    [self _as_setupLeftItemWithTitle:title image:image];
}
- (void)as_setRightBarItemTitle:(NSString *)title {
    [self as_setRightBarItemTitle:title image:nil];
}
- (void)as_setRightBarItemImage:(UIImage *)image {
    [self as_setRightBarItemTitle:nil image:image];
}
- (void)as_setRightBarItemTitle:(NSString *)title image:(UIImage *)image {
    [self _as_setupRightItemWithTitle:title image:image];
}

#pragma mark - 更新按钮
//MARK:导航栏左侧按钮
- (void)_as_setupLeftItemWithTitle:(NSString *)title image:(UIImage *)image {
    
    if (title.length <= 0 && !image) {
        self.navigationItem.leftBarButtonItem = nil;
        return;
    }
    self.as_leftButton.hidden = NO;
    [self _as_bindDelegate];
    [self _as_updateNavigationButton:self.as_leftButton withTitle:title image:image];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.as_leftButton];
}

//MARK:导航栏右侧按钮
- (void)_as_setupRightItemWithTitle:(NSString *)title image:(UIImage *)image {
    if (title.length <= 0 && !image) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    self.as_rightButton.hidden = NO;
    [self _as_bindDelegate];
    [self _as_updateNavigationButton:self.as_rightButton withTitle:title image:image];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.as_rightButton];
}

- (void)_as_updateNavigationButton:(UIButton *)button withTitle:(NSString *)title image:(UIImage *)image {
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    CGRect frame = button.frame;
    frame.size.width = MAX(MIN(kASNBMaxButtonWidth, [self _as_sizeForStr:title font:[UIFont as_15]].width + kASNBButtonImageWidth), kASNBMinButtonWidth);
    button.frame = frame;
}

- (CGSize)_as_sizeForStr:(NSString *)str font:(UIFont *)font {
    
    return [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
}

- (void)_as_setupTitleView {
    
    // 设置导航栏标题颜色
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttributes[NSFontAttributeName] = [UIFont as_17_bold];
    
    // 5.去除阴影
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    textAttributes[NSShadowAttributeName] = shadow;
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setBarTintColor:[UIColor as_mainColor]];
    
}

#pragma mark - 绑定代理
- (void)_as_bindDelegate {
    
    if (!self.navigationDelegate) {
        self.navigationDelegate = self;
    }
}

#pragma mark - 代理
- (id<YCAssistiveNavigationProtocol>)navigationDelegate {
    return objc_getAssociatedObject(self, @selector(navigationDelegate));
}
- (void)setNavigationDelegate:(id<YCAssistiveNavigationProtocol>)navigationDelegate {
    objc_setAssociatedObject(self, @selector(navigationDelegate), navigationDelegate, OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - 按钮响应事件
- (void)_as_viewControllerDidTriggerLeftClick:(UIButton *)button {
    
    if ([self.navigationDelegate respondsToSelector:@selector(as_viewControllerDidTriggerLeftClick:)]) {
        [self.navigationDelegate as_viewControllerDidTriggerLeftClick:self];
        return;
    }
    //直接pop
    if ([self _as_isModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if ([self.navigationController.viewControllers containsObject:self]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)_as_viewControllerDidTriggerRightClick:(UIButton *)button {
    
    if ([self.navigationDelegate respondsToSelector:@selector(as_viewControllerDidTriggerRightClick:)]) {
        [self.navigationDelegate as_viewControllerDidTriggerRightClick:self];
    }
}

#pragma mark - 按钮
- (UIButton *)as_leftButton {
    
    UIButton *leftButton = objc_getAssociatedObject(self, &kASLeftButtonKey);
    if (!leftButton) {
        leftButton = [self _as_generateNavigationButtonWithSelector:@selector(_as_viewControllerDidTriggerLeftClick:)];
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(14, 0, 10, 0);
        leftButton.titleEdgeInsets = UIEdgeInsetsMake(13, 0, 11, 0);
        objc_setAssociatedObject(self, &kASLeftButtonKey, leftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return leftButton;
}

- (UIButton *)as_rightButton {
    
    UIButton *rightButton = objc_getAssociatedObject(self, &kASRightButtonKey);
    if (!rightButton) {
        rightButton = [self _as_generateNavigationButtonWithSelector:@selector(_as_viewControllerDidTriggerRightClick:)];
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(7, 0, 11, 0);
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(12, 0, 11, 0);
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        objc_setAssociatedObject(self, &kASRightButtonKey, rightButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rightButton;
}

- (UIButton *)_as_generateNavigationButtonWithSelector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, kASNBMaxButtonWidth, 40.0f);
    [button.titleLabel setFont:[UIFont as_15]];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}


#pragma mark - 是否模态视图
- (BOOL)_as_isModal {
    if ([self presentingViewController]) {
        NSArray *viewcontrollers = self.navigationController.viewControllers;
        if (viewcontrollers.count > 1) {
            if ([[viewcontrollers objectAtIndex:viewcontrollers.count - 1] isEqual:self]) {
                return NO;
            }
        } else {
            return YES;
        }
    }
    if ([[self presentingViewController] presentedViewController] == self) {
        return YES;
    }
    return [[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]];
}

@end
