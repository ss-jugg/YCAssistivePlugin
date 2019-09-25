//
//  YCScreenShotStyleView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCScreenShotStyleModel;
@interface YCScreenShotStyleView : UIView


- (YCScreenShotStyleModel *)currentStyleModel;

- (void)resetStyleView;

@end

NS_ASSUME_NONNULL_END
