//
//  YCAssistiveNetworkManager.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/25.
//

#import <Foundation/Foundation.h>
#import "YCAssistiveHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveNetworkManager : NSObject

@property (nonatomic, assign) BOOL canIntercept;
/* 数据模型组 */
@property (nonatomic, strong, readonly) NSMutableArray<YCAssistiveHttpModel *> *httpModels;

+ (instancetype)shareManager;

- (void)clearAll;

@end

NS_ASSUME_NONNULL_END
