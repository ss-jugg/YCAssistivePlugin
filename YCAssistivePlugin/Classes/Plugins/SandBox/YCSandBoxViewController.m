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


- (void)fetchFiles:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
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
