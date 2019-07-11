//
//  YCAssistiveContentViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/10.
//

#import "YCAssistiveContentViewController.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImage+AssistiveBundle.h"
#import "UIFont+AssistiveFont.h"
#import "YCAssistiveHttpPlugin.h"

@interface YCAssistiveContentViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation YCAssistiveContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadData];
    [self as_setNavigationBarTitle:@"详细内容"];
    [self as_setRightBarItemTitle:@"复制"];
}

//MARK:复制
- (void)as_viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    
    //使用剪切版实现复制功能
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.content;
}

- (void)loadData {
    
    //响应数据
    if (self.responseData) {
       self.content = [YCAssistiveHttpPlugin prettyJSONStringFromData:self.responseData];
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

@end
