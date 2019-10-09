//
//  YCAssistiveUtil.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/9.
//

#import "YCAssistiveUtil.h"

@implementation YCAssistiveUtil

+ (NSUInteger)fetchFileSizeAtPath:(NSString *)filePath {
    
    NSUInteger fileSize = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fm fileExistsAtPath:filePath isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSArray *dirList = [fm contentsOfDirectoryAtPath:filePath error:nil];
            NSString *subPath = nil;
            for (NSString *path in dirList) {
                subPath = [filePath stringByAppendingPathComponent:path];
                fileSize += [self fetchFileSizeAtPath:subPath];
            }
        }else {
            NSDictionary *dict  = [fm attributesOfItemAtPath:filePath error:nil];
            NSInteger size = [dict[@"NSFileSize"] integerValue];
            return size;
        }
    }
    return fileSize;
}

// byte格式化为 B KB MB 方便流量查看
+ (NSString *)formatByte:(CGFloat)byte{
    double convertedValue = byte;
    int multiplyFactor = 0;
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f%@",convertedValue, [tokens objectAtIndex:multiplyFactor]]; ;
}

@end
