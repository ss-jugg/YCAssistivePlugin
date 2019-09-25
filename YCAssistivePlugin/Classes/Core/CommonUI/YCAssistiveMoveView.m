//
//  YCAssistiveMoveView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import "YCAssistiveMoveView.h"
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"
#import "UIView+AssistiveUtils.h"

@interface YCAssistiveMoveView ()

@property (nonatomic, assign) BOOL moved;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;


@end

@implementation YCAssistiveMoveView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.moveable = YES;
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
        
        [self addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}

- (void)panGR:(UIPanGestureRecognizer *)sender {
    
    if (!self.isMoved) {
        self.moved = YES;
    }
    
    CGPoint offsetPoint = [sender translationInView:sender.view];
    
    [self viewWillUpdate:sender offset:offsetPoint];
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
    [self changeFrameWithPoint:offsetPoint];
    
    [self viewDidUpdate:sender offset:offsetPoint];
}


- (void)changeFrameWithPoint:(CGPoint)point {
    
    CGPoint center = self.center;
    center.x += point.x;
    center.y += point.y;
    
    if (self.isOverflow) {
        center.x = MIN(center.x, self.superview.as_width);
        center.x = MAX(center.x, 0);
        
        center.y = MIN(center.y, self.superview.as_height);
        center.y = MAX(center.y, 0);
    } else {
        
        if (center.x < self.as_width / 2.0) {
            center.x = self.as_width / 2.0;
        } else if (center.x > self.superview.as_width - self.as_width / 2.0) {
            center.x = self.superview.as_width - self.as_width / 2.0;
        }
        
        if (center.y < self.as_height / 2.0) {
            center.y = self.as_height / 2.0;
        } else if (center.y > self.superview.as_height - self.as_height / 2.0) {
            center.y = self.superview.as_height - self.as_height / 2.0;
        }
    }
    self.center = center;
}

- (void)viewWillUpdate:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint {
    
}

- (void)viewDidUpdate:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint {
    
}

- (void)setMoveable:(BOOL)moveable {
    if (_moveable != moveable) {
        _moveable = moveable;
        self.panGestureRecognizer.enabled = moveable;
        
    }
}
@end
