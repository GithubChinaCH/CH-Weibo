//
//  ThemeManager.m
//  XSWeibo
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

+ (ThemeManager *)shareInstance
{
    static ThemeManager *themeManager = nil;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        themeManager = [[self alloc] init];
    });
    return themeManager;
}

//instancetype
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeNames"];
        if (name.length != 0) {
            _themeName = name;
        }
        else
        {
            _themeName = @"Cat";
        }
        
        
        //读取主题名 －》 主题路径 配置文件放到字典里
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
    }
    return self;
}

//设置主题名字 触发通知
- (void)setThemeName:(NSString *)themeName
{
    if (![_themeName isEqualToString:themeName])
    {
        _themeName = themeName;
        
        NSString *filePath = [self themePath];
        NSString *path = [filePath stringByAppendingPathComponent:@"config.plist"];
        _allColorDic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotificationName object:nil];
        
        
    }
}


- (UIImage *)getThemeImage:(NSString *)imageName
{
    //得到图片路径
    
    //1 得到主题包路径
    NSString *themePath = [self themePath];
    //2 拼接图片路径
    NSString *filePath = [themePath stringByAppendingPathComponent:imageName];
    //3 读取图片
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}


//主题包路径获取
- (NSString *)themePath
{
    //1 获取主题包根路径
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    
    //2 当前主题包的路径
    NSString *themePath = [self.themeConfig objectForKey:self.themeName];
    
    //3 完整路径
    NSString *path = [bundlePath stringByAppendingPathComponent:themePath];
    return path;
}

- (UIColor *)getThemeColor:(NSString *)name
{
    if (name.length == 0) {
        return nil;
    }
    if (_allColorDic == nil) {
        NSString *filePath = [self themePath];
        NSString *path = [filePath stringByAppendingPathComponent:@"config.plist"];
        _allColorDic = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    
    NSDictionary *colorDic = _allColorDic[name];
    CGFloat red = [colorDic[@"R"] floatValue] / 255;
    CGFloat green = [colorDic[@"G"] floatValue] / 255;
    CGFloat blue = [colorDic[@"B"] floatValue] / 255;
    CGFloat alpha = [colorDic[@"alpha"] floatValue];
    if (!alpha) {
        alpha = 1;
    }
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}



@end
