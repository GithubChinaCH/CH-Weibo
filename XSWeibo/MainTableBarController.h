//
//  MainTableBarController.h
//  XSWeibo
//
//  Created by mac on 15/9/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hiddenBlock)(void);
@interface MainTableBarController : UITabBarController

@property (nonatomic, copy) hiddenBlock block;

@end
