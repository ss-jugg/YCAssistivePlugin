//
//  YCNetworkConfigureItem.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import "YCNetworkConfigurItem.h"
#import "YCNetworkConfigur.h"
#import "YCNetworkConfigStorage.h"

@implementation YCNetworkConfigurItem

+ (instancetype)configurItemWithTitle:(NSString *)title identifier:(NSString *)identifier {
    
    YCNetworkConfigurItem *item = [[YCNetworkConfigurItem alloc] init];
    item.title = title;
    item.identifier = identifier;
    item.configurs = [[YCNetworkConfigStorage sharedInstance] configursForKey:identifier];
    return item;
}

- (YCNetworkConfigur *)currentConfigur {
    
    for (YCNetworkConfigur *configur in self.configurs) {
        if (configur.isSelected) {
            return configur;
        }
    }
    return nil;
}

- (NSString *)displayText {
    
    YCNetworkConfigur *configur = [self currentConfigur];
    if (configur.address.length > 0) {
        return [self.title stringByAppendingString:configur.address];
    }
    return self.title;
}
@end
