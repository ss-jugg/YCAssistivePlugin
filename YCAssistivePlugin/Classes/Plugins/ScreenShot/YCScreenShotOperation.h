//
//  YCScreenShotAction.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import <Foundation/Foundation.h>
#import "YCScreenShotDefine.h"
#import "YCScreenShotStyleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCScreenShotOperation : NSObject

@property (nonatomic, assign) YCScreenShotAction action;
@property (nonatomic, assign) YCScreenShotStyle size;
@property (nonatomic, assign) YCScreenShotStyle color;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

- (instancetype)initWithStyle:(YCScreenShotStyleModel *)styleModel action:(YCScreenShotAction)action;

- (void)drawImageView:(CGRect)rect;

- (CGRect)rectWithPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint;

@end

@interface YCScreenShotDoubleOperation : YCScreenShotOperation

/* 起点 */
@property (nonatomic, strong) NSValue *startValue;
/* 终点 */
@property (nonatomic, strong) NSValue *endValue;

@end

@interface YCScreenShotRectOperation : YCScreenShotDoubleOperation

@end

@interface YCScreenShotRoundOperation : YCScreenShotDoubleOperation

@end

@interface YCScreenShotLineOperation : YCScreenShotDoubleOperation

@end

@interface YCScreenShotDrawOperation : YCScreenShotOperation

/**
 CGPoint value. add operation point.
 */
- (void)addValue:(NSValue *)value;

@end

@interface YCScreenShotTextOperation : YCScreenShotOperation<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

NS_ASSUME_NONNULL_END
