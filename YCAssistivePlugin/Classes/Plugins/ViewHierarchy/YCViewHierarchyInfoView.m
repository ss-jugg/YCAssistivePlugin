//
//  YCViewHierarchyInfoView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCViewHierarchyInfoView.h"
#import "UIView+AssistiveUtils.h"
#import "UIColor+AssistiveColor.h"

@interface YCViewHierarchyInfoView ()
@property (nonatomic, strong) UILabel *infoLbl;
@end

@implementation YCViewHierarchyInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.as_width-60, self.as_height)];
        self.infoLbl.textColor = [UIColor as_mainColor];
        self.infoLbl.font = [UIFont systemFontOfSize:12.0];
        self.infoLbl.numberOfLines = 0;
        [self addSubview:self.infoLbl];
    }
    return self;
}

- (void)viewDidClose {
    [self.delegate closeHierarchyInfoView:self];
}

- (void)updateViewInfo:(UIView *)view {
    
    self.infoLbl.attributedText = [self viewInfo:view];
}

-(NSMutableAttributedString *)viewInfo:(UIView *)view{
    if (view) {
        NSMutableString *showString = [[NSMutableString alloc] init];
        NSString *tempString = [NSString stringWithFormat:@"%@:%@",@"控件名称",NSStringFromClass([view class])];
        [showString appendString:tempString];
        
        tempString = [NSString stringWithFormat:@"\n控件位置：左%0.1lf  上%0.1lf  宽%0.1lf  高%0.1lf",view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height];
        [showString appendString:tempString];
        
        if([view isKindOfClass:[UILabel class]]){
            UILabel *vLabel = (UILabel *)view;
            tempString = [NSString stringWithFormat:@"\n背景颜色：%@  字体颜色：%@  字体大小：%.f",[self hexFromUIColor:vLabel.backgroundColor],[self hexFromUIColor:vLabel.textColor],vLabel.font.pointSize];
            [showString appendString:tempString];
        }else if ([view isMemberOfClass:[UIView class]]) {
            tempString = [NSString stringWithFormat:@"\n背景颜色：%@",[self hexFromUIColor:view.backgroundColor]];
            [showString appendString:tempString];
        }
        
        NSString *string = [NSString stringWithFormat:@"%@",showString];
        // 行间距
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 6;
        
        
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        [attrString addAttributes:@{
                                    NSParagraphStyleAttributeName : style,
                                    NSFontAttributeName : [UIFont systemFontOfSize: 12],
                                    NSForegroundColorAttributeName : [UIColor as_mainColor]
                                    }
                            range:NSMakeRange(0, string.length)];
        return attrString;
    }
    return nil;
}

- (NSString *)hexFromUIColor: (UIColor*) color {
    if (!color) {
        return @"nil";
    }
    if(color == [UIColor clearColor]){
        return @"clear";
    }
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        //return [NSString stringWithFormat:@"#FFFFFF"];
        return @"单色色彩空间模式";
    }
    
    int alpha = (int)((CGColorGetComponents(color.CGColor))[3]*255.0);
    NSString *hex = [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
                     (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
                     (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
    if (alpha < 255) {//存在透明度
        hex = [NSString stringWithFormat:@"%@ alpha:%.2f",hex,(CGColorGetComponents(color.CGColor))[3]];
    }
    
    
    return hex;
}

@end
