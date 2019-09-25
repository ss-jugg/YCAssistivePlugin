//
//  UIColor+AssistiveColor.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/3.
//

#import "UIColor+AssistiveColor.h"

#define ASColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation UIColor (AssistiveColor)

+ (UIColor *)as_mainColor {
    return ASColorFromRGB(0xF5A623);
}

+ (UIColor *)as_backgroudColor {
    return ASColorFromRGB(0x002833);
}

+ (UIColor *)as_lineColor {
    return ASColorFromRGB(0xEEEEEE);
}

+ (UIColor *)as_redColor {
    return ASColorFromRGB(0xFF3B30);
}

+ (UIColor *)as_greenColor {
    return ASColorFromRGB(0x59B50A);
}

+ (UIColor *)as_titleColor {
    return ASColorFromRGB(0x121D32);
}

+ (UIColor *)as_bodyColor {
    return ASColorFromRGB(0x3C3D49);
}

+ (UIColor *)as_secondaryColor {
    return ASColorFromRGB(0x5B6071);
}

+ (UIColor *)as_describeColor {
    return ASColorFromRGB(0x9B9EA8);
}

+ (UIColor *)as_tipColor {
    return ASColorFromRGB(0xB3B7C2);
}

+ (UIColor *)as_cellColor {
    return ASColorFromRGB(0x004455);
}

+ (UIColor *)as_customColor:(long long)hex {
    return ASColorFromRGB(hex);
}

+ (UIColor *)as_colorWithHex:(NSString *)hex {
    if ([hex length] < 6){//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString = [hex lowercaseString];
    if ([tempString hasPrefix:@"0x"]) {//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    } else if ([tempString hasPrefix:@"#"]) {//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] != 6){
        return [UIColor blackColor];
    }
    
    //分解三种颜色的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [tempString substringWithRange:range];
    range.location = 2;
    NSString *gString = [tempString substringWithRange:range];
    range.location = 4;
    NSString *bString = [tempString substringWithRange:range];
    
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
