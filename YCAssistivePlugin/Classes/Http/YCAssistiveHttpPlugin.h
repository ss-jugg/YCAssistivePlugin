//
//  YCAssistiveHttpHelper.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import <Foundation/Foundation.h>

extern NSString *const kAssistiveHttpNotificationName;

@class YCAssistiveHttpModel;
@interface YCAssistiveHttpPlugin : NSObject

+ (instancetype)sharedInstance;

/* 需要抓取的url, 不设置默认抓取全部 */
@property (nonatomic, strong) NSArray *debugHosts;

/* 数据模型组 */
@property (nonatomic, strong, readonly) NSMutableArray<YCAssistiveHttpModel *> *httpModels;

- (void)addHttpModel:(YCAssistiveHttpModel *)model;

- (void)clearAll;

+ (NSString *)prettyJSONStringFromData:(NSData *)data;

@end


