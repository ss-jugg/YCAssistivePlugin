//
//  YCAssistiveColorSnapView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import "YCColorSnapView.h"
#import "UIColor+AssistiveColor.h"
#import "UIView+AssistiveUtils.h"
#import "UIImage+AssistiveBundle.h"
#import "YCScreenShotHelper.h"

@interface YCColorSnapView ()

@property (nonatomic, strong) UIImage *screenshotImg;
@property (nonatomic, assign) CGPoint targetPoint;

@end

@implementation YCColorSnapView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, self.frame);
    
    //放大镜大小
    CGFloat magnifySize = 100;
    //网格数量
    NSInteger gridNum = 10;
    //网格大小
    CGFloat gridSize = ceilf(magnifySize/gridNum);
    //使用1x
    CGFloat scale = 1.0;

    //采集像素颜色时像素的间隔
    NSInteger pixelSkip = 1;
    CGPoint currentPoint = CGPointMake(self.targetPoint.x * scale, self.targetPoint.y * scale);
    currentPoint.x = round(currentPoint.x - gridNum * pixelSkip / 2.0 * scale);
    currentPoint.y = round(currentPoint.y - gridNum * pixelSkip / 2.0 * scale);
    int i, j;
    NSInteger center = gridNum / 2;
    
    for (j = 0; j < gridNum; j++) {
        for (i = 0; i < gridNum; i++) {
            CGRect gridRect = CGRectMake(gridSize * i, gridSize * j, gridSize, gridSize);
            UIColor *gridColor = [UIColor clearColor];
            NSString *colorHex = [self.screenshotImg as_hexColorAt:currentPoint];
            if (colorHex) {
                gridColor = [UIColor as_colorWithHex:colorHex];
            }
            CGContextSetFillColorWithColor(ref, gridColor.CGColor);
            CGContextFillRect(ref, gridRect);
            if (i == center && j == center) {
                if (colorHex) {
                    [self.delegate colorSnapView:self colorHex:colorHex atPosition:currentPoint];
                }
            }
            currentPoint.x += round(pixelSkip * scale);
        }
        
        currentPoint.x -= round(gridNum * pixelSkip * scale);
        currentPoint.y += round(pixelSkip * scale);
    }
    
    UIGraphicsEndImageContext();
}

- (void)initializeUI {
    self.overflow = YES;
    self.layer.cornerRadius = self.as_width / 2.0;
    self.layer.borderColor = [UIColor as_mainColor].CGColor;
    self.layer.borderWidth = 2.0;
    self.layer.masksToBounds = YES;
    
    NSInteger zoomLevel = 10;
    NSInteger centerX = self.as_width / 2.0;
    NSInteger centerY = self.as_height / 2.0;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = [UIBezierPath bezierPathWithRect:CGRectMake(centerX - zoomLevel / 2.0, centerY - zoomLevel / 2.0, zoomLevel, zoomLevel)].CGPath;
    layer.strokeColor = [UIColor as_mainColor].CGColor;
    layer.fillColor = nil;
    layer.lineWidth = 2;
    [self.layer addSublayer:layer];
}

- (void)pointInSuperView:(CGPoint)point {
    
    self.center = point;
    [self updateScreenshot];
    self.targetPoint = point;
    [self setNeedsDisplay];
}

- (void)updateScreenshot {
    //截1x图
    self.screenshotImg = [[YCScreenShotHelper sharedInstance] imageFromCurrentScreen:1];
}

- (void)viewWillUpdate:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self updateScreenshot];
    }
}

- (void)viewDidUpdate:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint {
    
    CGPoint newTargetPoint = CGPointMake(self.targetPoint.x + offsetPoint.x, self.targetPoint.y + offsetPoint.y);
    if (!CGPointEqualToPoint(newTargetPoint, self.targetPoint)) {
        self.targetPoint = newTargetPoint;
        [self setNeedsDisplay];
    }
}



@end
