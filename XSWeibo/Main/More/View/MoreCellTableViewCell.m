//
//  MoreCellTableViewCell.m
//  XSWeibo
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreCellTableViewCell.h"
#import "ThemeManager.h"


@implementation MoreCellTableViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:kThemeDidChangeNotificationName object:nil];
    [self loadImage];
}

- (instancetype)init
{
    self = [super init];
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
    UIImage *image = [manager getThemeImage:self.imageName];
    if (image != nil) {
        self.imageView.image = image;
    }
    
    UIImage *bgImage = [manager getThemeImage:self.bgImageName];
    if (bgImage != nil) {
        self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    }
}

- (void)setImageName:(NSString *)imageName
{
    if (![_imageName isEqualToString:imageName]) {
        _imageName = imageName;
        [self loadImage];
    }
}
- (void)setBgImageName:(NSString *)bgImageName
{
    if (![_bgImageName isEqualToString:bgImageName]) {
        _bgImageName = bgImageName;
        [self loadImage];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
