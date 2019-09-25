//
//  YCAppInfoCell.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCAppInfoModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

+ (instancetype)modelWithName:(NSString *)name value:(NSString *)value;

- (NSString  *)infoValue;

@end

@interface YCAssistiveAppInfoCell : UITableViewCell

- (void)renderUIWithModel:(YCAppInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
