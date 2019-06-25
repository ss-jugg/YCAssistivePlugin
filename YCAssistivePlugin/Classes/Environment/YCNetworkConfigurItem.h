//
//  YCNetworkConfigureItem.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YCNetworkConfigur;
@interface YCNetworkConfigurItem : NSObject

/* <#mark#> */
@property (nonatomic, copy) NSString *title;
/* id */
@property (nonatomic, copy) NSString *identifier;
/* 地址 */
@property (nonatomic, copy) NSString *address;
/* 描述 */
@property (nonatomic, copy, readonly) NSString *displayText;
/* 地址列表 */
@property (nonatomic, strong) NSArray<YCNetworkConfigur *> *configurs;


+ (instancetype)configurItemWithTitle:(NSString *)title identifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
