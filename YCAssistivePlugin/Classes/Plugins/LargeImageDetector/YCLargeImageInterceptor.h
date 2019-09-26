//
//  YCLargeImageInterceptor.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import <Foundation/Foundation.h>
#import "YCLargeImageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCLargeImageInterceptor : NSObject

/* 检测到的图片 */
@property (nonatomic, strong) NSMutableArray *images;
/* 最小检测大小,默认500KB */
@property (nonatomic, assign) NSInteger minimumSize;
@property (nonatomic, assign) BOOL canIntercept;

+ (instancetype)shareInterceptor;

- (void)addImageModel:(YCLargeImageModel *)imageModel;
- (void)removeAllImages;
@end

NS_ASSUME_NONNULL_END
