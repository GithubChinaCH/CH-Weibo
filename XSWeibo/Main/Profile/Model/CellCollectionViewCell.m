//
//  CellCollectionViewCell.m
//  XSWeibo
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "CellCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CellCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)setModel:(AttentionModel *)model
{
    if (_model != model) {
        _model = model;
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.profile_image_url]];
        _name.text = model.screen_name;
        _name.textAlignment = NSTextAlignmentCenter;
        _name.font = [UIFont systemFontOfSize:13];
    }
}

@end
