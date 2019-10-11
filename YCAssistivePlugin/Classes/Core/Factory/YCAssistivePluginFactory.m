//
//  YCAssistivePluginFactory.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/11.
//

#import "YCAssistivePluginFactory.h"
#import "YCNetworkEnvironmentPlugin.h"
#import "YCURLPlugin.h"
#import "YCAppInfoPlugin.h"
#import "YCCrashPlugin.h"
#import "YCLoggerPlugin.h"
#import "YCMemoryLeaksPlugin.h"
#import "YCAssistiveFPSPlugin.h"
#import "YCAssistiveCPUPlugin.h"
#import "YCAssistiveMemoryPlugin.h"
#import "YCColorSnapPlugin.h"
#import "YCLargeImagePlugin.h"
#import "YCSandBoxPlugin.h"
#import "YCAssistiveDebuggerPlugin.h"
#import "YCViewHierarchyPlugin.h"
#import "YCScreenShotPlugin.h"
#import "YCAssistiveSettingPlugin.h"

@implementation YCAssistivePluginFactory

+ (NSMutableArray<YCAssistiveFunctionViewModel *> *)homeFunctions {
    
    NSMutableArray *funtions = [[NSMutableArray alloc] init];
    [funtions addObject:[self commonlyUsedFunctions]];
    [funtions addObject:[self performanceDetectionFunctions]];
    [funtions addObject:[self visualSenseFunctions]];
    return funtions;
}

+ (NSArray<YCAssistivePluginItem *> *)pluginItems {
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    //截图
    YCAssistivePluginItem *screenshotItem = [YCAssistivePluginItem pluginItemWithImageName:@"icon_button_screenshot"];
    screenshotItem.plugin = [[YCScreenShotPlugin alloc] init];
    [items addObject:screenshotItem];
    
    //环境切换
    YCAssistivePluginItem *switcherItem = [YCAssistivePluginItem pluginItemWithImageName:@"icon_button_switcher"];
    switcherItem.plugin = [[YCNetworkEnvironmentPlugin alloc] init];
    [items addObject:switcherItem];
    
    //网络
    YCAssistivePluginItem *networkItem = [YCAssistivePluginItem pluginItemWithImageName:@"icon_button_network"];
    networkItem.plugin = [[YCURLPlugin alloc] init];
    [items addObject:networkItem];
    
    //定位当前视图VC
    YCAssistivePluginItem *findVCItem = [YCAssistivePluginItem pluginItemWithImageName:@"icon_button_findVC"];
    findVCItem.plugin = [[YCAssistiveDebuggerPlugin alloc] init];
    [items addObject:findVCItem];
    
    //设置
    YCAssistivePluginItem *settingItem = [YCAssistivePluginItem pluginItemWithImageName:@"icon_button_setting"];
    settingItem.plugin = [[YCAssistiveSettingPlugin alloc] init];
    [items addObject:settingItem];
    return items.copy;
}

+ (YCAssistiveFunctionViewModel *)commonlyUsedFunctions {
    
    YCAssistiveFunctionModel *switcher = [YCAssistiveFunctionModel functionModelWithName:@"环境切换" imageName:@"icon_home_switcher" des:@"App内环境地址切换"];
    switcher.plugin = [[YCNetworkEnvironmentPlugin alloc] init];
    
    YCAssistiveFunctionModel *http = [YCAssistiveFunctionModel functionModelWithName:@"网络监测" imageName:@"icon_home_http" des:@"监测网络请求"];
    http.plugin = [[YCURLPlugin alloc] init];
    
    YCAssistiveFunctionModel *logger = [YCAssistiveFunctionModel functionModelWithName:@"用户日志" imageName:@"icon_home_logger" des:@"调试日志记录"];
    logger.plugin = [[YCLoggerPlugin alloc] init];
    
    YCAssistiveFunctionModel *crash = [YCAssistiveFunctionModel functionModelWithName:@"崩溃记录" imageName:@"icon_home_crash" des:@"崩溃日志记录"];
    crash.plugin = [[YCCrashPlugin alloc] init];
    
    YCAssistiveFunctionModel *appInfo = [YCAssistiveFunctionModel functionModelWithName:@"app信息" imageName:@"icon_home_appinfo" des:@""];
    appInfo.plugin = [[YCAppInfoPlugin alloc] init];
    
    YCAssistiveFunctionModel *sandBox = [YCAssistiveFunctionModel functionModelWithName:@"沙盒浏览" imageName:@"icon_home_sandbox" des:@""];
    sandBox.plugin = [[YCSandBoxPlugin alloc] init];
    
    YCAssistiveFunctionViewModel *viewModel = [YCAssistiveFunctionViewModel viewModelWithTitle:@"常用功能" models:@[switcher,http,logger,crash,appInfo,sandBox]];
    return viewModel;
}

+ (YCAssistiveFunctionViewModel *)performanceDetectionFunctions {
    
    YCAssistiveFunctionModel *performance = [YCAssistiveFunctionModel functionModelWithName:@"帧率检测" imageName:@"icon_home_ framerate" des:@""];
    performance.plugin = [[YCAssistiveFPSPlugin alloc] init];
    
    YCAssistiveFunctionModel *cpu = [YCAssistiveFunctionModel functionModelWithName:@"cpu检测" imageName:@"icon_home_cpu" des:@""];
    cpu.plugin = [[YCAssistiveCPUPlugin alloc] init];
    
    YCAssistiveFunctionModel *memory = [YCAssistiveFunctionModel functionModelWithName:@"内存检测" imageName:@"icon_home_memory" des:@""];
    memory.plugin = [[YCAssistiveMemoryPlugin alloc] init];
    
    YCAssistiveFunctionModel *leak = [YCAssistiveFunctionModel functionModelWithName:@"泄漏检测" imageName:@"icon_home_leak" des:@""];
    leak.plugin = [[YCMemoryLeaksPlugin alloc] init];
    
    YCAssistiveFunctionModel *datu = [YCAssistiveFunctionModel functionModelWithName:@"大图检测" imageName:@"icon_home_datu" des:@""];
    datu.plugin = [[YCLargeImagePlugin alloc] init];
    
    YCAssistiveFunctionViewModel *viewModel = [YCAssistiveFunctionViewModel viewModelWithTitle:@"性能检测" models:@[performance,cpu,memory,leak,datu]];
    return viewModel;
}

+ (YCAssistiveFunctionViewModel *)visualSenseFunctions {
    
    YCAssistiveFunctionModel *color = [YCAssistiveFunctionModel functionModelWithName:@"拾色器" imageName:@"icon_home_colorsucker" des:@""];
    color.plugin = [[YCColorSnapPlugin alloc] init];
    
    YCAssistiveFunctionModel *hierarchy = [YCAssistiveFunctionModel functionModelWithName:@"视图层级" imageName:@"icon_home_hierarchy" des:@""];
    hierarchy.plugin = [[YCViewHierarchyPlugin alloc] init];
    
    YCAssistiveFunctionModel *locationView = [YCAssistiveFunctionModel functionModelWithName:@"视图定位" imageName:@"icon_home_findVC" des:@""];
    locationView.plugin = [[YCAssistiveDebuggerPlugin alloc] init];
    
    YCAssistiveFunctionViewModel *viewModel = [YCAssistiveFunctionViewModel viewModelWithTitle:@"视图工具" models:@[color,hierarchy,locationView]];
    return viewModel;
}


@end
