//
//  YCSandBoxViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/8.
//

#import "YCSandBoxViewController.h"
#import <Masonry/Masonry.h>
#import "YCSandBoxModel.h"
#import "YCAssistiveDefine.h"
#import "YCSandBoxCell.h"
#import "UIViewController+AssistiveUtil.h"
#import "YCSandBoxDetailViewController.h"

@interface YCSandBoxViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fileList;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, assign) BOOL isRoot;
@end

@implementation YCSandBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    [self fetchFilesByPath:self.filePath];
}

#pragma mark - 初始化
- (void)initialUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)fetchFilesByPath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (!filePath || [filePath isEqualToString:self.rootPath]) {
        filePath = self.rootPath;
        self.isRoot = YES;
        [self as_setNavigationBarTitle:@"沙盒浏览"];
        [self as_setLeftBarItemTitle:@"关闭"];
    }else {
        self.isRoot = NO;
        NSString *title = [fileManager displayNameAtPath:filePath];
        [self as_setNavigationBarTitle:title];
    }
    
    NSError *error = nil;
    NSArray *paths = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    for (NSString *path in paths) {
        BOOL isDir = NO;
        NSString *fullPath = [filePath stringByAppendingPathComponent:path];
        [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
        YCSandBoxModel *model = [[YCSandBoxModel alloc] init];
        if (isDir) {
            model.fileType = YCSandBoxFileTypeDirectory;
        }else {
            model.fileType = YCSandBoxFileTypeFile;
        }
        model.name = path;
        model.path = fullPath;
        [self.fileList addObject:model];
    }
    [self.tableView reloadData];
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController {
    if (self.isRoot) {
        [self pluginWindowDidClosed];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YCSandBoxCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCSandBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCSandBoxCell"];
    if (!cell) {
        cell = [[YCSandBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YCSandBoxCell"];
    }
    [cell renderUIWithModel:self.fileList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCSandBoxModel *model = self.fileList[indexPath.row];
    if (model.fileType == YCSandBoxFileTypeFile) {
        [self dealFileWithPath:model.path];
    }else {
        YCSandBoxViewController *vc = [[YCSandBoxViewController alloc] init];
        vc.filePath = model.path;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dealFileWithPath:(NSString *)path {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择预览方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    weak(self);
    UIAlertAction *previewAction = [UIAlertAction actionWithTitle:@"本地预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strong(self);
        [self localPreviewWithFilePath:path];
    }];
    [alertVC addAction:previewAction];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strong(self);
        [self shareFileWithPath:path];
    }];
    [alertVC addAction:shareAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)localPreviewWithFilePath:(NSString *)filePath {
    
    YCSandBoxDetailViewController *vc = [[YCSandBoxDetailViewController alloc] init];
    vc.filePath = filePath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareFileWithPath:(NSString *)filePath{
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSArray *objectsToShare = @[url];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - getter
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)fileList {
    
    if (!_fileList) {
        _fileList = [[NSMutableArray alloc] init];
    }
    return _fileList;
}

- (NSString *)rootPath {
    
    if (!_rootPath) {
        _rootPath = NSHomeDirectory();
    }
    return _rootPath;
}


@end
