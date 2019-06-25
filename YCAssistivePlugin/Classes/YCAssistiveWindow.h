//
//  YCAssistiveWindow.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YCAssistiveWindow;
@protocol YCAssistiveWindowDelegate <NSObject>
@required
- (BOOL)window:(YCAssistiveWindow *)window shouldHandleTouchAtPoint:(CGPoint)pointInWindow;
- (BOOL)canBecomeKeyWindow:(YCAssistiveWindow *)window;
@end

@interface YCAssistiveWindow : UIWindow
/* <#mark#> */
@property (nonatomic, weak) id<YCAssistiveWindowDelegate> yc_delegate;
@end

NS_ASSUME_NONNULL_END
