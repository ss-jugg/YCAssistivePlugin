//
//  YCAssistiveNetworkFlowDataView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/25.
//

#import "YCAssistiveNetworkFlowDataView.h"
#import "UIFont+AssistiveFont.h"
#import "UIColor+AssistiveColor.h"
#import "UIView+AssistiveUtils.h"
#import "YCAssistiveNetworkManager.h"
#import "YCAssistiveURLUtil.h"

@interface YCAssistiveNetworkDataView : UIView

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *valueLbl;

- (void)renderUIWithTitle:(NSString *)title value:(NSString *)value;
@end


@implementation YCAssistiveNetworkDataView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initial];
    }
    return self;
}

- (void)initial {
    
    self.valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.as_width, 22)];
    self.valueLbl.font = [UIFont systemFontOfSize:15.0];
    self.valueLbl.textColor = [UIColor whiteColor];
    self.valueLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.valueLbl];
    
    self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.valueLbl.as_bottom, self.as_width, 12)];
    self.titleLbl.font = [UIFont systemFontOfSize:10.0];
    self.titleLbl.textColor = [UIColor whiteColor];
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLbl];
}

- (void)renderUIWithTitle:(NSString *)title value:(NSString *)value {
    
    self.titleLbl.text = title;
    self.valueLbl.text = value;
}

@end

@interface YCAssistiveNetworkFlowDataView ()

/* 抓包时间 */
@property (nonatomic, strong) YCAssistiveNetworkDataView *totalView;
/* 抓包数量 */
@property (nonatomic, strong) YCAssistiveNetworkDataView *numView;
/* 上传流量 */
@property (nonatomic, strong) YCAssistiveNetworkDataView *uploadView;
/* 下载流量 */
@property (nonatomic, strong) YCAssistiveNetworkDataView *downloadView;

@end

@implementation YCAssistiveNetworkFlowDataView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    self.layer.cornerRadius = 4.0;
    self.backgroundColor = [UIColor as_cellColor];
    
    __block CGFloat totalUploadByte = 0;
    __block CGFloat totalDownloadByte = 0;
    [[YCAssistiveNetworkManager shareManager].httpModels enumerateObjectsUsingBlock:^(YCAssistiveHttpModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalUploadByte += obj.uploadFlow.floatValue;
        totalDownloadByte += obj.downFlow.floatValue;
    }];
    NSString *upload = [YCAssistiveURLUtil formatByte:totalUploadByte];
    NSString *download = [YCAssistiveURLUtil formatByte:totalDownloadByte];
    
    CGFloat width = self.as_width / 3.0;
    CGFloat offsetY = 20 + 40 + 20;
    
    self.totalView = [[YCAssistiveNetworkDataView alloc] initWithFrame:CGRectMake(0, 20, self.as_width, 40)];
    [self.totalView renderUIWithTitle:@"总计抓包" value:[YCAssistiveURLUtil formatByte:(totalUploadByte+totalDownloadByte)]];
    [self addSubview:self.totalView];
    
    NSInteger count = [YCAssistiveNetworkManager shareManager].httpModels.count;
    NSString *num = [NSString stringWithFormat:@"%zi",count];
    
    self.numView = [[YCAssistiveNetworkDataView alloc] initWithFrame:CGRectMake(0, offsetY, width, 40)];
    [self.numView renderUIWithTitle:@"抓包数量" value:num];
    [self addSubview:self.numView];
    
    self.uploadView = [[YCAssistiveNetworkDataView alloc] initWithFrame:CGRectMake(self.numView.as_right, offsetY, width, 40)];
    [self.uploadView renderUIWithTitle:@"上传流量" value:upload];
    [self addSubview:self.uploadView];
    
    self.downloadView = [[YCAssistiveNetworkDataView alloc] initWithFrame:CGRectMake(self.uploadView.as_right, offsetY, width, 40)];
    [self.downloadView renderUIWithTitle:@"下载流量" value:download];
    [self addSubview:self.downloadView];
}

@end
