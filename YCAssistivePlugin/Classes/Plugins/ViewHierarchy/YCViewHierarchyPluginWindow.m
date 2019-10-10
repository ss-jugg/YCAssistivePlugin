//
//  YCViewHierarchyPluginWindow.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCViewHierarchyPluginWindow.h"
#import "YCViewHierarchyViewController.h"

@implementation YCViewHierarchyPluginWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.rootViewController = [[YCViewHierarchyViewController alloc] init];
    }
    return self;
}

@end
