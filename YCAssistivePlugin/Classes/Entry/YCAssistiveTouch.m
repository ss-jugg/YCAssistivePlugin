//
//  YCAssistiveTouch.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import "YCAssistiveTouch.h"
#import "YCAssistiveMacro.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface YCAssistiveTouch ()

/* 初始时位置 */
@property (nonatomic, assign) CGRect initialFrame;
/* 显示文本 */
@property (nonatomic, strong) UILabel *assistiveLabel;

@property (nonatomic, assign) CGFloat transX;
@property (nonatomic, assign) CGFloat transY;

@end
@implementation YCAssistiveTouch

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.initialFrame = frame;
        self.layer.cornerRadius = kAssistiveTouchW/2.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:169/255.0 blue:26/255.0 alpha:1.0];
        [self setUpDefaultUIS];
        [self addTapGesture];
        [self addLongPressGesture];
        [self addDragGesture];
    }
    return self;
}

- (void)setUpDefaultUIS {
    
    self.assistiveLabel = [UILabel new];
    self.assistiveLabel.font = [UIFont systemFontOfSize:11.0];
    self.assistiveLabel.textAlignment = NSTextAlignmentCenter;
    self.assistiveLabel.numberOfLines = 0;
    self.assistiveLabel.text = @"Debug";
    self.assistiveLabel.textColor = [UIColor whiteColor];
    self.assistiveLabel.frame = self.bounds;
    [self addSubview:self.assistiveLabel];
}

- (void)dealloc {
    
    [self.tapSubject sendCompleted];
    [self.longPressSubject sendCompleted];
}

#pragma mark - 手势事件
- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    weak(self)
    [tapGesture.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        strong(self)
        if (self.tapSubject) {
            [self.tapSubject sendNext:x];
        }
    }];
    [self addGestureRecognizer:tapGesture];
}

- (void)addLongPressGesture {

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] init];
    longPressGesture.minimumPressDuration = 1.0;
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

#pragma mark - 移动
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture {

    _transX = [panGesture translationInView:self].x;
    _transY = [panGesture translationInView:self].y;
    panGesture.view.center = CGPointMake(panGesture.view.center.x + _transX, panGesture.view.center.y + _transY);
    [panGesture setTranslation:CGPointZero inView:self];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGFloat self_x = self.frame.origin.x;
        CGFloat self_y = self.frame.origin.y;
        CGFloat self_w = self.frame.size.width;
        CGFloat self_H = self.frame.size.height;
        //修正坐标
        [self resetFrameX:self_x y:self_y w:self_w h:self_H];
        
        //停留在边缘
        if (self_y < touch_minY(self) + 3) {
            [self resetFrameX:self_x y:touch_minY(self) w:self_w h:self_H];
        }else {
            if (self_x < self.superview.frame.size.width/2.0) {
                [self resetFrameX:touch_minX() y:self_y w:self_w h:self_H];
            }else {
                [self resetFrameX:touch_maxX(self) y:self_y w:self_w h:self_H];
            }
        }
        if (self_y > touch_maxY(self) - 3) {
            if (self_x < self.superview.frame.size.width/2.0) {
                [self resetFrameX:self_x y:touch_maxY(self) w:self_w h:self_H];
            }else {
                [self resetFrameX:self_x y:touch_maxY(self) w:self_w h:self_H];
            }
        }
    }
}

- (void)resetFrameX:(CGFloat)x y:(CGFloat)y w:(CGFloat)width h:(CGFloat)height {
    
    if (x <= touch_minX())     x = touch_minX();
    if (x >= touch_maxX(self)) x = touch_maxX(self);
    
    if (y <= touch_minY(self)) y = touch_minY(self);
    if (y >= touch_maxY(self)) y = touch_maxY(self);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(x, y, width, height);
    }];
}

CGFloat touch_minY(YCAssistiveTouch* obj) {

    return 88.0;
}

CGFloat touch_maxY(YCAssistiveTouch* obj) {
    CGFloat bottom = 86.0;
    return (obj.superview.bounds.size.height - obj.initialFrame.size.height - bottom);
}

CGFloat touch_minX(void) {
    return 3.0;
}

CGFloat touch_maxX(YCAssistiveTouch* obj) {
    return (obj.superview.bounds.size.width - obj.initialFrame.size.width - touch_minX());
}

@end
