//
//  YCScreenShotStyleModel.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import <Foundation/Foundation.h>
#import "YCScreenShotDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCScreenShotStyleModel : NSObject

/* <#备注#> */
@property (nonatomic, assign) YCScreenShotStyle size;
@property (nonatomic, assign) YCScreenShotStyle color;

- (instancetype)initWithSize:(YCScreenShotStyle)size color:(YCScreenShotStyle)color;
@end

NS_ASSUME_NONNULL_END
