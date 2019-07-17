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
/* 标题 */
@property (nonatomic, strong) UILabel *leakLbl;
/* leak 开关 */
@property (nonatomic, strong) UISwitch *leakSwitch;

/* <#mark#> */
@property (nonatomic, strong) UILabel *retainCycleLbl;
/* <#mark#> */
@property (nonatomic, strong) UISwitch *retainCycleSwitch;

@end

@implementation YCAssistiveLeaksView

- (instancetype)init {
    
    if (self = [super init]) {
        [self addSubview:self.leakLbl];
        [self addSubview:self.leakSwitch];
        [self addSubview:self.retainCycleLbl];
        [self addSubview:self.retainCycleSwitch];
        [self.leakLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(10);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(80);
        }];
        [self.leakSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leakLbl.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(35, 20));
            make.centerY.equalTo(self.leakLbl);
        }];
        [self.retainCycleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(10);
            make.top.equalTo(self.leakLbl.mas_bottom).offset(10);
            make.width.mas_equalTo(80);
        }];
        [self.retainCycleSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.retainCycleLbl.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(35, 20));
            make.centerY.equalTo(self.retainCycleLbl);
        }];
        
        weak(self);
        RAC([YCAssistiveLeaksManager shareManager], enableLeaks) = [[self.leakSwitch rac_signalForControlEvents:UIControlEventValueChanged] map:^id _Nullable(__kindof UISwitch * _Nullable value) {
            strong(self);
            if (!value.on && self.retainCycleSwitch.on) {
                self.retainCycleSwitch.on = value.on;
                [YCAssistiveLeaksManager shareManager].enableRetainCycle = value.on;
            }
            return @(value.on);
        }];
        RAC([YCAssistiveLeaksManager shareManager], enableRetainCycle) = [[self.retainCycleSwitch rac_signalForControlEvents:UIControlEventValueChanged] map:^id _Nullable(__kindof UISwitch * _Nullable value) {
            strong(self);
            if (!self.leakSwitch.on && value.on) {
                self.leakSwitch.on = value.on;
                [YCAssistiveLeaksManager shareManager].enableLeaks = value.on;
            }
            return @(value.on);
        }];
    }
    return self;
}

- (UILabel *)leakLbl {
    
    if (_leakLbl == nil) {
        _leakLbl = [[UILabel alloc] init];
        _leakLbl.textColor = [UIColor whiteColor];
        _leakLbl.font = [UIFont as_13];
        _leakLbl.textAlignment = NSTextAlignmentLeft;
        _leakLbl.text = @"是否开启内存泄漏检测";
        _leakLbl.numberOfLines = 0;
    }
    return _leakLbl;
}
- (UISwitch *)leakSwitch {
    
    if (_leakSwitch == nil) {
        _leakSwitch = [[UISwitch alloc] init];
        _leakSwitch.on = [YCAssistiveLeaksManager shareManager].enableLeaks;
        _leakSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    return _leakSwitch;
}

- (UILabel *)retainCycleLbl {
    
    if (_retainCycleLbl == nil) {
        _retainCycleLbl = [[UILabel alloc] init];
        _retainCycleLbl.textColor = [UIColor whiteColor];
        _retainCycleLbl.font = [UIFont as_13];
        _retainCycleLbl.textAlignment = NSTextAlignmentLeft;
        _retainCycleLbl.text = @"是否开启循环引用检测";
        _retainCycleLbl.numberOfLines = 0;
    }
    return _retainCycleLbl;
}
- (UISwitch *)retainCycleSwitch {
    
    if (_retainCycleSwitch == nil) {
        _retainCycleSwitch = [[UISwitch alloc] init];
        _retainCycleSwitch.on = [YCAssistiveLeaksManager shareManager].enableRetainCycle;
        _retainCycleSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    return _retainCycleSwitch;
}
@end
