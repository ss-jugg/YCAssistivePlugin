//
//  YCViewHierarchyPickerView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCAssistiveMoveView.h"

NS_ASSUME_NONNULL_BEGIN

@class YCViewHierarchyPickerView;
@protocol YCViewHierarchyPickerViewDelegate <NSObject>

- (void)hierarchyPickerView:(YCViewHierarchyPickerView *)pickerView didPickView:(NSArray<UIView *> *)targetViews;

@end

@interface YCViewHierarchyPickerView : YCAssistiveMoveView

@property (nonatomic, weak) id<YCViewHierarchyPickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
