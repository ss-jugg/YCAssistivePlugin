//
//  YCScreenShotPreviewViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/11.
//

#import "YCScreenShotPreviewViewController.h"
#import <Photos/PHPhotoLibrary.h>
#import "YCScreenShotToolBar.h"
#import "YCScreenShotImageView.h"
#import "UIView+AssistiveUtils.h"
#import "YCScreenShotHelper.h"
#import "YCAssistiveManager.h"

@interface YCScreenShotPreviewViewController ()<YCScreenShotToolBarDelegate>

@property (nonatomic, strong) YCScreenShotImageView *shotImageView;

@property (nonatomic, strong) YCScreenShotToolBar *toolBar;

@property (nonatomic, assign) CGRect oriImageFrame;
@end

@implementation YCScreenShotPreviewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[YCAssistiveManager sharedManager] makeAssistiveWindowAsKeyWindow];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[YCAssistiveManager sharedManager] revokeToOriginKeyWindow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
}

- (void)initializeUI {
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat rate = 0.1;
    CGFloat toolBarHeight = 80;
    CGFloat imgViewTop = rate * height - toolBarHeight / 2.0;
    
    self.shotImageView = [[YCScreenShotImageView alloc] initWithFrame:CGRectMake(rate * width, imgViewTop, 0.8 * width, 0.8 * height)];
    self.shotImageView.shotImage = self.shotImage;
    self.oriImageFrame = self.shotImageView.frame;
    [self.view addSubview:self.shotImageView];
    
    self.toolBar = [[YCScreenShotToolBar alloc] initWithFrame:CGRectMake(self.shotImageView.frame.origin.x, self.shotImageView.frame.origin.y+CGRectGetHeight(self.shotImageView.frame)+10, CGRectGetWidth(self.shotImageView.frame), toolBarHeight)];
    self.toolBar.delegate = self;
    [self.view addSubview:self.toolBar];
}


- (void)cancelAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmAction {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入图片名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入图片名称";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self doConfirmAction:alertVC.textFields.firstObject.text];
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:confirm];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)doConfirmAction:(NSString *)name {
    
    self.toolBar.hidden = YES;
    UIImage *image = [self.shotImageView as_convertViewToImage];
    if (image) {
        [[YCScreenShotHelper sharedInstance] saveScreenShot:image name:name complete:nil];
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
    }else {
        self.toolBar.hidden = NO;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)screenShotToolBar:(YCScreenShotToolBar *)bar didSeletAction:(YCScreenShotAction)action styleModel:(YCScreenShotStyleModel *)styleModel {
    
    if (action <= YCScreenShotActionText) {
        self.shotImageView.currentAction = action;
        self.shotImageView.styleModel = styleModel;
    } else if (action == YCScreenShotActionRevoke) {
        [self.shotImageView removeLastOperation];
    } else if (action == YCScreenShotActionCancel) {
        [self cancelAction];
    } else if (action == YCScreenShotActionConfirm) {
        [self confirmAction];
    }
}

@end
