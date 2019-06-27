//
//  YCAssistiveTouch.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import <UIKit/UIKit.h>
@class RACSubject;

static CGFloat kAssistiveTouchW = 40.0;
@interface YCAssistiveTouch : UIView

/* 点击信号 */
@property (nonatomic, strong) RACSubject *tapSubject;
@property (nonatomic, strong) RACSubject *longPressSubject;

@end


