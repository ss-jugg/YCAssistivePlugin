//
//  UIView+AssistiveUtils.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/11.
//

#import "UIView+AssistiveUtils.h"

@implementation UIView (AssistiveUtils)

- (UIImage *)as_convertViewToImage {
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
