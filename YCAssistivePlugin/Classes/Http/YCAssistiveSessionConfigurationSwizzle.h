//
//  YCAssistiveSessionConfigurationSwizzle.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import <Foundation/Foundation.h>


@interface YCAssistiveSessionConfigurationSwizzle : NSObject

+ (instancetype)sharedInstance;

/* 是否已经交换NSURLSessionConfiguration 中 protocolClasses的get方法实现 */
@property (nonatomic, assign, getter=isSwizzling) BOOL swizzling;

//MARK:hook NSURLSessionConfiguration中protocolClasses的get方法
- (void)sw_protocolClasses;

- (void)unsw_protocolClasses;

@end

