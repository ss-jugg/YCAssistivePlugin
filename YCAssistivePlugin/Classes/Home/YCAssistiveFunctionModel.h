//
//  YCAssistiveFunctionModel.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import <Foundation/Foundation.h>
#import "YCAssistivePluginProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveFunctionModel : NSObject

/* 图标 */
@property (nonatomic, copy) NSString *imageName;
/* 名 */
@property (nonatomic, copy) NSString *name;
/* 描述 */
@property (nonatomic, copy) NSString *des;

@property (nonatomic, strong) id<YCAssistivePluginProtocol> plugin;

+ (instancetype)functionModelWithName:(NSString *)name imageName:(NSString *)imageName des:(NSString *)des;

@end


@interface YCAssistiveFunctionViewModel : NSObject

/* 标题 */
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<YCAssistiveFunctionModel *> *functionModels;

+ (instancetype)viewModelWithTitle:(NSString *)title models:(NSArray<YCAssistiveFunctionModel *> *)models;

@end

NS_ASSUME_NONNULL_END
