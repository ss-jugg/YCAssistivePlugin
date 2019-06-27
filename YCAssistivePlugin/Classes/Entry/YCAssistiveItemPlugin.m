//
//  YCAssistiveItemPlugin.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/26.
//

#import "YCAssistiveItemPlugin.h"

NSMutableArray<Class<YCAssistiveItemPluginProtocol>> const *kYCAssistivePlugins = nil;

@implementation YCAssistiveItemPlugin

- (instancetype)init {
    
    if (self = [super init]) {
        //MARK:子插件必须要实现YCAssistiveItemPluginProtocol协议
        if (![self conformsToProtocol:@protocol(YCAssistiveItemPluginProtocol)]) {
            [NSException raise:@"YCAssistiveItemPluginProtocolException" format:@"Class does not conform YCAssistiveItemPluginProtocol protocol."];
        }
    }
    return self;
}

+ (void)registerPlugin {
    
    if ([self conformsToProtocol:@protocol(YCAssistiveItemPluginProtocol)]) {
        Class<YCAssistiveItemPluginProtocol> class = self;
        if (!kYCAssistivePlugins) {
            kYCAssistivePlugins = [NSMutableArray array];
        }
        [kYCAssistivePlugins addObject:class];
        [kYCAssistivePlugins sortUsingComparator:^NSComparisonResult(Class<YCAssistiveItemPluginProtocol> _Nonnull obj1, Class<YCAssistiveItemPluginProtocol>  _Nonnull obj2) {
            return [obj1 sortNumber] > [obj2 sortNumber] ? NSOrderedDescending : NSOrderedAscending;
        }];
    }
}
@end
