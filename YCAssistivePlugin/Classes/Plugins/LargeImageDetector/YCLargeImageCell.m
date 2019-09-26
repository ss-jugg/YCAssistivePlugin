//
//  YCLargeImageCell.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import "YCLargeImageCell.h"
#import "UIColor+AssistiveColor.h"
#import "UIView+AssistiveUtils.h"
#import "YCLargeImageModel.h"
#import "YCAssistiveDefine.h"

@interface YCLargeImageCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *urlLbl;
@property (nonatomic, strong) UILabel *sizeLbl;
@property (nonatomic, strong) UIImageView *previewImgView;

@end

@implementation YCLargeImageCell

+ (CGFloat)largeImageCellHeight {
    
    return 188.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initial];
    }
    return self;
}

- (void)initial {
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_ScreenWidth, 187)];
    self.bgView.backgroundColor = [UIColor as_cellColor];
    [self.contentView addSubview:self.bgView];

    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, AS_ScreenWidth-20, 60)];
    [self.contentView addSubview:self.infoView];
    
    self.urlLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.infoView.as_width, 40)];
    self.urlLbl.font = [UIFont systemFontOfSize:13.0];
    self.urlLbl.textColor = [UIColor as_mainColor];
    self.urlLbl.textAlignment = NSTextAlignmentLeft;
    self.urlLbl.numberOfLines = 0;
    [self.infoView addSubview:self.urlLbl];
    
    self.sizeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.urlLbl.as_bottom, self.infoView.as_width, 20)];
    self.sizeLbl.font = [UIFont systemFontOfSize:13.0];
    self.sizeLbl.textColor = [UIColor as_mainColor];
    self.sizeLbl.textAlignment = NSTextAlignmentLeft;
    [self.infoView addSubview:self.sizeLbl];
    
    self.previewImgView = [[UIImageView alloc] initWithFrame:CGRectMake((AS_ScreenWidth-100)/2, 68, 100, 100)];
    self.previewImgView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue:0 alpha: 0.3];
    self.previewImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.previewImgView];
}

- (void)renderUIWithModel:(YCLargeImageModel *)model {
    
    self.urlLbl.text = [NSString stringWithFormat:@"图片地址:%@",model.url];
    self.sizeLbl.text = [NSString stringWithFormat:@"图片大小:%@",model.size];
    self.previewImgView.image = [UIImage imageWithData:model.imageData];
}

@end
