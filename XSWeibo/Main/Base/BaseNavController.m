//
//  BaseNavController.m
//  XSWeibo
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseNavController.h"
#import "ThemeManager.h"

@interface BaseNavController ()

@end

@implementation BaseNavController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//当xib创建出来的时候调用该init方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:kThemeDidChangeNotificationName object:nil];
    }
    return self;
}

- (void)changeTheme
{
    [self loadImage];
}

- (void)loadImage
{
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *image = [manager getThemeImage:@"mask_titlebar64@2x"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    UIColor *color = [manager getThemeColor:@"Mask_Title_color"];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color,
                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:25]};

    UIImage *bgImage =[manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    [self loadImage];
    //[self.navigationBar insertSubview:imageView atIndex:1];
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
