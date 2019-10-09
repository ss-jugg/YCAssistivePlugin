//
//  YCSandBoxCell.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCSandBoxModel;
@interface YCSandBoxCell : UITableViewCell
+ (CGFloat)heightForCell;
- (void)renderUIWithModel:(YCSandBoxModel *)model;
@end

NS_ASSUME_NONNULL_END
