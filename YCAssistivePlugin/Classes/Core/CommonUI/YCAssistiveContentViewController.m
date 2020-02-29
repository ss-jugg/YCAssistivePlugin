//
//  YCAssistiveContentViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/10.
//

#import "YCAssistiveContentViewController.h"
#import <Masonry/Masonry.h>
#import "UIImage+AssistiveBundle.h"
#import "UIFont+AssistiveFont.h"

@interface YCAssistiveContentViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YCAssistiveContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.imageView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    [self loadData];
    [self as_setNavigationBarTitle:@"详细内容"];
    if (self.content) {
        [self as_setRightBarItemImage:[UIImage as_imageWithName:@"icon_copy"]];
    }
}

//MARK:复制
- (void)as_viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    
    //使用剪切版实现复制功能
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.content;
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"复制成功！" preferredStyle:UIAlertControllerStyleAlert];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alerVC animated:YES completion:nil];
}

- (void)loadData {
    
    if (self.image) {
        self.imageView.hidden = NO;
        self.textView.hidden = YES;
        self.imageView.image = self.image;
        return;
    }
    self.imageView.hidden = YES;
    self.textView.hidden = NO;
    if (self.content.length == 0) {
        return;
    }
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont as_15],
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSParagraphStyleAttributeName : style};
    CGRect r = [self.content boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT) options:option attributes:attributes context:nil];
    self.textView.contentSize = CGSizeMake(self.view.bounds.size.width, r.size.height+60);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.content];
    [attr addAttributes:attributes range:NSMakeRange(0, self.content.length)];
    self.textView.attributedText = attr;
    attr = nil;
}

- (UITextView *)textView {
    
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.font = [UIFont as_15];
        _textView.textColor = [UIColor whiteColor];
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.hidden = YES;
    }
    return _imageView;
}

@end
