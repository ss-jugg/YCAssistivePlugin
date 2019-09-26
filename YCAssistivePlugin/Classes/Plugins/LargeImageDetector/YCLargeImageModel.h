//
//  YCLargeImageModel.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCLargeImageModel : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSData *imageData;
@property (nonatomic, copy) NSString *size;

@end

NS_ASSUME_NONNULL_END
