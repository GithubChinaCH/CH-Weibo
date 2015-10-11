//
//  ThemeButton.m
//  XSWeibo
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    [super buttonWithType:buttonType];;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotificationName object:nil];
    ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    return button;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //注册通知监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotificationName object:nil];
    }
    return self;
}

- (void)themeDidChange:(NSNotification *)notification
{
    //重新修改图片
    [self loadImage];
}
- (void)loadImage
{
    ThemeManager *themeManager = [ThemeManager shareInstance];
    //通过管家得到图片
    UIImage *normalImage = [themeManager getThemeImage:self.normalImageName];
    UIImage *hightightedImage = [themeManager getThemeImage:self.hightLightImageName];
    UIImage *backgroundImage = [themeManager getThemeImage:self.backgroundImageName];
    
    if (backgroundImage != nil) {
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    if (normalImage != nil) {
        [self setImage:normalImage forState:UIControlStateNormal];
    }
    if (hightightedImage != nil) {
        [self setImage:hightightedImage forState:UIControlStateHighlighted];
    }
    
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    if (_backgroundImageName != backgroundImageName) {
        _backgroundImageName = backgroundImageName;
        [self loadImage];
    }
}


- (void)setNormalImageName:(NSString *)normalImageName
{
    if (![_normalImageName isEqualToString:normalImageName]) {
        _normalImageName = normalImageName;
        [self loadImage];
    }
}

- (void)setHightLightImageName:(NSString *)hightLightImageName
{
    if (![_hightLightImageName isEqualToString:hightLightImageName]) {
        _hightLightImageName = hightLightImageName;
        [self loadImage];
    }
}

@end
