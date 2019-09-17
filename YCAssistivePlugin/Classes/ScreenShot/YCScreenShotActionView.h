//
//  YCScreenShotActionView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import <UIKit/UIKit.h>
#import "YCScreenShotDefine.h"

NS_ASSUME_NONNULL_BEGIN
@class YCScreenShotActionView;
@protocol YCScreenShotActionViewDelegate <NSObject>

@optional
- (void)screenShotActionView:(YCScreenShotActionView *)view didSelectedAction:(YCScreenShotAction)action isSelected:(BOOL)isSelected atPosition:(CGFloat)position;

@end

@interface YCScreenShotActionView : UIView

@property (nonatomic, weak) id<YCScreenShotActionViewDelegate> actionDelegate;

@end

NS_ASSUME_NONNULL_END
