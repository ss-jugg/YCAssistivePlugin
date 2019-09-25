//
//  YCScreenShotToolBar.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/10.
//

#import <UIKit/UIKit.h>
#import "YCScreenShotDefine.h"
#import "YCScreenShotStyleModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YCScreenShotToolBar;
@protocol YCScreenShotToolBarDelegate <NSObject>


- (void)screenShotToolBar:(YCScreenShotToolBar *)bar didSeletAction:(YCScreenShotAction)action styleModel:(YCScreenShotStyleModel *)styleModel;


@end

@interface YCScreenShotToolBar : UIView

@property (nonatomic, weak) id<YCScreenShotToolBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
