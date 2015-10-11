//
//  UserView.m
//  XSWeibo
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "UserView.h"
#import "UIImageView+WebCache.h"
#import "AttentionVC.h"
#import "FansVC.h"
#import "BaseNavController.h"
#import "UIView+NavigationController.h"

@implementation UserView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self creatButton];
    }
    return self;
}

- (void)creatButton
{
    CGFloat width = (kScreenWidth - (5 * 15)) / 4;
    CGFloat y = 110;
    for (int index = 0; index < 4; index ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 + (width + 15) *index, y, width, width)];
        button.backgroundColor = [UIColor lightTextColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 100 + index;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (index) {
            case 0:
                [button setTitle:@"关注" forState:UIControlStateNormal];
                _attention = [[UILabel alloc] initWithFrame:CGRectMake(0, width - 20, width, 20)];
                _attention.textAlignment = NSTextAlignmentCenter;
                [button addSubview:_attention];
                break;
            case 1:
                [button setTitle:@"粉丝" forState:UIControlStateNormal];
                _fans = [[UILabel alloc] initWithFrame:CGRectMake(0, width - 20, width, 20)];
                _fans.textAlignment = NSTextAlignmentCenter;
                [button addSubview:_fans];
                break;
            case 2:
                [button setTitle:@"更多" forState:UIControlStateNormal];
                break;
            case 3:
                [button setTitle:@"资料" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [self addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 100) {
        AttentionVC *attention = [[AttentionVC alloc] init];
        BaseNavController *navi = [[BaseNavController alloc] initWithRootViewController:attention];
        [self.NavigationController presentViewController:navi animated:YES completion:nil];
    }
}

- (void)setModel:(UserModel *)model
{
    if (_model != model) {
        //设置头像
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.profile_image_url]];
        //设置名字
        self.Name.text = model.name;
        //设置地理位置
        NSString *gender = nil;
        if ([model.gender isEqualToString:@"m"]) {
            gender = @"男";
        }
        else
        {
            gender = @"女";
        }
        self.location.text = [NSString stringWithFormat:@"%@ %@",gender,model.location];
        
    }
}


@end
