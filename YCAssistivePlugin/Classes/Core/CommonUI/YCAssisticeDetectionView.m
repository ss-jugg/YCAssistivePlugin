//
//  YCAssisticeDetectionView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssisticeDetectionView.h"
#import "UIColor+AssistiveColor.h"
#import "UIView+AssistiveUtils.h"

@implementation YCAssistivePoint

+ (instancetype)pointWithX:(CGFloat)x y:(CGFloat)y {

    YCAssistivePoint *point = [[YCAssistivePoint alloc] init];
    point.pointX = x;
    point.pointY = y;
    return point;
}

@end

@interface YCAssisticeDetectionView ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, strong) NSMutableArray *pointList;
@property (nonatomic, strong) NSMutableArray *pointLayerList;

@property (nonatomic, strong) UILabel *tipLbl;
@property (nonatomic, strong) CAShapeLayer *lineLayer;

@property (nonatomic, assign) CGFloat originX;

@end

@implementation YCAssisticeDetectionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.startX = 10;
        self.pointList = [[NSMutableArray alloc] init];
        self.pointLayerList = [[NSMutableArray alloc] init];
        self.originX = 0;
        self.numberOfPoints = 12;
        [self initializeUI];
        
    }
    return self;
}

- (void)initializeUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.clipsToBounds = NO;
    
    self.tipLbl = [[UILabel alloc] init];
    self.tipLbl.textColor = [UIColor as_mainColor];
    self.tipLbl.font = [UIFont systemFontOfSize:12];
    self.tipLbl.textAlignment = NSTextAlignmentCenter;
    self.tipLbl.hidden = YES;
    [self addSubview:self.tipLbl];
}

- (void)addValue:(NSString *)value atHeight:(CGFloat)pointHeight {
    
    CGFloat x = self.originX;
    CGFloat y = 0;
    CGFloat width = self.as_width;
    CGFloat height = self.as_height;
    
    CGFloat padding = width / self.numberOfPoints;
    if (self.pointList.count == 0) {
        x = self.startX;
    }else {
        if (x <= width-padding) {
            x += padding;
        }
    }
    self.originX = x;
    y = fabs(MIN(height, pointHeight));
    YCAssistivePoint *point = [YCAssistivePoint pointWithX:x y:y];
    [self.pointList addObject:point];
    
    if (self.pointList.count > self.numberOfPoints) {
        //移除超出部分
        NSMutableArray *oldList = [NSMutableArray array];
        for (YCAssistivePoint *point in self.pointList) {
            point.pointX -= padding;
            if (point.pointX < self.startX) {
                [oldList addObject:point];
            }
        }
        [_pointList removeObjectsInArray:oldList];
    }
    
    [self drawLineInPoints];
    [self showTipWithValue:value atPoint:point];
}

- (void)drawLineInPoints {
    
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
    }
    if (self.pointLayerList.count > 0) {
        [self.pointLayerList makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.pointLayerList removeAllObjects];
    }
    if (self.pointList.count == 0) {
        return;
    }
    
    UIBezierPath *linePath = [UIBezierPath  bezierPath];
    linePath.lineWidth = 2;
    YCAssistivePoint *p = self.pointList[0];
    CGPoint p1 = CGPointMake(p.pointX, self.as_height-p.pointY);
    [linePath moveToPoint:p1];
    [self addPointLayer:p1];
    
    for (NSInteger i=1; i < self.pointList.count; i++) {
        p = self.pointList[i];
        CGPoint p2 = CGPointMake(p.pointX, self.as_height-p.pointY);
        [linePath addLineToPoint:p2];
        [self addPointLayer:p2];
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = linePath.CGPath;
    layer.strokeColor = [UIColor as_mainColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    self.lineLayer = layer;
    [self.layer addSublayer:layer];
    
    for (CALayer *layer in self.pointLayerList) {
        [self.layer addSublayer:layer];
    }
}

//MARK:绘制半径为2的圆点
- (void)addPointLayer:(CGPoint)point{
    
    CALayer *pointLayer = [CALayer layer];
    pointLayer.backgroundColor = [UIColor as_mainColor].CGColor;
    pointLayer.cornerRadius = 2;
    pointLayer.frame = CGRectMake(point.x-2, point.y-2, 4, 4);
    [self.pointLayerList addObject:pointLayer];
}


- (void)showTipWithValue:(NSString *)value atPoint:(YCAssistivePoint *)p {
    
    if (self.tipLbl.hidden) {
        self.tipLbl.hidden = NO;
    }
    self.tipLbl.text = value;
    [self.tipLbl sizeToFit];
    self.tipLbl.frame = CGRectMake(p.pointX, self.as_height-p.pointY-self.tipLbl.as_height, self.tipLbl.as_width, self.tipLbl.as_height);
}

- (void)resetDetectionView {
    
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
    }
    if (self.pointLayerList.count > 0) {
        [self.pointLayerList makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    }
    if (self.pointList.count > 0) {
        [self.pointList removeAllObjects];
    }
    self.tipLbl.hidden = YES;
}

@end
