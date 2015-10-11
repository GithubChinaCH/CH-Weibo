//
//  ThemesViewController.h
//  XSWeibo
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^nameBlock)(NSArray *arry,NSInteger index);

@interface ThemesViewController : UIViewController

@property (nonatomic, copy) nameBlock nameB;

@end
