//
//  YCAssistiveHttpCell.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YCAssistiveHttpModel;
@interface YCAssistiveHttpCell : UITableViewCell

/* host */
@property (nonatomic, strong) UILabel *titleLbl;
/* 地址 */
@property (nonatomic, strong) UILabel *detailLbl;
/* 已读标识 */
@property (nonatomic, strong) UILabel *readLbl;

+ (CGFloat)heightForHttpCell;

- (void)bindHttpModel:(YCAssistiveHttpModel *)model;

@end

NS_ASSUME_NONNULL_END
