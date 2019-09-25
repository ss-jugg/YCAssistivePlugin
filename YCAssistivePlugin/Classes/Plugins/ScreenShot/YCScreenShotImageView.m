//
//  YCScreenShotImageView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/11.
//

#import "YCScreenShotImageView.h"

@interface YCScreenShotImageView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray<YCScreenShotOperation *> *operations;

@end
@implementation YCScreenShotImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    
    self.operations = [[NSMutableArray alloc] init];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = NO;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imageView];
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 2;
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageView.layer.shadowOffset = CGSizeZero;
    self.imageView.layer.shadowOpacity = 0.5;
}

- (void)setShotImage:(UIImage *)shotImage {
    
    if (_shotImage != shotImage) {
        _shotImage = shotImage;
        self.imageView.image = shotImage;
    }
}

- (void)setCurrentAction:(YCScreenShotAction)currentAction {
    
    if (_currentAction != currentAction) {
        _currentAction = currentAction;
        if (currentAction> YCScreenShotActionNone && currentAction < YCScreenShotActionRevoke) {
            self.userInteractionEnabled = YES;
        }else {
            self.userInteractionEnabled = NO;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self.currentOperation isKindOfClass:[YCScreenShotTextOperation class]]) {
        
        YCScreenShotTextOperation *textOperation = (YCScreenShotTextOperation *)self.currentOperation;
        [textOperation.textView resignFirstResponder];
        if (self.currentAction == YCScreenShotActionText) {
            self.currentOperation = nil;
            return;
        }
    }
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, point)) {
        return;
    }
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    switch (self.currentAction) {
        case YCScreenShotActionRect:{
            
            YCScreenShotRectOperation *operation = [[YCScreenShotRectOperation alloc] initWithStyle:self.styleModel action:YCScreenShotActionRect];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.layer addSublayer:operation.shapeLayer];
            operation.startValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case YCScreenShotActionRound:{
            
            YCScreenShotRoundOperation *operation = [[YCScreenShotRoundOperation alloc] initWithStyle:self.styleModel action:YCScreenShotActionRound];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.layer addSublayer:operation.shapeLayer];
            operation.startValue = pointValue;
            [self setNeedsDisplay];
        }
            
            break;
        case YCScreenShotActionLine:{
            
            YCScreenShotLineOperation *operation = [[YCScreenShotLineOperation alloc] initWithStyle:self.styleModel action:YCScreenShotActionLine];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.layer addSublayer:operation.shapeLayer];
            operation.startValue = pointValue;
            [self setNeedsDisplay];
        }
            
            break;
        case YCScreenShotActionDraw:{
            
            YCScreenShotDrawOperation *operation = [[YCScreenShotDrawOperation alloc] initWithStyle:self.styleModel action:YCScreenShotActionDraw];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.layer addSublayer:operation.shapeLayer];
            [operation addValue:pointValue];
            [self setNeedsDisplay];
        }
            
            break;
        case YCScreenShotActionText:{
            
            if (self.frame.size.height - 30 < point.y) {
                return;
            }
            YCScreenShotTextOperation *operation = [[YCScreenShotTextOperation alloc] initWithStyle:self.styleModel action:YCScreenShotActionText];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self addSubview:operation.textView];
            operation.textView.frame = CGRectMake(point.x, point.y, CGRectGetWidth(self.frame)-10-point.x, 30);
            [operation.textView becomeFirstResponder];
        }
            break;
        default:
            break;
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, point)) {
        return;
    }
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    switch (self.currentAction) {
        case YCScreenShotActionRect:{
            YCScreenShotRectOperation *operation = (YCScreenShotRectOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case YCScreenShotActionRound:{
            YCScreenShotRoundOperation *operation = (YCScreenShotRoundOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case YCScreenShotActionLine:{
            YCScreenShotLineOperation *operation = (YCScreenShotLineOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case YCScreenShotActionDraw:{
            YCScreenShotDrawOperation *operation = (YCScreenShotDrawOperation *)self.currentOperation;
            [operation addValue:pointValue];
            [self setNeedsDisplay];
        }
            break;
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, point)) {
        return;
    }
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    switch (self.currentAction) {
        case YCScreenShotActionRect:{
            YCScreenShotRectOperation *operation = (YCScreenShotRectOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case YCScreenShotActionRound:{
            YCScreenShotRoundOperation *operation = (YCScreenShotRoundOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case YCScreenShotActionLine:{
            YCScreenShotLineOperation *operation = (YCScreenShotLineOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case YCScreenShotActionDraw:{
            YCScreenShotDrawOperation *operation = (YCScreenShotDrawOperation *)self.currentOperation;
            [operation addValue:pointValue];
            [self setNeedsDisplay];
        }
            break;
        default:
            break;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    [self.currentOperation drawImageView:rect];
}

- (void)removeLastOperation {
    
    YCScreenShotOperation *operation = self.operations.lastObject;
    switch (operation.action) {
        case YCScreenShotActionRect:
        case YCScreenShotActionRound:
        case YCScreenShotActionLine:
        case YCScreenShotActionDraw:
        {
            [operation.shapeLayer removeFromSuperlayer];
            [self.operations removeObject:operation];
        }
            break;
        case YCScreenShotActionText:
        {
            YCScreenShotTextOperation *txtOp = (YCScreenShotTextOperation *)operation;
            [txtOp.textView removeFromSuperview];
            [self.operations removeObject:txtOp];
        }
            break;
        default:
            break;
    }
}

@end
