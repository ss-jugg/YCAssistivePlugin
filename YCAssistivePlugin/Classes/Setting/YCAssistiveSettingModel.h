//
//  YCAssistiveSettingModel.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCAssistiveSettingModel : NSObject<NSCoding>

/* <#mark#> */
@property (nonatomic, copy) NSString *title;
/* <#mark#> */
@property (nonatomic, copy) NSString *detail;
/* <#mark#> */
@property (nonatomic, assign) BOOL isOn;

+ (instancetype)settingModelWithTitle:(NSString *)title detail:(NSString *)detail;
@end

NS_ASSUME_NONNULL_END
