//
//  YCAssistiveLeaksView.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/16.
//

#import "YCAssistiveLeaksView.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIColor+AssistiveColor.h"
#import "UIFont+AssistiveFont.h"
#import "YCAssistiveMacro.h"
#import "YCAssistiveLeaksManager.h"

@interface YCAssistiveLeaksView ()

/* <#mark#> */
@property (nonatomic, strong) UITextView *textView;

@end

@implementation YCAssistiveLeaksView

- (instancetype)init {
    
    if (self = [super init]) {
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryLeaks:) name:kYCAssistiveMemoryLeakNotificationName object:nil];
    }
    return self;
}

- (void)handleMemoryLeaks:(NSNotification *)notification {
    
    NSDictionary *dict = notification.object;
    self.textView.text = [dict[@"viewStack"] componentsJoinedByString:@"->"];
    
}

- (UITextView *)textView {
    
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont as_13];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.selectable = YES;
    }
    return _textView;
}
@end
