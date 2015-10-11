//
//  UserView.h
//  XSWeibo
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *location;

@property (nonatomic, strong) UILabel *attention;
@property (nonatomic, strong) UILabel *fans;
@property (nonatomic, strong) UserModel *model;

@end
