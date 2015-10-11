//
//  MainTableBarController.m
//  XSWeibo
//
//  Created by mac on 15/9/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MainTableBarController.h"
//#import "Common.h"
#import "BaseNavController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "AppDelegate.h"
#import "ThemeLabel.h"

@interface MainTableBarController ()<SinaWeiboRequestDelegate>
{
    ThemeImageView *_selectImageView; //选中图片
    ThemeImageView *_unReadImageV;
    ThemeLabel *_unReadLabel;
}

@end

@implementation MainTableBarController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self _creatSubController];
    [self _creatTabar];
    
    
    //设置定时器 来监听未读微博数目
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
    __weak MainTableBarController *this = self;
    self.block=^{
        __strong MainTableBarController *strongSelf = this;
        strongSelf -> _unReadImageV.hidden = YES;
    };
}

- (void)timeAction
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    if ([appdelegate.weib isLoggedIn]) {
        
        [appdelegate.weib requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //获取未读微博条数
    NSNumber *num = result[@"status"];
    NSInteger count = [num integerValue];
    
    if (count > 0) {
        CGFloat itemWidth = kScreenWidth / 5;
        CGFloat unReadWidth = itemWidth / 2;
        if (_unReadImageV == nil) {
            _unReadImageV = [[ThemeImageView alloc] initWithFrame:CGRectMake(itemWidth - unReadWidth, 0, unReadWidth, unReadWidth)];
            _unReadImageV.imageViewName = @"number_notify_9.png";
            [self.tabBar addSubview:_unReadImageV];
            
            _unReadLabel = [[ThemeLabel alloc] initWithFrame:_unReadImageV.bounds];
            _unReadLabel.backgroundColor = [UIColor clearColor];
            _unReadLabel.textAlignment = NSTextAlignmentCenter;
            _unReadLabel.colorName = @"Timeline_Notice_color";
            _unReadLabel.font = [UIFont systemFontOfSize:13];
            [_unReadImageV addSubview:_unReadLabel];
        }
        _unReadImageV.hidden = NO;
        if (count > 99) {
            _unReadLabel.text = [NSString stringWithFormat:@"99+"];
        }
        else
        {
            _unReadLabel.text = [NSString stringWithFormat:@"%li",count];
        }
        
    }
    else
    {
        _unReadImageV.hidden = YES;
    }
}
//Timeline_Notice_color
//timeline_notify.png
//msgcome.wav

//创建自定义标签栏
- (void)_creatTabar
{
    self.tabBar.barTintColor = [UIColor orangeColor];
    //移除tabbarbutton
    //UItabbarButton
    for (UIView *subView in self.tabBar.subviews) {
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([subView isKindOfClass:cls]) {
            [subView removeFromSuperview];
        }
    }
    //创建imageView作为子视图添加到tabBar上
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
//    bgImage = [bgImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    bgImageView.imageViewName = @"mask_navbar.png";
   // bgImageView.contentMode = UIViewContentModeScaleAspectFill;

    [self.tabBar addSubview:bgImageView];
    
    
   
    
    NSArray *imageNames = @[
                            @"home_tab_icon_1.png",
                            @"home_tab_icon_2.png",
                            @"home_tab_icon_3.png",
                            @"home_tab_icon_4.png",
                            @"home_tab_icon_5.png",
                            ];
    CGFloat itemWidth = kScreenWidth / imageNames.count;
    
    
    //选中图片
    _selectImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 49)];
    _selectImageView.imageViewName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_selectImageView];
    
    
    //创建自定义按钮
    for (int index = 0; index <imageNames.count; index ++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(index * itemWidth, 0, itemWidth, 49)];
        //[button setImage:[UIImage imageNamed:imageNames[index]] forState:UIControlStateNormal];
        button.normalImageName = imageNames[index];
        button.tag = 100 + index;
        //[button setTitle:[NSString stringWithFormat:@"%i",index] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.tabBar addSubview:button];
    }
}
- (void)buttonAction:(UIButton *)sender
{
    [UIView animateWithDuration:.3 animations:^{
        _selectImageView.frame = sender.frame;
    }];
    
    self.selectedIndex = sender.tag - 100;
    
}

//创建控制器
- (void)_creatSubController
{
    //UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"home" bundle:nil];
    NSArray *namesAry = @[@"Home",@"Message",@"Profile",@"Discover",@"More"];
    NSMutableArray *navAry = [[NSMutableArray alloc] initWithCapacity:namesAry.count];
    
    for (NSString *name in namesAry) {
        //获取故事版
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
        //从故事版中获取导航控制器
        BaseNavController *navVc = [storyBoard instantiateInitialViewController];
        [navAry addObject:navVc];

    }
    self.viewControllers = navAry;
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
