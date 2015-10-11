//
//  ThemeImageView.m
//  XSWeibo
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage) name:kThemeDidChangeNotificationName object:nil];
    }
    return self;
}
- (void)changeImage
{
    [self loadImage];
}

- (void)setImageViewName:(NSString *)imageViewName
{
    if (![_imageViewName isEqualToString:imageViewName]) {
        _imageViewName = [imageViewName copy];
        [self loadImage];
    }
}


- (void)setStretchName:(NSString *)stretchName
{
    if (![_stretchName isEqualToString:stretchName]) {
        _stretchName = stretchName;
        [self loadImage];
    }
}


- (void)loadImage
{
    //得到主题管家
    ThemeManager *manager = [ThemeManager shareInstance];
    //取得图片
    UIImage *bgImage = [manager getThemeImage:self.imageViewName];

    if (bgImage != nil) {
        self.image = bgImage;
    }
    
    UIImage *image = [manager getThemeImage:_stretchName];
    image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    if (image) {
        self.image = image; 
    }
}
@end
