//
//  YCAssistiveHttpModel.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/6/27.
//

#import "YCAssistiveHttpModel.h"
#import "YCAssistiveURLUtil.h"

@implementation YCAssistiveHttpModel

+ (instancetype)httpModelWithResponseData:(NSData *)respnseData response:(NSHTTPURLResponse *)response request:(NSURLRequest *)request {
    
    YCAssistiveHttpModel *model = [[YCAssistiveHttpModel alloc] init];
    
    model.url = request.URL;
    model.method = request.HTTPMethod;
    model.headerFields = request.allHTTPHeaderFields;
    NSData *httpBody = [YCAssistiveURLUtil getHttpBodyFromRequest:request];
    model.requestBody = [YCAssistiveURLUtil convertJsonFromData:httpBody];
    model.isImage = [response.MIMEType hasPrefix:@"image/"];
    model.mineType = response.MIMEType;
    model.statusCode = [NSString stringWithFormat:@"%d",(int)response.statusCode];
    model.responseData = respnseData;
    model.uploadFlow = [NSString stringWithFormat:@"%zi",[YCAssistiveURLUtil getRequestLength:request]];
    model.downFlow = [NSString stringWithFormat:@"%zi",[YCAssistiveURLUtil getResponseLength:response data:respnseData]];
    if (model.isImage) {
        model.image = [UIImage imageWithData:respnseData];
    }
    return model;
}

@end
