//
//  YCViewHierarchyViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCViewHierarchyViewController.h"
#import "YCViewHierarchyPickerView.h"
#import "YCViewHierarchyInfoView.h"
#import "UIView+AssistiveUtils.h"
#import "UIViewController+AssistiveUtil.h"
#import "UIColor+AssistiveColor.h"

@interface YCViewHierarchyViewController ()<YCViewHierarchyPickerViewDelegate,YCViewHierarchyInfoViewDelegate>

@property (nonatomic, strong) YCViewHierarchyPickerView *pickerView;

@property (nonatomic, strong) YCViewHierarchyInfoView *infoView;

@property (nonatomic, strong) NSMutableSet *observedViews;

@property (nonatomic, strong) NSMutableDictionary *borderViews;

@end

@implementation YCViewHierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
}

- (void)initialUI {
    
    self.observedViews = [[NSMutableSet alloc] init];
    self.borderViews = [[NSMutableDictionary alloc] init];
    
    self.pickerView = [[YCViewHierarchyPickerView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
    self.pickerView.center = self.view.center;
    
    self.infoView = [[YCViewHierarchyInfoView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([UIScreen mainScreen].bounds)-80-10, CGRectGetWidth([UIScreen mainScreen].bounds)-20, 80)];
    self.infoView.delegate = self;
    [self.view addSubview:self.infoView];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint pPoint = [self.view convertPoint:point toView:self.pickerView];
    CGPoint iPoint = [self.view convertPoint:point toView:self.infoView];
    if ([self.pickerView pointInside:pPoint withEvent:nil] || [self.infoView pointInside:iPoint withEvent:nil]) {
        return YES;
    }
    return NO;
}

- (void)beginObserveView:(UIView *)view borderWidth:(CGFloat)borderWidth {
    
    if ([self.observedViews containsObject:view]) {
        return;
    }
    UIView *borderView = [[UIView alloc] init];
    [self.view insertSubview:borderView atIndex:0];
    borderView.layer.borderWidth = borderWidth;
    borderView.layer.borderColor = view.as_hashColor.CGColor;
    borderView.frame = [self frameInLocalForView:view];
    [self.borderViews setObject:borderView forKey:@(view.hash)];
    [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObservedView:(UIView *)view {
    
    if (![self.observedViews containsObject:view]) {
        return;
    }
    
    UIView *borderView = self.borderViews[@(view.hash)];
    [borderView removeFromSuperview];
    [view removeObserver:self forKeyPath:@"frame"];
}

- (CGRect)frameInLocalForView:(UIView *)view {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect rect = [view convertRect:view.bounds toView:window];
    rect = [self.view convertRect:rect fromView:window];
    return rect;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isKindOfClass:[UIView class]]) {
        [self updateOverlayIfNeeded:(UIView *)object];
    }
}

- (void)updateOverlayIfNeeded:(UIView *)view {
    UIView *borderView = self.borderViews[@(view.hash)];
    if (borderView) {
        borderView.frame = [self frameInLocalForView:view];
    }
}

#pragma mark - YCViewHierarchyPickerViewDelegate
- (void)hierarchyPickerView:(YCViewHierarchyPickerView *)pickerView didPickView:(nonnull NSArray<UIView *> *)targetViews {
    
    @synchronized (self) {
        for (UIView *view in self.observedViews) {
            [self removeObservedView:view];
        }
        [self.observedViews removeAllObjects];
        [targetViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat borderWidth = 1.0;
            if (idx == targetViews.count - 1) {
                borderWidth = 2.0;
            }
            [self beginObserveView:obj borderWidth:borderWidth];
        }];
        [self.observedViews addObjectsFromArray:targetViews];
    }
    [self.infoView updateViewInfo:targetViews.lastObject];
}

#pragma mark - YCViewHierarchyInfoViewDelegate
- (void)closeHierarchyInfoView:(YCViewHierarchyInfoView *)infoView {
    
    [self pluginWindowDidClosed];
}
@end
