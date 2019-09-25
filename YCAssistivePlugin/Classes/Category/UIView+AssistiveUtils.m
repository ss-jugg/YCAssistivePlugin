//
//  UIView+AssistiveUtils.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/11.
//

#import "UIView+AssistiveUtils.h"

@implementation UIView (AssistiveUtils)

- (CGFloat)as_width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)as_height {
    
    return CGRectGetHeight(self.frame);
}

- (CGFloat)as_right {
    
    return self.frame.origin.x+self.frame.size.width;
}

- (CGFloat)as_left {
    return self.frame.origin.x;
}

- (CGFloat)as_top {
    return self.frame.origin.y;
}

- (CGFloat)as_bottom {
    return self.frame.origin.y+self.frame.size.height;
}

- (UIImage *)as_convertViewToImage {
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
