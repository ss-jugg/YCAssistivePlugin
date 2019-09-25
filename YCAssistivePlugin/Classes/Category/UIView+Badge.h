//
//  UIView+Badge.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/2.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YCBadgeStyle) {
    YCBadgeStyleDot,        //红点标记
    YCBadgeStyleNumber,     //数值
    YCBadgeStyleNew,        //new
};

typedef NS_ENUM(NSUInteger, YCBadgeAnimType) {
    YCBadgeAnimTypeNone,        //无动画
    YCBadgeAnimTypeScale,       //缩放动画
    YCBadgeAnimTypeShake,       //摇动动画
    YCBadgeAnimTypeBounce,      //反弹动画
    YCBadgeAnimTypeBreathe      //呼吸动画
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Badge)

//标记
@property (nonatomic, strong) UILabel *badge;
//标记字体大小
@property (nonatomic, strong) UIFont *badgeFont;
//标记背景色
@property (nonatomic, strong) UIColor *badgeBgColor;
//标记文本颜色
@property (nonatomic, strong) UIColor *badgeTextColor;
//badge 位置
@property (nonatomic, assign) CGRect badgeFrame;
//badge 中心位置
@property (nonatomic, assign) CGPoint badgeCenterOffset;
//动画
@property (nonatomic, assign) YCBadgeAnimType animType;
//最大显示数字
@property (nonatomic, assign) NSInteger badgeMaximumBadgeNumber;
//red dot 圆角大小
@property (nonatomic, assign) CGFloat badgeRadius;

- (void)yc_showDotBadge;
- (void)yc_showDotBadgeWithAnimTyoe:(YCBadgeAnimType)animType;

- (void)yc_showNumberBadgeWithValue:(NSInteger)value;
- (void)yc_showNumberBadgeWithValue:(NSInteger)value animType:(YCBadgeAnimType)animType;

- (void)yc_showNewBadge;
- (void)yc_showNewBadgeWithAnimType:(YCBadgeAnimType)animType;

- (void)yc_removeBadge;
@end

NS_ASSUME_NONNULL_END
