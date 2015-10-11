//  BaseViewController.m
//  XSWeibo
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "ThemeImageView.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeButton.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()
{
    UIImageView *_bgImageView;
    
    UIView *_tipView;  //提示信息
    MBProgressHUD *_hudView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    ThemeImageView *imageV = [[ThemeImageView alloc] initWithFrame:self.view.bounds];
    imageV.imageViewName = @"bg_home.jpg";
    [self setNavItem];

    //[self.view insertSubview:imageV atIndex:0];
}


#pragma mark - 提示信息
- (void)tipViewShow:(BOOL)isshow
{
    if (isshow) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2 - 80, kScreenWidth, 20)];
        _tipView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tipView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"正在加载...";
        [label sizeToFit];
        [_tipView addSubview:label];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.height = 20.0;
        label.left = (kScreenWidth - label.width)/ 2;
        
        UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_tipView addSubview:active];
        active.right = CGRectGetMinX(label.frame);
        [active startAnimating];
    }
    else
    {
        if (_tipView) {
            [_tipView removeFromSuperview];
        }
    }
}

- (void)hudViewShow:(NSString *)title
{
    if (_hudView == nil) {
        _hudView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    //设置文字
    _hudView.labelText = title;
    
    _hudView.detailsLabelText = @"hello world";
    //设置灰色背景视图
    _hudView.dimBackground = YES;
}

- (void)hudViewHidden
{
    [_hudView hide:YES];
}

- (void)completionLoading:(NSString *)str
{
    _hudView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _hudView.mode = MBProgressHUDModeCustomView;
    _hudView.labelText = str;
    [_hudView show:YES];
    [_hudView hide:YES afterDelay:1.0];
}




#pragma mark - 设置导航栏左右按钮
- (void)setNavItem
{
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    
    ThemeButton *leftButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    leftButton.backgroundImageName = @"button_title.png";
   // leftButton.normalImageName = @"group_btn_all_on_title.png";
    [leftButton setTitle:@"设置" forState:UIControlStateNormal];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 40, 10, 15)];
    [leftButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    ThemeButton *BtnOnLeftButton = [[ThemeButton alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
    BtnOnLeftButton.backgroundImageName = @"group_btn_all_on_title.png";
    [leftButton addSubview:BtnOnLeftButton];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    ThemeButton *rightButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    rightButton.backgroundImageName = @"button_m";
    rightButton.normalImageName = @"button_icon_plus";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //[rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

- (void)setAction
{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)editAction
{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
