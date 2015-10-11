//
//  ThemeLabel.m
//  XSWeibo
//
//  Created by mac on 15/9/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:kThemeDidChangeNotificationName object:nil];
    }
    return self;
}
- (void)changeColor
{
    [self loadColor];
}

- (void)setColorName:(NSString *)colorName
{
    if (![_colorName isEqualToString:colorName]) {
        _colorName = [colorName copy];
        [self loadColor];
    }
}

- (void)loadColor
{
    //得到主题管家
    ThemeManager *manager = [ThemeManager shareInstance];
    //取得图片
    UIColor *color = [manager getThemeColor:self.colorName];
    
    self.textColor = color;    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:kThemeDidChangeNotificationName object:nil];
    
}

@end
