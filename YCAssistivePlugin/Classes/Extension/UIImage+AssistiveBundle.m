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

@end
