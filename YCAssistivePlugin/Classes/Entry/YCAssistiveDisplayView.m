//
//  YCAssistiveDisplayView.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/26.
//

#import "YCAssistiveDisplayView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "YCPluginFunctionView.h"
#import "YCPluginFunctionViewModel.h"
#import "YCAssistiveItemPlugin.h"
#import "YCAssistiveMacro.h"

@interface YCAssistiveDisplayView ()

/* 提示文字 */
@property (nonatomic, strong) UILabel *tapLbl;
/* 初始坐标 */
@property (nonatomic, assign) CGRect initialFrame;

@end
@implementation YCAssistiveDisplayView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor colorWithRed:2/255.f green:31/255.f blue:40/255.f alpha:0.8]];
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tapLbl];
        self.tapLbl.frame = CGRectMake(0, 0, frame.size.width, 20);
        [self addGestures];
        [self _pluginFunctionView];
    }
    return self;
}

- (void)dealloc {
    [self.longPressSubject sendCompleted];
}

- (void)addGestures {
    
    [self addTapGesture];
    [self addDragGesture];
    [self addLongPressGesture];
}

- (void)addTapGesture {
    
    UITapGestureRecognizer *tapGesture = [self builderGesture:^(UITapGestureRecognizer *gesture) {
        gesture.numberOfTouchesRequired = 1;
        weak(self);
        [gesture.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            strong(self);
            [self _pluginFunctionView];
        }];
    }];
    [self.tapLbl addGestureRecognizer:tapGesture];
}

- (UITapGestureRecognizer *)builderGesture:(void(^)(UITapGestureRecognizer *gesture))builder {
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    builder(gesture);
    return gesture;
}

- (void)_pluginFunctionView {
    
    YCPluginFunctionViewModel *viewModel = [[YCPluginFunctionViewModel alloc] init];
    NSMutableArray *functions = [NSMutableArray array];
    for (Class<YCAssistiveItemPluginProtocol> plugin in kYCAssistivePlugins) {
        weak(self)
        YCPluginFunctionModel *model = [YCPluginFunctionModel functionModelWithTitle:[plugin title] command:[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            strong(self);
            [self _resetDisplayView];
            [plugin reactTapForAssistantView:self];
            return [RACSignal empty];
        }]];
        [functions addObject:model];
    }
    viewModel.functions = functions;
    [self _reactPluginView:[[YCPluginFunctionView alloc] initWithViewModel:viewModel]];
}

- (void)addLongPressGesture {
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] init];
    weak(self)
    [longPressGesture.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        strong(self)
        if (self.longPressSubject) {
            [self.longPressSubject sendNext:x];
        }
    }];
    [self addGestureRecognizer:longPressGesture];
}

- (void)addDragGesture {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:panGesture];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    
    CGFloat transX = [panGesture translationInView:self].x;
    CGFloat transY = [panGesture translationInView:self].y;
    panGesture.view.center = CGPointMake(panGesture.view.center.x + transX, panGesture.view.center.y + transY);
    [panGesture setTranslation:CGPointZero inView:self];
}

- (void)reactTapWithCls:(Class)cls {
    
    UIView *view = [[cls alloc] init];
    [self _reactPluginView:view];
}

#pragma mark - private
- (void)_reactPluginView:(UIView *)pluginView {
    
    [self _cleanDisplaySubViews:NO];
    pluginView.alpha = 0.0;
    pluginView.hidden = NO;
    [self addSubview:pluginView];
    pluginView.frame = CGRectMake(0, 20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [UIView animateWithDuration:0.2 animations:^{
        pluginView.alpha = 1;
    }];
}

//MARK:重置
- (void)_resetDisplayView {
    
    [self endEditing:YES];
    [self _cleanDisplaySubViews:YES];
}

- (void)_cleanDisplaySubViews:(BOOL)animation {
    
    weak(self);
    NSArray *subviewsArray = [self.subviews.rac_sequence filter:^BOOL(id  _Nullable value) {
        strong(self);
        return ![value isEqual:self.tapLbl];
    }].array;
    
    if (animation) {
        
        [UIView animateWithDuration:0.15 animations:^{
            [subviewsArray makeObjectsPerformSelector:@selector(setAlpha:) withObject:@0];
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            [subviewsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [subviewsArray makeObjectsPerformSelector:@selector(setHidden:) withObject:@YES];
        }];
    }else {
        [subviewsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (UILabel *)tapLbl {
    
    if (_tapLbl == nil) {
        _tapLbl = [[UILabel alloc] init];
        _tapLbl.text = @"TAP ME";
        _tapLbl.font = [UIFont systemFontOfSize:11.0];
        _tapLbl.backgroundColor = [UIColor orangeColor];
        _tapLbl.textAlignment = NSTextAlignmentCenter;
        _tapLbl.textColor = [UIColor whiteColor];
    }
    return _tapLbl;
}
@end
