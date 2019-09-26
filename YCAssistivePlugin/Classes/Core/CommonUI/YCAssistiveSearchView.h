//
//  YCAssistiveSearchView.h
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AssistiveSearchBlock)(NSString *text);

@interface YCAssistiveSearchView : UIView

@property (nonatomic, copy) AssistiveSearchBlock searchBlock;

@end

NS_ASSUME_NONNULL_END
