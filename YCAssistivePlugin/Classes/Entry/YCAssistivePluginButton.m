//
//  YCAssistivePluginButton.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/16.
//

#import "YCAssistivePluginButton.h"
#import "CAAnimation+BadgeAnimation.h"

@interface YCAssistivePluginButton ()
{
    CGPoint _orginPoint; //记录平移前的位置
}
@end
@implementation YCAssistivePluginButton

- (instancetype)initWithSize:(CGSize)size image:(UIImage *)image target:(id)target action:(SEL)action {

    if (self = [super init]) {
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        self.frame = CGRectMake(0, 0, size.width, size.height);
        self.layer.cornerRadius = size.width / 2.0;
    }
    return self;
}

+ (instancetype)pluginButtonWithSize:(CGSize)size image:(UIImage *)image target:(id)target action:(SEL)action {
    YCAssistivePluginButton *pluginBtn = [[YCAssistivePluginButton alloc] initWithSize:size image:image target:target action:action];
    return pluginBtn;
}

-(void)itemShowWithAngle:(CGFloat)angle {
    
    CGPoint targetP = [self caculateTargetPointWith:angle];
    [self itemShowWithTargetPoint:targetP];
}

-(CGPoint)caculateTargetPointWith:(CGFloat)angle{
    CGFloat x = self.center.x;
    CGFloat y = self.center.y;
    
    x += 80 * cos(angle);
    y -= 80 * sin(angle);
    CGPoint targetPoint = CGPointMake(x, y);
    return targetPoint;
}

-(void)itemShowWithTargetPoint:(CGPoint)targetPoint{
    
    _orginPoint = self.center;
    
    CABasicAnimation *scaleAnimation = [CAAnimation scaleAnimationWithDuration:0.4 frameValue:0.1 toValue:1.0];
    CABasicAnimation *opacityAnimation = [CAAnimation opacityAnimationWithDuration:0.4 frameValue:0.3 toValue:1];
    CAKeyframeAnimation *keyframeAnimation = [CAAnimation moveLineWithDuration:0.4 fromPoint:self.center toPoint:targetPoint delegate:self];
    CAAnimationGroup *groupAnimation = [CAAnimation groupAnimationWithAnimations:@[scaleAnimation,keyframeAnimation,opacityAnimation] duration:0.4];
    
    [self.layer addAnimation:groupAnimation forKey:nil];
    self.center = targetPoint;
}

-(void)itemHide{
    //添加动画
    CABasicAnimation *scaleAnimation = [CAAnimation scaleAnimationWithDuration:0.4 frameValue:0.1 toValue:1.0];
    CABasicAnimation *opacityAnimation = [CAAnimation opacityAnimationWithDuration:0.4 frameValue:0.3 toValue:1];
    CAKeyframeAnimation *keyframeAnimation = [CAAnimation moveLineWithDuration:0.4 fromPoint:self.center toPoint:_orginPoint delegate:self];
    CAAnimationGroup *groupAnimation = [CAAnimation groupAnimationWithAnimations:@[scaleAnimation,keyframeAnimation,opacityAnimation] duration:0.4];
    
    [self.layer addAnimation:groupAnimation forKey:nil];
    self.center = _orginPoint;
}


@end
