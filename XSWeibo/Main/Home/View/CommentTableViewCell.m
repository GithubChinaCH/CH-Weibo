//
//  CommentTableViewCell.m
//  XSWeibo
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    _name = [[UILabel alloc] initWithFrame:CGRectZero];
    _comment = [[WXLabel alloc] initWithFrame:CGRectZero];
    
    
    [self.contentView addSubview:_name];
    [self.contentView addSubview:_comment];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentModel:(CommentModel *)commentModel
{
    if (_commentModel != commentModel) {
        _commentModel = commentModel;
        
        //设置头像
        _iconImage.layer.masksToBounds = YES;
        _iconImage.layer.cornerRadius = 10;
        NSString *iconStr = commentModel.user.profile_image_url;
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:iconStr]];
        
        //设置名字
        _name.top = _iconImage.top;
        _name.left = _iconImage.right + 10;
        _name.text = commentModel.user.screen_name;
        _name.font = [UIFont systemFontOfSize:18];
        _name.textColor = [UIColor orangeColor];
        [_name sizeToFit];
        _name.numberOfLines = 1;
        
        //设置评论内容
        //设置高度
        CGFloat height = [WXLabel getTextHeight:20 width:kScreenWidth text:commentModel.text linespace:1.0];
        _comment.font = [UIFont systemFontOfSize:14];
        _comment.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
        _comment.wxLabelDelegate = self;
        _comment.numberOfLines = 0;
        _comment.width = kScreenWidth - 80;
        _comment.height = height + 10;
        _comment.top = _name.bottom + 10;
        _comment.left = _iconImage.right + 10;
        _comment.text = commentModel.text;
//        [self setNeedsLayout];
    }
}


#pragma mark - wxLabelDelegate

- (NSString*)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"#\\w+#";
    NSString *regex3 = @"http(s)?://([a-zA-Z0-9._-]+(/)?)*";
    NSString *regex = [NSString stringWithFormat:@"%@|%@|%@",regex1,regex2,regex3];
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel
{
    return [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel
{
    return [UIColor grayColor];
}

@end
