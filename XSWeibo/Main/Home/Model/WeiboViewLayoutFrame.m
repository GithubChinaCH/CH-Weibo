//
//  WeiboViewLayoutFrame.m
//  XSWeibo
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboViewLayoutFrame.h"
#import "WXLabel.h"

@implementation WeiboViewLayoutFrame
{
    BOOL _noImage;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        [self _layoutFrame];
    }
}

- (void)setIsDetail:(BOOL)isDetail
{
    if (_isDetail != isDetail) {
        _isDetail = isDetail;
        [self _layoutFrame];
    }
}

- (void)layoutFrame
{
    if (_noImage) {
        return;
    }
    else
    {
       CGRect ImageRect = self.imageFrame;
        ImageRect.size.height = 200;
        ImageRect.size.width = 200;
        self.imageFrame = ImageRect;
    }
    
    //微博视图frame
    CGRect rect = self.frame;
    if (self.weiboModel.reWeiboModel) {
        rect.size.height = CGRectGetMaxY(self.bgImageFrame);
    }
    else if (self.weiboModel.thumbnailImage)
    {
        rect.size.height = CGRectGetMaxY(self.imageFrame) + 10;
    }
    else
    {
        rect.size.height = CGRectGetMaxY(self.textFrame);
    }
    self.frame = rect;
}

- (void)_layoutFrame
{
    //1 微博视图的frame
    self.frame = CGRectMake(12, 50, kScreenWidth - 20, 250);
    
    //2 微博内容的frame
    CGFloat textWidth = CGRectGetWidth(self.frame);
    CGFloat textHeight = [WXLabel getTextHeight:18.0 width:textWidth text:self.weiboModel.text linespace:1.0];
    
//    CGFloat textHeight = [self getTextHeight:self.weiboModel.text];
    self.textFrame = CGRectMake(0, 5, textWidth, textHeight);
    //3 微博图片的frame
    if (self.weiboModel.reWeiboModel != nil) {
        //转发微博的宽
        CGFloat reTextWidth = CGRectGetWidth(self.frame) - 30;
        //转发微博的高
        CGFloat reTextHeight = [WXLabel getTextHeight:17.0 width:reTextWidth text:self.weiboModel.reWeiboModel.text linespace:5.0];
        //转发微博的frame
        self.sourceTextFrame = CGRectMake(20.0, CGRectGetMaxY(_textFrame) + 10, reTextWidth, reTextHeight);
        //转发图片名字
        NSString *reImageStr = self.weiboModel.reWeiboModel.thumbnailImage;
        if (reImageStr) {
            CGFloat reImageY = CGRectGetMaxY(self.sourceTextFrame);
            if (_isDetail)
            {
                self.imageFrame = CGRectMake((kScreenWidth - 150) / 2, reImageY, 150, 150);
            }
            else
            {
                self.imageFrame = CGRectMake(20.0, reImageY , 80, 80);
            }
        }
        //转发背景图片
        CGFloat bgImageY = CGRectGetMaxY(self.textFrame);
        CGFloat bgImageHeight;
        if (reImageStr) {
            //如果有转发图片 背景图片高度
            bgImageHeight = CGRectGetMaxY(self.imageFrame) + 20 - bgImageY;
        }
        else
        {
            //如果没有转发图片 背景图片高度
            bgImageHeight = CGRectGetMaxY(self.sourceTextFrame) + 20 - bgImageY;
        }
        self.bgImageFrame = CGRectMake(0, bgImageY, CGRectGetWidth(self.frame), bgImageHeight);
        
    }
    else
    {
        //没有转发微博 原本微博图片
        NSString *imageStr = self.weiboModel.thumbnailImage;
        if (imageStr) {
            CGFloat imageY = CGRectGetMaxY(self.textFrame) + 10;
            self.imageFrame = CGRectMake(5, imageY, 80, 80);
        }
    }
    //微博视图frame
    CGRect rect = self.frame;
    if (self.weiboModel.reWeiboModel) {
        rect.size.height = CGRectGetMaxY(self.bgImageFrame);
    }
    else if (self.weiboModel.thumbnailImage)
    {
        rect.size.height = CGRectGetMaxY(self.imageFrame) + 10;
    }
    else
    {
        rect.size.height = CGRectGetMaxY(self.textFrame);
        _noImage = YES;
    }
    self.frame = rect;
    
    
}

- (void)_layoutFrame1{
    //判读是否是详情，然后后面再计算：
    
    
    
    
    
    //根据 weiboModel计算
    //1.微博视图的frame
    self.frame = CGRectMake(55, 40, kScreenWidth-65, 0);
    
    //2.微博内容的frame
    //1>计算微博内容的宽度
    CGFloat textWidth = CGRectGetWidth(self.frame)-20;
    
    //2>计算微博内容的高度
    NSString *text = self.weiboModel.text;
    CGFloat textHeight = [WXLabel getTextHeight:15 width:textWidth text:text linespace:1];
    
    self.textFrame = CGRectMake(10, 0, textWidth, textHeight);
    
    //3.原微博的内容frame
    if (self.weiboModel.reWeiboModel != nil) {
        NSString *reText = self.weiboModel.reWeiboModel.text;
        
        //1>宽度
        CGFloat reTextWidth = textWidth-20;
        //2>高度
        
        CGFloat textHeight = [WXLabel getTextHeight:14 width:reTextWidth text:reText linespace:5.0];
        
        //3>Y坐标
        CGFloat Y = CGRectGetMaxY(self.textFrame)+10;
        self.sourceTextFrame = CGRectMake(20, Y, reTextWidth, textHeight);
        
        //4.原微博的图片
        NSString *thumbnailImage = self.weiboModel.reWeiboModel.thumbnailImage;
        if (thumbnailImage != nil) {
            
            CGFloat Y = CGRectGetMaxY(self.sourceTextFrame)+10;
            CGFloat X = CGRectGetMinX(self.sourceTextFrame);
            
            self.imageFrame = CGRectMake(X, Y, 80, 80);
        }
        
        //4.原微博的背景
        CGFloat bgX = CGRectGetMinX(self.textFrame);
        CGFloat bgY = CGRectGetMaxY(self.textFrame);
        CGFloat bgWidth = CGRectGetWidth(self.textFrame);
        CGFloat bgHeight = CGRectGetMaxY(self.sourceTextFrame);
        if (thumbnailImage != nil) {
            bgHeight = CGRectGetMaxY(self.imageFrame);
        }
        bgHeight -= CGRectGetMaxY(self.textFrame);
        bgHeight += 10;
        
        self.bgImageFrame = CGRectMake(bgX, bgY, bgWidth, bgHeight);
        
    } else {
        //微博图片
        NSString *thumbnailImage = self.weiboModel.thumbnailImage;
        if (thumbnailImage != nil) {
            
            CGFloat imgX = CGRectGetMinX(self.textFrame);
            CGFloat imgY = CGRectGetMaxY(self.textFrame)+10;
            self.imageFrame = CGRectMake(imgX, imgY, 80, 80);
        }
        
    }
    
    //计算微博视图的高度：微博视图最底部子视图的Y坐标
    CGRect f = self.frame;
    if (self.weiboModel.reWeiboModel != nil) {
        f.size.height = CGRectGetMaxY(_bgImageFrame);
    }
    else if(self.weiboModel.thumbnailImage != nil) {
        f.size.height = CGRectGetMaxY(_imageFrame);
    }
    else {
        f.size.height = CGRectGetMaxY(_textFrame);
    }
    self.frame = f;
    
    
    
    
    
    
    
}

- (CGFloat)getTextHeight:(NSString *)text
{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 65, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    if (rect.size.height < 20) {
        return 20;
    }
    else
    {
        return rect.size.height + 30;
    }
}



@end
