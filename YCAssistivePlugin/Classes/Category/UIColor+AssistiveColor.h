//
//  UIColor+AssistiveColor.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (AssistiveColor)

/**
 主色

 @return 黄色 F5A623
 */
+ (UIColor *)as_mainColor;

/**
 背景色

 @return 浅灰色 021F28
 */
+ (UIColor *)as_backgroudColor;

/**
 分割线颜色

 @return #EEEEEE
 */
+ (UIColor *)as_lineColor;

/**
 红色

 @return #FF3B30
 */
+ (UIColor *)as_redColor;

/**
 绿色

 @return #59B50A
 */
+ (UIColor *)as_greenColor;

/**
 标题颜色

 @return #121D32
 */
+ (UIColor *)as_titleColor;

/**
 正文颜色

 @return #3C3D49
 */
+ (UIColor *)as_bodyColor;

/**
 二级文字颜色

 @return #5B6071
 */
+ (UIColor *)as_secondaryColor;

/**
 说明性文字

 @return #9B9EA8
 */
+ (UIColor *)as_describeColor;

/**
 提示文字

 @return #B3B7C2
 */
+ (UIColor *)as_tipColor;

/**
 紫色
 
 @return 6200C0
 */
+ (UIColor *)as_cellColor;

+ (UIColor *)as_customColor:(long long)hex;

+ (UIColor *)as_colorWithHex:(NSString *)hex;
@end

NS_ASSUME_NONNULL_END
