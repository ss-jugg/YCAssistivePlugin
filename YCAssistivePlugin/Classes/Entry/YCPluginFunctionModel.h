//
//  YCPluginFunctionModel.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/26.
//

#import <Foundation/Foundation.h>

@class RACCommand;
@interface YCPluginFunctionModel : NSObject

/* 插件名 */
@property (nonatomic, copy) NSString *title;
/* 选中信号 */
@property (nonatomic, strong) RACCommand *didSelectedCommand;

+ (instancetype)functionModelWithTitle:(NSString *)title command:(RACCommand *)command;
@end

