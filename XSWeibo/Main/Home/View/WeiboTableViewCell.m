//
//  WeiboTableViewCell.m
//  XSWeibo
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"

@implementation WeiboTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //创建微博view
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    _weiboView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_weiboView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setWeiboModel:(WeiboModel *)weiboModel
//{
//    if (_weiboModel != weiboModel) {
//        _weiboModel = weiboModel;
//        //[self layoutIfNeeded];
//    }
//}

- (void)setWeiboLayoutFrame:(WeiboViewLayoutFrame *)weiboLayoutFrame
{
    if (_weiboLayoutFrame != weiboLayoutFrame) {
        _weiboLayoutFrame = weiboLayoutFrame;
        
        _weiboView.layoutFrame = weiboLayoutFrame;
        
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    WeiboModel *_weiboModel = _weiboLayoutFrame.weiboModel;
   // 01 用户头像
    NSString *headStr = _weiboModel.userModel.profile_image_url;
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:headStr]];
    
    //02 用户昵称
    _nickName.text = _weiboModel.userModel.screen_name;
    
    //03 评论数 转发数
    _respost.text = [NSString stringWithFormat:@"转发:%@",_weiboModel.repostsCount];
    _comment.text = [NSString stringWithFormat:@"评论:%@",_weiboModel.commentsCount];
    
    //时间
    _timeLabel.text = _weiboModel.createDate;
    //04 微博来源
    NSString *str1 = @"rel=\"nofollow\">";
    NSString *str2 = @"</a>";
    NSRange rang1 = [_weiboModel.source rangeOfString:str1];
    NSRange rang2 = [_weiboModel.source rangeOfString:str2];
    NSInteger loca = rang1.location + rang1.length;
    NSInteger lenth = rang2.location - rang1.location - rang1.length;
    NSRange rang = {loca,lenth};
    if (rang.location != NSNotFound) {
        NSString *source = [_weiboModel.source substringWithRange:rang];
        _source.text = [NSString stringWithFormat:@"来源:%@",source];
    }
}


@end
