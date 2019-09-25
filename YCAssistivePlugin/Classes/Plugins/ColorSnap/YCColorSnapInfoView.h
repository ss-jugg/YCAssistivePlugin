//
//  YCColorSnapInfoView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import "YCAssistiveDisplayView.h"

NS_ASSUME_NONNULL_BEGIN
@class YCColorSnapInfoView;
@protocol YCColorSnapInfoViewDelegate <NSObject>

- (void)colorSnapInfoViewDidClose:(YCColorSnapInfoView *)infoView;

@end

@interface YCColorSnapInfoView : YCAssistiveDisplayView

@property (nonatomic, weak) id<YCColorSnapInfoViewDelegate> delegate;

- (void)updateColor:(NSString *)hexColor atPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
