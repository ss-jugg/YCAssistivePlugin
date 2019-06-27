//
//  YCAssistiveAppleDebuggerView.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/26.
//

#import "YCAssistiveAppleDebuggerView.h"
#import <Masonry/Masonry.h>

@interface YCAssistiveAppleDebuggerView ()

/* 展示顶部ccontroller名称 */
@property (nonatomic, strong) UILabel *displayLbl;

@end

@implementation YCAssistiveAppleDebuggerView

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.displayLbl = [[UILabel alloc] init];
        self.displayLbl.numberOfLines = 0;
        self.displayLbl.textAlignment = NSTextAlignmentCenter;
        self.displayLbl.font = [UIFont systemFontOfSize:11.0];
        self.displayLbl.textColor = [UIColor whiteColor];
        [self addSubview:self.displayLbl];
        [self.displayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

//MARK:点击更新
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self updateText];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.displayLbl.frame = self.bounds;
    [self updateText];
}

- (void)updateText {
    self.displayLbl.text = [NSString stringWithFormat:@"顶层控制器 \n %@", NSStringFromClass([[self topViewController:[UIApplication sharedApplication].delegate.window.rootViewController] class])];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController {
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
