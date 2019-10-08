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

@interface YCSandBoxViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YCSandBoxModel *currentModel;
@property (nonatomic, strong) NSMutableArray *fileList;
@property (nonatomic, copy) NSString *rootPath;

@end

@implementation YCSandBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialData];
    [self initialUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

#pragma mark - 初始化
- (void)initialUI {
    
    [self as_setNavigationBarTitle:@"沙盒浏览器"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initialData {
    
    self.fileList = [[NSMutableArray alloc] init];
    self.rootPath = NSHomeDirectory();
}


- (void)fetchFilesByPath:(NSString *)filePath {
    
    YCSandBoxModel *sandBoxModel = [[YCSandBoxModel alloc] init];
    if (!filePath || [filePath isEqualToString:self.rootPath]) {
        filePath = self.rootPath;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
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


@end
