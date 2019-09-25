//
//  YCScreenShotStyleView.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import "YCScreenShotStyleView.h"
#import "YCScreenShotStyleModel.h"
#import "UIImage+AssistiveBundle.h"

static NSInteger kYCStyleViewTag = 1000;

@interface YCScreenShotStyleView ()


@property (nonatomic, strong) UIButton *lastSizeButton;

@property (nonatomic, strong) UIButton *lastColorButton;

@property (nonatomic, strong) YCScreenShotStyleModel *styleModel;

@end

@implementation YCScreenShotStyleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.layer.cornerRadius = 5.0;
    self.styleModel = [[YCScreenShotStyleModel alloc] init];
    
    NSInteger count = 9;
    CGFloat marigin = 10;
    CGFloat itemWidth = 16;
    CGFloat itemHeight = 16;
    CGFloat itemMarigin = (self.frame.size.width - marigin * 2 - itemWidth * count) / (count - 1);
    CGFloat top = (self.frame.size.height - itemHeight) / 2.0;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [self buttonWithFrame:CGRectMake(marigin + i * (itemWidth + itemMarigin), top, itemWidth, itemHeight)];
        NSString *imageName = @"";
        NSString *selectImageName = @"";
        switch (i) {
            case YCScreenShotStyleSmall:{
                imageName = @"icon_dot_small";
                selectImageName = @"icon_dot_small_select";
                button.selected = YES;
                self.lastSizeButton = button;
            }
                break;
            case YCScreenShotStyleMedium:{
                imageName = @"icon_dot_medium";
                selectImageName = @"icon_dot_medium_select";
            }
                break;
            case YCScreenShotStyleBig:{
                imageName = @"icon_dot_big";
                selectImageName = @"icon_dot_big_select";
            }
                break;
            case YCScreenShotStyleRed:{
                imageName = @"icon_color_red";
                selectImageName = @"icon_color_red";
                button.selected = YES;
                button.layer.borderWidth = 2;
                self.lastColorButton = button;
            }
                break;
            case YCScreenShotStyleBlue:{
                imageName = @"icon_color_blue";
                selectImageName = @"icon_color_blue";
            }
                break;
            case YCScreenShotStyleGreen:{
                imageName = @"icon_color_green";
                selectImageName = @"icon_color_green";
            }
                break;
            case YCScreenShotStyleYellow:{
                imageName = @"icon_color_yellow";
                selectImageName = @"icon_color_yellow";
            }
                break;
            case YCScreenShotStyleGray:{
                imageName = @"icon_color_gray";
                selectImageName = @"icon_color_gray";
            }
                break;
            case YCScreenShotStyleWhite:{
                imageName = @"icon_color_white";
                selectImageName = @"icon_color_white";
            }
                break;
            default:
                break;
        }
        [button setImage:[UIImage as_imageWithName:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage as_imageWithName:selectImageName] forState:UIControlStateSelected];
        button.tag = kYCStyleViewTag+i;
        button.showsTouchWhenHighlighted = NO;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (UIButton *)buttonWithFrame:(CGRect)frame {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.frame = frame;
    return button;
}

- (void)onButtonClick:(UIButton *)button {
    
    if (button.tag-kYCStyleViewTag <= YCScreenShotStyleBig) {
        // Size button
        if (self.lastSizeButton != button) {
            self.lastSizeButton.selected = NO;
            button.selected = YES;
            self.lastSizeButton = button;
            self.styleModel.size = button.tag-kYCStyleViewTag;
        }
    } else {
        // Color button
        if (self.lastColorButton != button) {
            self.lastColorButton.selected = NO;
            self.lastColorButton.layer.borderWidth = 0;
            button.selected = YES;
            button.layer.borderWidth = 2;
            self.lastColorButton = button;
            self.styleModel.color = button.tag-kYCStyleViewTag;
        }
    }
}

- (YCScreenShotStyleModel *)currentStyleModel {
    
    return self.styleModel;
}

- (void)resetStyleView {
    
    UIButton *sizeButton = [self viewWithTag:kYCStyleViewTag+YCScreenShotStyleSmall];
    [self onButtonClick:sizeButton];
    
    UIButton *colorButton = [self viewWithTag:kYCStyleViewTag+YCScreenShotStyleRed];
    [self onButtonClick:colorButton];
}


@end
