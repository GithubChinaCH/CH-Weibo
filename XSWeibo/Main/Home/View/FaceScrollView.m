//
//  FaceScrollView.m
//  XSWeibo
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FaceScrollView.h"


@implementation FaceScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatFace];
        self.clipsToBounds = NO;
        self.pagingEnabled = YES;
        self.contentSize = CGSizeMake(kScreenWidth * 4, 0);
        UIImage *image = [UIImage imageNamed:@"emoticon_keyboard_background"];
        //    image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        self.backgroundColor = [UIColor colorWithPatternImage:image];

    }
    return self;
}

- (void)creatFace
{
    for (int index = 1; index <= 4; index++) {
        _faceView = [[FaceView alloc] initWithFrame:CGRectZero];
        _faceView.pageNum = index;
        _faceView.delegate = self;
        _faceView.backgroundColor = [UIColor clearColor];
        [self addSubview:_faceView];
    }
}

- (void)showFaceStr:(NSString *)string
{
    if ([self.scrollDelegate respondsToSelector:@selector(write:)]) {
        [self.scrollDelegate write:string]; 
    }
}

@end
