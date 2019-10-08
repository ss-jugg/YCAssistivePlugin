//
//  YCSandBoxModel.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YCSandBoxFileType) {
    YCSandBoxFileTypeDirectory,     //文件夹
    YCSandBoxFileTypeFile           //文件
};

@interface YCSandBoxModel : NSObject

/* 文件名 */
@property (nonatomic, copy) NSString *name;
/* 路径 */
@property (nonatomic, copy) NSString *path;
/* 文件类型 */
@property (nonatomic, assign) YCSandBoxFileType fileType;

@end

NS_ASSUME_NONNULL_END
