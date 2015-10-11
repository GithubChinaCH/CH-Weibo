//
//  WeiboAnnotationView.m
//  XSWeibo
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation WeiboAnnotationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, 100, 40);
        [self _creatView];
    }
    return self;
}

- (void)_creatView
{
    //创建label
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 60, 40)];
    _textLabel.backgroundColor = [UIColor grayColor];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.numberOfLines = 3;
    _textLabel.textColor = [UIColor blackColor];
    [self addSubview:_textLabel];
    
    //创建头像view
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self addSubview:_iconView];
}

- (void)layoutSubviews
{
    WeiboAnnotation *annotation = self.annotation;
    _textLabel.text = annotation.weiboModel.text;
    //设置头像
    [_iconView sd_setImageWithURL:[NSURL URLWithString:annotation.weiboModel.userModel.profile_image_url]];
}

@end
