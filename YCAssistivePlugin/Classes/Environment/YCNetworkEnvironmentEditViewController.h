//
//  YCNetworkEnvironmentEditViewController.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import <UIKit/UIKit.h>
#import "YCAssistiveBaseViewController.h"
@class YCNetworkConfigur;
@interface YCNetworkEnvironmentEditViewController : YCAssistiveBaseViewController
- (instancetype)initWithIdentifier:(NSString *)identifier configurs:(NSArray<YCNetworkConfigur *> *)configurs;
@end

