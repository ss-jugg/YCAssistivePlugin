//
//  UIImage+AssistiveBundle.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/8.
//

#import "UIImage+AssistiveBundle.h"

@implementation UIImage (AssistiveBundle)

+ (UIImage *)as_imageWithName:(NSString *)imageName {
    
    NSString *mainBundlePath = [NSBundle mainBundle].bundlePath;
    NSString *bundlePath = [NSString stringWithFormat:@"%@/%@.bundle",mainBundlePath,@"YCAssistivePlugin"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (bundle == nil) {
        bundlePath = [NSString stringWithFormat:@"%@/Frameworks/%@.framework/%@.bundle",mainBundlePath,@"YCAssistivePlugin",@"YCAssistivePlugin"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:@"png"]];
    }
    return nil;
}


- (NSString *)as_hexColorAt:(CGPoint)point {
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    NSString *hexColor = nil;
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    @synchronized (self) {
        NSInteger pointX = trunc(point.x);
        NSInteger pointY = trunc(point.y);
        CGImageRef cgImage = self.CGImage;
        NSUInteger width = self.size.width;
        NSUInteger height = self.size.height;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        int bytesPerPixel = 4;
        int bytesPerRow = bytesPerPixel * 1;
        NSUInteger bitsPerComponent = 8;
        unsigned char pixelData[4] = { 0 };
        CGContextRef context = CGBitmapContextCreate(pixelData,
                                                     1,
                                                     1,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorSpace,
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        
        CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
        CGContextRelease(context);
        
        // Here is a bug, The first row pixelData will always be "#000000", but the second row data is real first row data.
        hexColor = [NSString stringWithFormat:@"#%02X%02X%02X",pixelData[0],pixelData[1],pixelData[2]];
    }
    return hexColor;
}


@end
