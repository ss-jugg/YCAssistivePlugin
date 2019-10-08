//
//  YCAssistiveSettingModel.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/19.
//

#import "YCAssistiveSettingModel.h"
#import <YYModel/YYModel.h>
@implementation YCAssistiveSettingModel

+ (instancetype)settingModelWithTitle:(NSString *)title detail:(NSString *)detail {

    YCAssistiveSettingModel *settingModel = [[YCAssistiveSettingModel alloc] init];
    settingModel.title = title;
    settingModel.detail = detail;
    settingModel.isOn = NO;
    settingModel.switchSignal = [RACSubject subject];
    return settingModel;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

- (id)copy {
    return [self yy_modelCopy];
}

@end
