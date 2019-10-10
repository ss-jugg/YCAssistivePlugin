//
//  YCSandBoxDetailViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/9.
//

#import "YCSandBoxDetailViewController.h"
#import <Masonry/Masonry.h>
#import <QuickLook/QuickLook.h>
#import "UIColor+AssistiveColor.h"

@interface YCSandBoxDetailViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation YCSandBoxDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self as_setNavigationBarTitle:@"文件预览"];
    [self initUI];
    [self previewFile];
}

- (void)initUI {
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)previewFile {
    
    if ([self.filePath hasSuffix:@".strings"] || [self.filePath hasSuffix:@".plist"]) {
        
        NSString *content = [[NSMutableArray arrayWithContentsOfFile:self.filePath] description];
        if (content) {
            self.textView.text = content;
            return;
        }
        self.textView.text = [[NSDictionary dictionaryWithContentsOfFile:self.filePath] description];
        
    }else if ([self.filePath hasSuffix:@".db"] || [self.filePath hasSuffix:@".DB"]) {
        //数据库文件预览
    }
    else {
        
        //其他文件使用QLPreviewController打开
        QLPreviewController *previewVC = [[QLPreviewController alloc] init];
        previewVC.dataSource = self;
        previewVC.delegate = self;
        [self presentViewController:previewVC animated:YES completion:nil];
    }
}

#pragma mark - QLPreviewController
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    
    return [NSURL fileURLWithPath:self.filePath];
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextView *)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:13.0f];
        _textView.textColor = [UIColor whiteColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = NO;
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;
        _textView.scrollEnabled = YES;
        _textView.backgroundColor = [UIColor as_cellColor];
        _textView.layer.borderColor = [UIColor as_cellColor].CGColor;
        _textView.layer.borderWidth = 2.0f;
    }
    return _textView;
}

@end
