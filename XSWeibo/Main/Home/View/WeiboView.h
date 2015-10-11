//
//  WeiboView.h
//  XSWeibo
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "WXLabel.h"
#import "ThemeManager.h"
#import "WeiboViewLayoutFrame.h"
#import "ZoomView.h"

@interface WeiboView : UIView<WXLabelDelegate>

@property (nonatomic, strong) WXLabel *textLabel; //微博文字
@property (nonatomic, strong) WXLabel *sourceTextLabel; //原微博文字
@property (nonatomic, strong) ZoomView *weiboImage; //微博图片
@property (nonatomic, strong) ThemeImageView *bgImageView; //背景图片
@property (nonatomic, strong) WeiboViewLayoutFrame *layoutFrame; //布局对象

@end
