//
//  YCScreenShotDefine.h
//  Pods
//
//  Created by shenweihang on 2019/9/10.
//

#ifndef YCScreenShotDefine_h
#define YCScreenShotDefine_h

typedef NS_ENUM(NSUInteger, YCScreenShotAction) {
    YCScreenShotActionNone      = 0,    //无
    YCScreenShotActionRect      = 1,    //框
    YCScreenShotActionRound     = 2,    //圈
    YCScreenShotActionLine      = 3,    //线
    YCScreenShotActionDraw      = 4,    //画
    YCScreenShotActionText      = 5,    //文本
    YCScreenShotActionRevoke    = 6,    //撤销
    YCScreenShotActionCancel    = 7,    //取消
    YCScreenShotActionConfirm   = 8     //确认
};

typedef NS_ENUM(NSUInteger, YCScreenShotStyle) {
    YCScreenShotStyleSmall = 0,
    YCScreenShotStyleMedium,
    YCScreenShotStyleBig,
    YCScreenShotStyleRed,       //ff3b30
    YCScreenShotStyleBlue,      //108efff
    YCScreenShotStyleGreen,     //59b50a
    YCScreenShotStyleYellow,    //f4a500
    YCScreenShotStyleGray,      //333333
    YCScreenShotStyleWhite      //ffffff
};


#endif /* YCScreenShotDefine_h */
