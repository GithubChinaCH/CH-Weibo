//
//  ZoomView.m
//  XSWeibo
//
//  Created by mac on 15/9/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ZoomView.h"
#import "MBProgressHUD.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"

@implementation ZoomView
{
    UIScrollView *_scrollView; //滑动视图
    UIImageView *_imageView;   //图片视图
    
    CGFloat _allLength;     //总共数据的长度
    NSMutableData *_receiveData;  //用来接收data
    MBProgressHUD *_hudView;  //提示视图
    
    NSURLConnection *_connection;
    
}


#pragma mark - 重写自定义方法

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _creatTap];
        [self _creatGifIcon];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self _creatTap];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _creatTap];
    }
    return self;
}

- (void)_creatGifIcon
{
    _gifIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _gifIcon.image = [UIImage imageNamed:@"timeline_gif"];
    [self addSubview:_gifIcon];
}


//创建手势
- (void)_creatTap
{
    self.userInteractionEnabled = YES;
    //创建手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    //将手势添加到视图上
    [self addGestureRecognizer:tap];
    
    
}
#pragma mark - 手势执行方法
- (void)tapAction
{
    //将原先image隐藏
    self.hidden = YES;
    [self _creatScrollView];
    
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    _imageView.frame = rect;
    
    //图片放大动画
    [UIView animateWithDuration:.3 animations:^{
        if ([self.delegate respondsToSelector:@selector(zoomIN)]) {
            [self.delegate zoomIN];
        }
        _imageView.frame = _scrollView.frame;
    } completion:^(BOOL finished) {
        [self _creatConnection];
        _scrollView.backgroundColor = [UIColor blackColor];
    }];
    
}

//点击imageview视图执行事件
- (void)returnTapAction
{
    if (_hudView) {
        [_hudView removeFromSuperview];
        _hudView = nil;
    }
    [_connection cancel];
    //将imageview背景颜色设置为透明
    _imageView.backgroundColor = [UIColor clearColor];
    _scrollView.backgroundColor = [UIColor clearColor];
    //点击图片返回原先imageframe
    [UIView animateWithDuration:.6 animations:^{
        if ([self.delegate respondsToSelector:@selector(zoomOut)]) {
            [self.delegate zoomOut];
        }
        _imageView.frame = [self convertRect:self.bounds toView:self.window];
        _imageView.top += _scrollView.contentOffset.y;
    } completion:^(BOOL finished) {
        self.hidden = NO;
        [_scrollView removeFromSuperview];
        _imageView = nil;
        _scrollView = nil;
        _receiveData = nil;
        _hudView = nil;
    }];
}

//长按手势执行事件
- (void)longTapAction:(UILongPressGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateBegan)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil
                                                           message:@"是否保存图片"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
        [alerView show];
    }
}

//警告视图代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImage *image = _imageView.image;
        
        //保存图片到相册
         //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
//保存图片到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:_imageView animated:YES];
        hudView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        hudView.mode = MBProgressHUDModeCustomView;
        hudView.labelText = @"保存成功";
        [hudView hide:YES afterDelay:1.0];
    }
}

//创建网络连接
- (void)_creatConnection
{
    //原图url
    if (_imageURLStr) {
        //创建url
        NSURL *url = [NSURL URLWithString:self.imageURLStr];
        //创建网络请求
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
        
        //创建网络连接
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}


- (void)_creatScrollView
{
    //如果滑动视图为空则创建滑动视图
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        //_scrollView.showsVerticalScrollIndicator = NO;
        [self.window addSubview:_scrollView];
        
        //创建imageview
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.image = self.image;
        [_scrollView addSubview:_imageView];
        
        //添加返回手势
        UITapGestureRecognizer *returnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnTapAction)];
        [_imageView addGestureRecognizer:returnTap];
        
        
        //添加长按手势
        UILongPressGestureRecognizer *longTap =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
        longTap.minimumPressDuration = 1.0;
        [_imageView addGestureRecognizer:longTap];
    }
}


#pragma mark - NSURLConnectionDataDelegate

//接收到请求头
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //将请求头转换为http请求头
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *responseDic = [httpResponse allHeaderFields];
    NSString *length = responseDic[@"Content-Length"];
    //设置请求数据长度
    _allLength = [length floatValue];
    //创建接收data
    if (_receiveData == nil) {
        //创建接收数据
        _receiveData = [NSMutableData data];
        //创建hudView
        if (_hudView == nil) {
            //创建手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnTapAction)];
            
            _hudView = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
            _hudView.mode = MBProgressHUDModeDeterminate;
            _hudView.labelText = @"loading";
            _hudView.progress = 0;
            _hudView.userInteractionEnabled = YES;
            
            //添加手势
            [_hudView addGestureRecognizer:tap];
        }
    }
}

//接收到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
    CGFloat progress = _receiveData.length / _allLength;
    _hudView.progress = progress;
    NSLog(@"%lf",progress);
}

//数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //隐藏提示视图
    [_hudView hide:YES];
    //设置imageView的图片
    _imageView.image = [UIImage imageWithData:_receiveData];
    NSLog(@"下载完毕");
    
    //设置大图尺寸
    CGFloat height = _imageView.image.size.height / _imageView.image.size.width * kScreenWidth;
    //设置大图尺寸
    if (height > kScreenHeight) {
        [UIView animateWithDuration:.6 animations:^{
            _imageView.height = height;
            _imageView.width = kScreenWidth;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, height);
        }];
    }
    
    //播放gif图片
    if (self.isGif) {
        [self gifStart];
    }
    
}


//播放gif图片
- (void)gifStart
{
    //1 用---------------weiView
//    UIWebView *web = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
//    web.scalesPageToFit = YES;
//    [web loadData:_receiveData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [_scrollView addSubview:web];
   
    
    //2  --------------cfImage
    // 创建图片源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)_receiveData, NULL);
    //获取size_t
    size_t count = CGImageSourceGetCount(source);
    //创建数组接收图片
    NSMutableArray *imagesAry = [NSMutableArray array];
    for (size_t index = 0; index < count; index++) {
        CGImageRef cgimage = CGImageSourceCreateImageAtIndex(source, index, NULL);
        UIImage *image = [UIImage imageWithCGImage:cgimage];
        [imagesAry addObject:image];
        CGImageRelease(cgimage);
    }
    
    //启动动画 1
//    _imageView.animationImages = imagesAry;
//    _imageView.animationDuration = .1 * count;
//    [_imageView startAnimating];
    
    //启动动画 2
//    UIImage *animationImage = [UIImage animatedImageWithImages:imagesAry duration:.1 * count];
//    _imageView.image = animationImage;

    
    
    //3 ----------uimage-gif
    
    _imageView.image = [UIImage sd_animatedGIFWithData:_receiveData];
}
@end
