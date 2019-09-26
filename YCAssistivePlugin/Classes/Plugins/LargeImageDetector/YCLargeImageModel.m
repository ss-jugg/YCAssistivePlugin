//
//  YCLargeImageModel.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import "YCLargeImageModel.h"

@implementation YCLargeImageModel

- (BOOL)isEqual:(YCLargeImageModel *)object {
    
    if (!object) {
        return NO;
    }
    return [self.url.absoluteString isEqual:object.url.absoluteString];
}
@end
