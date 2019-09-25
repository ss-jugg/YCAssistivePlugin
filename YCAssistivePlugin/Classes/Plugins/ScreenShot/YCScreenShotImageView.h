//
//  YCScreenShotImageView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/11.
//

#import <UIKit/UIKit.h>
#import "YCScreenShotOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCScreenShotImageView : UIView

@property (nonatomic, strong) UIImage *shotImage;

@property (nonatomic, strong, nullable) YCScreenShotOperation *currentOperation;

@property (nonatomic, assign) YCScreenShotAction currentAction;

@property (nonatomic, strong) YCScreenShotStyleModel *styleModel;

- (void)removeLastOperation;
@end

NS_ASSUME_NONNULL_END
