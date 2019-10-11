//
//  YCViewFrameManager.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCViewFrameManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic, assign) BOOL enable;


@end

NS_ASSUME_NONNULL_END
