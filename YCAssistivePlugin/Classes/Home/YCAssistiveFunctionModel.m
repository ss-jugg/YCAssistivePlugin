//
//  YCAssistiveFunctionModel.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import "YCAssistiveFunctionModel.h"

@implementation YCAssistiveFunctionModel

+ (instancetype)functionModelWithName:(NSString *)name imageName:(NSString *)imageName des:(NSString *)des {
    
    YCAssistiveFunctionModel *model = [[YCAssistiveFunctionModel alloc] init];
    model.name = name;
    model.imageName = imageName;
    model.des = des;
    return model;
}

@end

@implementation YCAssistiveFunctionViewModel

+ (instancetype)viewModelWithTitle:(NSString *)title models:(NSArray<YCAssistiveFunctionModel *> *)models {
    
    YCAssistiveFunctionViewModel *model = [[YCAssistiveFunctionViewModel alloc] init];
    model.title = title;
    model.functionModels = models;
    return model;
    
}

@end
