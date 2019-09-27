//
//  YCAssistiveDetectionInfoView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import "YCAssistiveMoveView.h"
#import "YCAssisticeDetectionView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^DetectionCloseBlock)(void);
@interface YCAssistiveDetectionInfoView : YCAssistiveMoveView

@property (nonatomic, strong) YCAssisticeDetectionView *detectionView;

@property (nonatomic, copy) DetectionCloseBlock closeBlock;

- (void)setDetectionInfoViewTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
