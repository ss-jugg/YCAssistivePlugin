//
//  UIView+AssistiveHierarchy.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "UIView+AssistiveHierarchy.h"
#import <objc/runtime.h>
#import "YCAssistiveDefine.h"
#import "UIColor+AssistiveColor.h"

@interface UIView ()

@property (nonatomic, strong) CALayer *hierarcgyLayer;

@end

@implementation UIView (AssistiveHierarchy)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YCSwizzleInstanceMethod([self class], @selector(layoutSubviews), @selector(as_layoutSubViews));
    });
}

- (void)as_layoutSubViews {
    
    [self as_layoutSubViews];
    
}

- (void)as_viewHierarchyEnable:(BOOL)enable {
    
    UIWindow *statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];
    if (statusBarWindow && [self isDescendantOfView:statusBarWindow]) {
        return;
    }
    for (UIView *subView in self.subviews) {
        [subView as_viewHierarchyEnable:enable];
    }
    if (enable) {
        
        if (!self.hierarcgyLayer) {
            self.hierarcgyLayer = [[CALayer alloc] init];
            self.hierarcgyLayer.borderWidth = 1.0;
            self.hierarcgyLayer.borderColor = [UIColor as_randomColor].CGColor;
            [self.layer addSublayer:self.hierarcgyLayer];
        }
        self.hierarcgyLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        self.hierarcgyLayer.hidden = NO;
    }else {
        if (self.hierarcgyLayer) {
            self.hierarcgyLayer.hidden = YES;
        }
    }
}

- (void)setHierarcgyLayer:(CALayer *)hierarcgyLayer {
    
    objc_setAssociatedObject(self, @selector(hierarcgyLayer), hierarcgyLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)hierarcgyLayer {
    
    return objc_getAssociatedObject(self, _cmd);
}
@end
