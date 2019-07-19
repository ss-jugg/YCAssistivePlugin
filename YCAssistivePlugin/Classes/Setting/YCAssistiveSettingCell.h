//
//  YCAssistiveSettingCell.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/19.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN
@class YCAssistiveSettingModel;
@interface YCAssistiveSettingCell : UITableViewCell

- (void)bindSettingModel:(YCAssistiveSettingModel *)model;

@property (nonatomic, strong) RACSubject *switchSignal;
@end

NS_ASSUME_NONNULL_END
