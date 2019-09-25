//
//  YCAssistiveColorSnapView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import <UIKit/UIKit.h>
#import "YCAssistiveMoveView.h"
NS_ASSUME_NONNULL_BEGIN

@class YCColorSnapView;
@protocol YCAssistiveColorSnapViewDelegate <NSObject>

- (void)colorSnapView:(YCColorSnapView *)colorSnapView colorHex:(NSString *)colorHex atPosition:(CGPoint)point;

@end

@interface YCColorSnapView : YCAssistiveMoveView

@property (nonatomic, weak) id<YCAssistiveColorSnapViewDelegate> delegate;

- (void)pointInSuperView:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
