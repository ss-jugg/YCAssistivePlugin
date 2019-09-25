//
//  YCAssistiveDebuggerView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/24.
//

#import "YCAssistiveDebuggerView.h"
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"
#import "UIView+AssistiveUtils.h"
#import "UIViewController+AssistiveUtil.h"

@interface YCAssistiveDebuggerView ()

@property (nonatomic, strong) UILabel *debuggerLbl;

@end

@implementation YCAssistiveDebuggerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    
    self.debuggerLbl = [[UILabel alloc] initWithFrame:self.bounds];
    self.debuggerLbl.font = [UIFont as_15];
    self.debuggerLbl.textColor = [UIColor as_mainColor];
    self.debuggerLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.debuggerLbl];
    [self updateText];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self updateText];
}

- (void)updateText {
    
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    Class cls = [[rootVC as_topViewController] class];
    self.debuggerLbl.text = [NSString stringWithFormat:@"%@",NSStringFromClass(cls)];
}

- (void)viewDidClose {
    self.closeHandler();
}




@end
