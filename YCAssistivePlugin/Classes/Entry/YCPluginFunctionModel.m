//
//  YCPluginFunctionModel.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/26.
//

#import "YCPluginFunctionModel.h"

@implementation YCPluginFunctionModel

+ (instancetype)functionModelWithTitle:(NSString *)title command:(RACCommand *)command {
    YCPluginFunctionModel *model = [[YCPluginFunctionModel alloc] init];
    model.title = title;
    model.didSelectedCommand = command;
    return model;
}

@end
