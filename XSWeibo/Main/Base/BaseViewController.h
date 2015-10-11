//
//  BaseViewController.h
//  XSWeibo
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//自定义提示信息
- (void)tipViewShow:(BOOL)isshow;

//第三方框架提示信息
//显示
- (void)hudViewShow:(NSString *)title;
//隐藏
- (void)hudViewHidden;
//完成后提示
- (void)completionLoading:(NSString *)str;

@end
