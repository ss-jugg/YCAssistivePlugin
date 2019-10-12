//
//  YCViewHierarchyPickerView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCViewHierarchyPickerView.h"
#import "UIView+AssistiveUtils.h"
#import "UIColor+AssistiveColor.h"
#import "UIImage+AssistiveBundle.h"

@interface YCViewHierarchyPickerView ()

@property (nonatomic, strong) UIImageView *pickerImgView;
@end

@implementation YCViewHierarchyPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initialUI];
    }
    return self;
}

- (void)initialUI {
    
    self.overflow = YES;
    self.pickerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.as_width, self.as_width)];
    self.pickerImgView.image = [UIImage as_imageWithName:@"icon_dingdian"];
    [self addSubview:self.pickerImgView];
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
        if (subview.hidden || subview.alpha < 0.01) {
            continue;
        }
        
        BOOL subviewContainsPoint = CGRectContainsPoint(subview.frame, pointInView);
        if (subviewContainsPoint) {
            [subviewsAtPoint addObject:subview];
            CGPoint pointInSubview = [view convertPoint:pointInView toView:subview];
            [subviewsAtPoint addObjectsFromArray:[self recursiveSubviewsAtPoint:pointInSubview inView:subview]];
        }
    }
    return subviewsAtPoint;
}


@end
