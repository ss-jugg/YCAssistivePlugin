//
//  YCAssistiveBaseViewController.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/10.
//

#import "YCAssistiveBaseViewController.h"
#import "UIColor+AssistiveColor.h"

@interface YCAssistiveBaseViewController ()

@end

@implementation YCAssistiveBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationDelegate = self;
    self.view.backgroundColor = [UIColor as_backgroudColor];
}
@end
