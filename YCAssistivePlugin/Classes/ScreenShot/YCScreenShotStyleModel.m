//
//  YCScreenShotStyleModel.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import "YCScreenShotStyleModel.h"

@implementation YCScreenShotStyleModel

- (instancetype)init {
    
    if (self = [super init]) {
        _size = YCScreenShotStyleSmall;
        _color = YCScreenShotStyleRed;
    }
    return self;
}

- (instancetype)initWithSize:(YCScreenShotStyle)size color:(YCScreenShotStyle)color {
    
    if (self = [super init]) {
        
        if (size >= YCScreenShotStyleSmall && size <= YCScreenShotStyleBig) {
            _size = size;
        }
        if (color >= YCScreenShotStyleRed && color <= YCScreenShotStyleWhite) {
            _color = color;
        }
    }
    return self;
}

@end
