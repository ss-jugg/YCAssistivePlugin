//
//  UIFont+AssistiveFont.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/3.
//

#import "UIFont+AssistiveFont.h"

#define  as_fontName_bold   @"Helvetica-Bold"
#define  as_fontName        @"Helvetica"

@implementation UIFont (AssistiveFont)

+ (UIFont *)as_17 {
    return [UIFont fontWithName:as_fontName size:17];
}
+ (UIFont *)as_17_bold {
    return [UIFont fontWithName:as_fontName_bold size:17];
}

+ (UIFont *)as_15 {
    return [UIFont fontWithName:as_fontName size:15];
}
+ (UIFont *)as_15_bold {
    return [UIFont fontWithName:as_fontName_bold size:15];
}

+ (UIFont *)as_13 {
    return [UIFont fontWithName:as_fontName size:13];
}
+ (UIFont *)as_13_bold {
    return [UIFont fontWithName:as_fontName_bold size:13];
}

+ (UIFont *)as_11 {
    return [UIFont fontWithName:as_fontName size:11];
}
+ (UIFont *)as_11_bold {
    return [UIFont fontWithName:as_fontName_bold size:11];
}
@end
