//
//  YCAssistiveFunctionCell.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCAssistiveFunctionViewModel;
@interface YCAssistiveFunctionCell : UITableViewCell

- (void)bindFunctionModel:(YCAssistiveFunctionViewModel *)model;

+ (CGFloat)heightForCell:(YCAssistiveFunctionViewModel *)model;
@end

NS_ASSUME_NONNULL_END
