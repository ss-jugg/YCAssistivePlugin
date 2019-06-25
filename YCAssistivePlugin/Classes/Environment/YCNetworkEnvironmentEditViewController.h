//
//  YCNetworkEnvironmentEditViewController.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/25.
//

#import <UIKit/UIKit.h>

@class YCNetworkConfigur;
@interface YCNetworkEnvironmentEditViewController : UIViewController
- (instancetype)initWithIdentifier:(NSString *)identifier configurs:(NSArray<YCNetworkConfigur *> *)configurs selectedHandler:(void (^)(NSArray <YCNetworkConfigur *> *))selectedHandler;
@end

