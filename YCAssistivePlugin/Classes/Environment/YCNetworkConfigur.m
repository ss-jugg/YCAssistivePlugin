//
//  YCNetworkConfigur.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import "YCNetworkConfigur.h"
#import <YYModel/YYModel.h>

@implementation YCNetworkConfigur

+ (instancetype)configurWithAddress:(NSString *)address remark:(NSString *)remark {
    YCNetworkConfigur *configur = [[YCNetworkConfigur alloc] init];
    configur.address = address;
    configur.remark = remark;
    return configur;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

- (id)copy {
    return [self yy_modelCopy];
}

@end


@implementation YCNetworkConfigur (Configur)

- (BOOL)isEqual:(YCNetworkConfigur *)object {
    
    return [self.address isEqualToString:object.address];
}

- (BOOL)isValid {
    
    return self.address.length > 0;
}

- (NSString *)displayText {
    
    if (self.address.length > 0) {
        return [NSString stringWithFormat:@"%@\n%@",self.address,(self.remark?:@"")];
    }
    return self.address;
}

@end
