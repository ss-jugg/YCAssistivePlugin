//
//  YCViewHierarchyInfoView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCAssistiveDisplayView.h"

NS_ASSUME_NONNULL_BEGIN
@class YCViewHierarchyInfoView;
@protocol YCViewHierarchyInfoViewDelegate <NSObject>

- (void)closeHierarchyInfoView:(YCViewHierarchyInfoView *)infoView;

@end
@interface YCViewHierarchyInfoView : YCAssistiveDisplayView

@property (nonatomic, weak) id<YCViewHierarchyInfoViewDelegate> delegate;

- (void)updateViewInfo:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
