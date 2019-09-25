//
//  YCNetworkConfigur.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCNetworkConfigur : NSObject<NSCoding>

/* 项目 */
@property (nonatomic, copy) NSString *app;
/* 地址 */
@property (nonatomic, copy) NSString *address;
/* 备注 */
@property (nonatomic, copy) NSString *remark;
/* 是否选中 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;

+ (instancetype)configurWithAddress:(NSString *)address remark:(NSString *)remark;
@end

@interface YCNetworkConfigur (Configur)

@property (nonatomic, copy, readonly) NSString *displayText;

- (BOOL)isEqual:(id)object;
- (BOOL)isValid;
@end

NS_ASSUME_NONNULL_END
