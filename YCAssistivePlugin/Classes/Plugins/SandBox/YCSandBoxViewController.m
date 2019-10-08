//
//  YCSandBoxViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/8.
//

#import "YCSandBoxViewController.h"
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}


- (void)initialUI {
    
    [self as_setNavigationBarTitle:@"沙盒浏览器"];
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AS_ScreenWidth, <#CGFloat height#>)];
}



@end
