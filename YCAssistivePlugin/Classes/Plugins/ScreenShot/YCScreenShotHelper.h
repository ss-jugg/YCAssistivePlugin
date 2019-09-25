//
//  YCScreenShotHelper.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCScreenShotHelper : NSObject

+ (instancetype)sharedInstance;

/* 是否开启截图功能 */
@property (nonatomic, assign, getter=isEnable) BOOL enable;

/**
 当前页面截图

 @return 当前页图片
 */
- (UIImage *_Nullable)imageFromCurrentScreen;

/**
 根据比例截图

 @param scale 缩放比例
 @return 图片
 */
- (UIImage *_Nullable)imageFromCurrentScreen:(CGFloat)scale;

/**
 保存截图

 @param image 图片
 @param name 图片名
 @param complete 回调
 */
- (void)saveScreenShot:(UIImage *)image name:(NSString *_Nullable)name complete:(void(^_Nullable)(BOOL isFinished))complete;

@end

NS_ASSUME_NONNULL_END
