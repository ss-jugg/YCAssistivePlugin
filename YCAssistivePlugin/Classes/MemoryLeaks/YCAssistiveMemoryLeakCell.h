//
//  YCAssistiveMemoryLeakCell.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCAssistiveMeomryLeakModel;
@interface YCAssistiveMemoryLeakCell : UITableViewCell

- (void)bindModel:(YCAssistiveMeomryLeakModel *)model;
@end

NS_ASSUME_NONNULL_END
