//
//  YCAssistiveHttpDetailViewController.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/8.
//

#import <UIKit/UIKit.h>
#import "YCAssistiveBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class YCAssistiveHttpModel;
@interface YCAssistiveHttpDetailViewController : YCAssistiveBaseViewController

/* 已读 */
@property (nonatomic, copy) void(^readHttpBlock)(void);

- (instancetype)initWithHttpModel:(YCAssistiveHttpModel *)model;
@end

NS_ASSUME_NONNULL_END
