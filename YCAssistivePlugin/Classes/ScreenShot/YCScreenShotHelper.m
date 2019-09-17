//
//  YCScreenShotHelper.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import "YCScreenShotHelper.h"
#import "YCAssistiveManager.h"
#import "YCScreenShotPreviewViewController.h"
@interface YCScreenShotHelper ()

/* 图片保存路径 */
@property (nonatomic, copy) NSString *screenshotPath;

@end

@implementation YCScreenShotHelper

+ (instancetype)sharedInstance {
    
    static YCScreenShotHelper *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCScreenShotHelper alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        self.screenshotPath = [doc stringByAppendingPathComponent:@"YCAssistiveScreenShot"];
    }
    return self;
}

#pragma mark - Public
- (void)setEnable:(BOOL)enable {
    
    if (_enable != enable) {
        _enable = enable;
        if (enable) {
            [self registerScreenshot];
        } else {
            [self unregisterScreenshot];
        }
    }
}

- (UIImage *_Nullable)imageFromCurrentScreen {
    
    return [self imageFromCurrentScreen:0];
}

- (UIImage *_Nullable)imageFromCurrentScreen:(CGFloat)scale {
    
    return [self screenshotWithScale:scale];
}

- (void)saveScreenShot:(UIImage *)image name:(NSString *_Nullable)name complete:(void(^_Nullable)(BOOL isFinished))complete {
    
    if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self saveScreenShot:image name:name complete:complete];
        });
        return;
    }
    if (name.length == 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        name = [dateFormatter stringFromDate:[NSDate date]];
    }
    name = [name stringByAppendingPathExtension:@"png"];
    NSString *path = [self.screenshotPath stringByAppendingPathComponent:name];
    BOOL res = [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    if (complete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(res);
        });
    }
}

#pragma mark - Primary
- (void)registerScreenshot {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserDidTakeScreenshotNotification:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)unregisterScreenshot {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)receiveUserDidTakeScreenshotNotification:(NSNotification *)notification {
    
    [self simulateTakeScreenShot];
}

- (void)simulateTakeScreenShot {
    
    if (self.enable) {
        UIImage *image = [self imageFromCurrentScreen];
        if ([YCAssistiveManager sharedManager].assistiveWindow.hidden) {
            [[YCAssistiveManager sharedManager] showAssistive];
        }
        if (image) {
            YCScreenShotPreviewViewController *previewVC = [[YCScreenShotPreviewViewController alloc] init];
            previewVC.shotImage = image;
            [[YCAssistiveManager sharedManager].assistiveWindow.rootViewController presentViewController:previewVC animated:YES completion:nil];
        }
    }
}

#pragma mark - 截图
- (nullable UIImage *)screenshotWithScale:(CGFloat)scale {
    
    CGSize imageSize = CGSizeZero;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
#pragma clang diagnostic pop
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] windows]];
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"_statusBar"];
    if ([statusBar isKindOfClass:[UIView class]]) {
        [windows addObject:statusBar];
    }
    for (UIView *window in windows)
    {
        Class cls = NSClassFromString(@"YCAssistiveWindow");
        if (!window.isHidden && cls != nil && ![window isKindOfClass:cls]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, window.center.x, window.center.y);
            CGContextConcatCTM(context, window.transform);
            CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
            if (orientation == UIInterfaceOrientationLandscapeLeft)
            {
                CGContextRotateCTM(context, M_PI_2);
                CGContextTranslateCTM(context, 0, -imageSize.width);
            }
            else if (orientation == UIInterfaceOrientationLandscapeRight)
            {
                CGContextRotateCTM(context, -M_PI_2);
                CGContextTranslateCTM(context, -imageSize.height, 0);
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                CGContextRotateCTM(context, M_PI);
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
            if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
            {
                [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
            }
            else
            {
                [window.layer renderInContext:context];
            }
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
