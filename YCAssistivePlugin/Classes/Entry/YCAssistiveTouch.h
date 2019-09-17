//
//  YCAssistiveTouch.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import <UIKit/UIKit.h>

@class RACSubject,YCAssistivePluginItem;

static CGFloat kAssistiveTouchW = 40.0;
@interface YCAssistiveTouch : UIView

/* 点击信号 */
@property (nonatomic, strong) RACSubject *tapSubject;
@property (nonatomic, strong) RACSubject *longPressSubject;

/* 左侧 */
@property (nonatomic, assign) BOOL isLocationAtLeftSide;
/* 是否展开 */
@property (nonatomic, assign) BOOL isShow;

- (instancetype)initWithPluginItems:(NSArray<YCAssistivePluginItem *> *)pluginItems;

- (void)showItems;
- (void)hideItems;

@end


