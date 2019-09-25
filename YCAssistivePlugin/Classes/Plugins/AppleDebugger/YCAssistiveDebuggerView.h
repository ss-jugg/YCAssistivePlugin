//
//  YCAssistiveDebuggerView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAssistiveDisplayView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveDebuggerView : YCAssistiveDisplayView

@property (nonatomic, copy) void(^closeHandler)(void);

@end

NS_ASSUME_NONNULL_END
