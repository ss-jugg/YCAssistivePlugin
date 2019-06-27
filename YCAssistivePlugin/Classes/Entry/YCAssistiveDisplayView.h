//
//  YCAssistiveDisplayView.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RACSubject;
@interface YCAssistiveDisplayView : UIView

/* 双击信号 */
@property (nonatomic, strong) RACSubject *longPressSubject;

- (void)reactTapWithCls:(Class)cls;

@end

NS_ASSUME_NONNULL_END
