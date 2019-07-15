//
//  YCAssistiveHttpModel.h
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import <Foundation/Foundation.h>


@interface YCAssistiveHttpModel : NSObject

/* 记录唯一标识 */
@property (nonatomic, copy) NSString *httpIndentifier;
/* url地址 */
@property (nonatomic,copy)NSURL     *url;
/* 请求方式 */
@property (nonatomic,copy)NSString  *method;
/* <#mark#> */
@property (nonatomic, strong) NSDictionary *headerFields;
/* 请求体 */
@property (nonatomic,copy)NSData  *requestBody;
/* 状态码 */
@property (nonatomic,copy)NSString  *statusCode;
/* 响应数据 */
@property (nonatomic,copy)NSData    *responseData;
@property (nonatomic,copy)NSString  *mineType;
@property (nonatomic,copy)NSString  *startTime;
@property (nonatomic,copy)NSString  *totalDuration;
/* 已读标识，0-未读 1-已读 */
@property (nonatomic, assign) short readFlag;
@end

