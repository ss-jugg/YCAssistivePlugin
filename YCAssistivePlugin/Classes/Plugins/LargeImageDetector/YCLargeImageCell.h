//
//  YCLargeImageCell.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YCLargeImageModel;
@interface YCLargeImageCell : UITableViewCell

+ (CGFloat)largeImageCellHeight;

- (void)renderUIWithModel:(YCLargeImageModel *)model;
@end

NS_ASSUME_NONNULL_END
