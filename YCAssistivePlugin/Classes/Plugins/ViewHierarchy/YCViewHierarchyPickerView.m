//
//  YCViewHierarchyPickerView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCViewHierarchyPickerView.h"
#import "UIView+AssistiveUtils.h"
#import "UIColor+AssistiveColor.h"

@implementation YCViewHierarchyPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initialUI];
    }
    return self;
}

- (void)initialUI {
    
    self.overflow = YES;
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.as_width / 2.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor as_mainColor].CGColor;
    
    CAShapeLayer *roundLayer = [CAShapeLayer layer];
    roundLayer.frame = self.bounds;
    CGFloat width = 10.0;
    roundLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.as_width - width)/2.0, (self.as_height - width)/2.0, width, width)].CGPath;
    roundLayer.fillColor = [UIColor as_mainColor].CGColor;
    roundLayer.strokeColor = [UIColor as_mainColor].CGColor;
    roundLayer.lineWidth = 0.5;
    [self.layer addSublayer:roundLayer];
}

- (void)viewDidUpdate:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint {
    
    NSArray<UIView *> *views = [self viewForSelectionAtPoint:self.center];
    
    [self.delegate hierarchyPickerView:self didPickView:views];
}

- (NSArray<UIView *> *)viewForSelectionAtPoint:(CGPoint)selectionPoint {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIWindow *windowForSelection = [[UIApplication sharedApplication] keyWindow];
#pragma clang diagnostic pop
    
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] windows]];
    for (UIWindow *window in windows) {
        if (!window.isHidden && ![window isKindOfClass:NSClassFromString(@"YCAssistiveWindow")] && ![window isKindOfClass:NSClassFromString(@"YCAssistiveBaseWindow")]) {
            if ([window hitTest:selectionPoint withEvent:nil]) {
                windowForSelection = window;
                break;
            }
        }
    }
    NSArray<UIView *> *subViews = [self recursiveSubviewsAtPoint:selectionPoint inView:windowForSelection];
    return subViews;
}

- (NSArray<UIView *> *)recursiveSubviewsAtPoint:(CGPoint)pointInView inView:(UIView *)view {
    
    NSMutableArray<UIView *> *subviewsAtPoint = [NSMutableArray array];
    for (UIView *subview in view.subviews) {
        BOOL isHidden = subview.hidden || subview.alpha < 0.01;
        if (isHidden) {
            continue;
        }
        
        BOOL subviewContainsPoint = CGRectContainsPoint(subview.frame, pointInView);
        if (subviewContainsPoint) {
            [subviewsAtPoint addObject:subview];
        }

        if (subviewContainsPoint || !subview.clipsToBounds) {
            CGPoint pointInSubview = [view convertPoint:pointInView toView:subview];
            [subviewsAtPoint addObjectsFromArray:[self recursiveSubviewsAtPoint:pointInSubview inView:subview]];
        }
    }
    return subviewsAtPoint;
}


@end
