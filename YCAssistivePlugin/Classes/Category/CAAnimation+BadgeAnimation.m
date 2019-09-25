//
//  CAAnimation+BadgeAnimation.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/2.
//

#import "CAAnimation+BadgeAnimation.h"

@implementation CAAnimation (BadgeAnimation)

+ (CABasicAnimation *)breatheForever_Animation:(float)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.1];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

+ (CABasicAnimation *)breatheTimes_Animation:(float)repeatTimes durTime:(float)time {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.1];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = repeatTimes;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

+ (CABasicAnimation *)scale_Animation:(CGFloat)fromeScale toScale:(CGFloat)toScale durTime:(float)time rep:(float)repeatTimes {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(fromeScale);
    animation.toValue = @(toScale);
    animation.duration = time;
    animation.autoreverses = YES;
    animation.repeatCount = repeatTimes;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

+ (CAKeyframeAnimation *)shake_AnimationRepratTimes:(float)repeatTimes durTime:(float)time forObj:(id)obj {
    
    NSAssert([obj isKindOfClass:[CALayer class]], @"invalid target");
    CGPoint originPos = CGPointZero;
    CGSize originSize = CGSizeZero;
    if ([obj isKindOfClass:[CALayer class]]) {
        originPos = [(CALayer*)obj position];
        originSize = [(CALayer *)obj bounds].size;
    }
    CGFloat offset = originSize.width / 4;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                         [NSValue valueWithCGPoint:CGPointMake(originPos.x - offset, originPos.y - offset)],
                         [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                         [NSValue valueWithCGPoint:CGPointMake(originPos.x + offset, originPos.y + offset)]
                         ];
    animation.repeatCount = repeatTimes;
    animation.duration = time;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

+ (CAKeyframeAnimation *)bounce_AnimationRepratTimes:(float)repeatTimes durTime:(float)time forObj:(id)obj {
    
    NSAssert([obj isKindOfClass:[CALayer class]] , @"invalid target");
    CGPoint originPos = CGPointZero;
    CGSize originSize = CGSizeZero;
    if ([obj isKindOfClass:[CALayer class]]) {
        originPos = [(CALayer *)obj position];
        originSize = [(CALayer *)obj bounds].size;
    }
    CGFloat hOffset = originSize.height / 4;
    CAKeyframeAnimation* animation=[CAKeyframeAnimation animation];
    animation.keyPath=@"position";
    animation.values=@[
                       [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                       [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y-hOffset)],
                       [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                       [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y+hOffset)],
                       [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)]
                       ];
    animation.repeatCount=repeatTimes;
    animation.duration=time;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

/**
 *  按照圆弧曲线平移
 *
 *  @param duration   动画时长
 *  @param fromPoint  起始点
 *  @param startAngle 开始旋转角度
 *  @param endAngle   结束角度
 *  @param center     圆心
 *  @param radius     半径
 *  @param delegate
 *  @param clockwise  顺时针（NO）逆时针（YES）
 *
 *  @return
 */
+(CAKeyframeAnimation *)moveAccWithDuration:(CFTimeInterval)duration
                                  fromPoint:(CGPoint)fromPoint
                                 startAngle:(CGFloat)startAngle
                                   endAngle:(CGFloat)endAngle
                                     center:(CGPoint)center
                                     radius:(CGFloat)radius
                                   delegate:(id)delegate
                                  clockwise:(BOOL)clockwise{
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.duration = duration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, fromPoint.x, fromPoint.y);
    CGPathAddArc(path, nil, center.x, center.y, radius, startAngle, endAngle, clockwise);
    keyFrameAnimation.path = path;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.delegate  = delegate;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];;
    CGPathRelease(path);
    return keyFrameAnimation;
}

+(CAKeyframeAnimation *)moveLineWithDuration:(CFTimeInterval)duration
                                   fromPoint:(CGPoint)fromPoint
                                     toPoint:(CGPoint)toPoint
                                    delegate:(id)delegate{
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.duration = duration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, fromPoint.x, fromPoint.y);
    CGPathAddLineToPoint(path, nil, toPoint.x, toPoint.y);
    keyFrameAnimation.path = path;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.delegate  = delegate;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];;
    CGPathRelease(path);
    return keyFrameAnimation;
}

#pragma mark - 缩放动画
+(CABasicAnimation *)scaleAnimationWithDuration:(CFTimeInterval)duration frameValue:(CGFloat)frameValue toValue:(CGFloat)toValue{
    //1.实例化基本动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //2.设置动画属性
    //fromValue & toValue
    [anim setFromValue:@(frameValue)];
    //从当前大小缩小到一半，然后恢复初始大小
    [anim setToValue:@(toValue)];
    
    //自动翻转动画
    [anim setAutoreverses:NO];
    //动画时长
    [anim setDuration:duration];
    
    //3.将动画添加到图层
    //    [self.myView.layer addAnimation:anim forKey:nil];
    return anim;
}

/**
 *  动画组
 *
 *  @param animations 动画数组
 *  @param duration   动画时长
 *
 *  @return CAAnimationGroup
 */
+(CAAnimationGroup *)groupAnimationWithAnimations:(NSArray *)animations duration:(CGFloat)duration{
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.animations = animations;
    animationGroup.duration = duration;
    //    animationGroup.fillMode = kCAFillModeForwards;
    //    animationGroup.removedOnCompletion = NO;
    return animationGroup;
    
}

#pragma mark - 透明度
+(CABasicAnimation *)opacityAnimationWithDuration:(CFTimeInterval)duration frameValue:(CGFloat)frameValue toValue:(CGFloat)toValue{
    //1.实例化基本动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    //2.设置动画属性
    //fromValue & toValue
    [anim setFromValue:@(frameValue)];
    //从当前大小缩小到一半，然后恢复初始大小
    [anim setToValue:@(toValue)];
    //自动翻转动画
    //    [anim setAutoreverses:YES];
    //动画时长
    [anim setDuration:duration];
    
    //3.将动画添加到图层
    //    [self.myView.layer addAnimation:anim forKey:nil];
    return anim;
}

@end
