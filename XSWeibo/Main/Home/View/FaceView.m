//
//  FaceView.m
//  XSWeibo
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FaceView.h"

@interface FaceView ()
{
    NSArray *_allFaceAry; //总共表情的数据
    NSArray *_curreFaceAry;//当前页数的数组
    
    CGFloat _faceWidth; //表情的宽
    CGFloat _faceHeight; //表情的高
    
    NSInteger _onePageFaceNum;
    UIImageView *_glassView; //放大镜
    UIImageView *_faceImage; //放大境上的表情
}

@end

@implementation FaceView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(0, 0, kScreenWidth, 200);
        _faceHeight = self.frame.size.height / 4;
        _faceWidth = kScreenWidth / 7;
        _onePageFaceNum = 28;
        [self loadData];
    }
    return self;
}

//读取数据
- (void)loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    _allFaceAry = [NSArray arrayWithContentsOfFile:path];
}


//设置一页表情的个数
- (void)setPageNum:(NSInteger)pageNum
{
    if (_pageNum != pageNum) {
        _pageNum = pageNum;
        self.right = pageNum * kScreenWidth;
        NSInteger num = (_allFaceAry.count - ((pageNum -1) * _onePageFaceNum));
        
        if (num > _onePageFaceNum ) {
            NSInteger loc = _onePageFaceNum * (pageNum - 1);
            NSRange range = {loc,_onePageFaceNum};
            _curreFaceAry = [_allFaceAry subarrayWithRange:range];
        }
        else
        {
            NSInteger loc = _onePageFaceNum * (pageNum - 1);
            NSInteger len = _allFaceAry.count - (pageNum - 1) *_onePageFaceNum;
            NSRange range = {loc,len};
            _curreFaceAry = [_allFaceAry subarrayWithRange:range];
        }
        
        
    }
}


//设置图片
- (void)drawRect:(CGRect)rect
{
//    UIImage *image = [UIImage imageNamed:@"001"];
//    [image drawInRect:CGRectMake(0, 0, 100, 100)];
    
    [[UIColor clearColor] set];
    UIRectFill(rect);
    for (int index = 0; index < _curreFaceAry.count; index ++) {
        NSDictionary *dic = _curreFaceAry[index];
        UIImage *image = [UIImage imageNamed:dic[@"png"]];
        NSInteger y = index / 7;
        NSInteger x = index - y * 7;
        CGRect rect = CGRectMake((_faceWidth - 30) / 2 + x * _faceWidth,(_faceHeight - 30) / 2 + y * _faceHeight, 30, 30);
        [image drawInRect:rect];
    }
}

//emoticon_keyboard_magnifier 放大镜
//视图被点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *view = (UIScrollView *)self.superview;
        view.scrollEnabled = NO;
    }
    UITouch *touch = [touches anyObject];
    //获取触摸点
    CGPoint point = [touch locationInView:self];
    
    if ([self pointInside:point withEvent:event] ) {
        NSInteger num = [self calculateTheNumOfFace:point];
        NSLog(@"%li",num);
        [self addGlassView:num];
        
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    if ([self pointInside:point withEvent:event] ) {
        NSInteger num = [self calculateTheNumOfFace:point];
        NSLog(@"%li",num);
        [self addGlassView:num];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self pointInside:point withEvent:event] )
    {
        NSInteger num = [self calculateTheNumOfFace:point];
        NSDictionary *facedic = _curreFaceAry[num];
        [self.delegate showFaceStr:facedic[@"cht"]];
    }
    
    //移除放大镜
    if (_glassView) {
        [_glassView removeFromSuperview];
        _glassView = nil;
        _faceImage = nil;
    }
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *view = (UIScrollView *)self.superview;
        view.scrollEnabled = YES;
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


//添加放大境
- (void)addGlassView:(NSInteger)num
{
    if (num < _curreFaceAry.count) {
        NSDictionary *facedic = _curreFaceAry[num];
        //创建放大镜视图
        if (_glassView == nil) {
            _glassView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
            _glassView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];
            [self addSubview:_glassView];
            
            _faceImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 40, 40)];
            
            [_glassView addSubview:_faceImage];
        }
        NSInteger y = num / 7;
        NSInteger x = num - y * 7;
        CGPoint center = {x * _faceWidth + _faceWidth/2, y * _faceHeight + _faceHeight / 2};
        _glassView.center = center;
        _glassView.bottom = center.y;
        _faceImage.image = [UIImage imageNamed:facedic[@"png"]];
        
        
    }
}



//计算第几个表情
- (NSInteger)calculateTheNumOfFace:(CGPoint)point
{
    NSInteger x = point.x / _faceWidth;
    NSInteger y = point.y / _faceHeight;
    
    NSInteger num = y * 7 + x;
    return num;
}


@end
