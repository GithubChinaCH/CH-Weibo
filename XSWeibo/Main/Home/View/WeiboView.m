//
//  WeiboView.m
//  XSWeibo
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"

@implementation WeiboView
//xib文件创建
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _creatSubView];
    }
    return self;
}

- (void)_creatSubView
{
    // 微博内容
    _textLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _textLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_textLabel];
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _textLabel.wxLabelDelegate = self;
    
    //原微博内容
    _sourceTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _sourceTextLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_sourceTextLabel];
    _sourceTextLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourceTextLabel.wxLabelDelegate = self;
    
    //背景图片
    _bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
    [self insertSubview:_bgImageView atIndex:0];
    //_bgImageView.imageViewName = @"timeline_rt_border_9";
    
    //微博图片
    _weiboImage = [[ZoomView alloc] initWithFrame:CGRectZero];
    [self addSubview:_weiboImage];
 
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:kThemeDidChangeNotificationName object:nil];
}


#pragma mark - WXLabelDelegate
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9.-_]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
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

- (void)setLayoutFrame:(WeiboViewLayoutFrame *)layoutFrame
{
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        
        self.frame = layoutFrame.frame;
        //设置微博内容
        self.textLabel.numberOfLines = 0;
        self.textLabel.frame = layoutFrame.textFrame;
        
        
        
        self.textLabel.text = layoutFrame.weiboModel.text;
        //        _weiboView.textLabel.backgroundColor = [UIColor yellowColor];
        
        //转发
        self.sourceTextLabel.frame = layoutFrame.sourceTextFrame;
        if (layoutFrame.weiboModel.reWeiboModel.userModel.name) {
            self.sourceTextLabel.text = [NSString stringWithFormat:@"@%@:%@",layoutFrame.weiboModel.reWeiboModel.userModel.name,layoutFrame.weiboModel.reWeiboModel.text];
        }
        else
        {
            self.sourceTextLabel.text = layoutFrame.weiboModel.reWeiboModel.text;
        }
        
        
        //微博图片
        self.weiboImage.frame = layoutFrame.imageFrame;
        self.weiboImage.contentMode = UIViewContentModeScaleAspectFit;
        if (layoutFrame.weiboModel.reWeiboModel.thumbnailImage) {
            [self.weiboImage sd_setImageWithURL:[NSURL URLWithString:layoutFrame.weiboModel.reWeiboModel.thumbnailImage]];
            self.weiboImage.imageURLStr = layoutFrame.weiboModel.reWeiboModel.originalImage;
            
            //判断urlstr后缀是否是gif
            [self isGif];
        }
        else
        {
            [self.weiboImage sd_setImageWithURL:[NSURL URLWithString:layoutFrame.weiboModel.thumbnailImage]];
            self.weiboImage.imageURLStr = layoutFrame.weiboModel.originalImage;
            
            //判断urlstr后缀是否是gif
            [self isGif];
        }
        
        //背景图片
        self.bgImageView.frame = layoutFrame.bgImageFrame;
        self.bgImageView.stretchName = @"timeline_rt_border_9";
        

    }
}


- (void)isGif
{
    //判断urlstr后缀是否是gif
    NSString *extension = [self.weiboImage.imageURLStr pathExtension];
    NSLog(@"%@",extension);
    if ([extension isEqualToString:@"gif"]) {
        self.weiboImage.contentMode = UIViewContentModeScaleToFill;
        self.weiboImage.gifIcon.hidden = NO;
        self.weiboImage.gifIcon.frame = CGRectMake(self.weiboImage.width - 24, self.weiboImage.height - 15, 24, 15);
        self.weiboImage.isGif = YES;
    }
    else
    {
        self.weiboImage.gifIcon.hidden = YES;
    }
}

#pragma mark - 接收通知
- (void)changeTheme
{
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourceTextLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
}

@end
