//
//  YCAssistivePerformanceViewController.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/27.
//

#import <UIKit/UIKit.h>
#import "YCAssistiveDetectionInfoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCAssistivePerformanceViewController : UIViewController

@property (nonatomic, strong) YCAssistiveDetectionInfoView *fpsView;
@property (nonatomic, strong) YCAssistiveDetectionInfoView *cpuView;
@property (nonatomic, strong) YCAssistiveDetectionInfoView *memoryView;

- (void)showFPSView;
- (void)showCPUView;
- (void)showMemoryView;

- (NSString *)titleForView;

@end

NS_ASSUME_NONNULL_END
