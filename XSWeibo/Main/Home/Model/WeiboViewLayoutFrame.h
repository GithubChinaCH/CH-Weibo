//
//  WeiboViewLayoutFrame.h
//  XSWeibo
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboModel.h"

@interface WeiboViewLayoutFrame : NSObject

@property (nonatomic, assign) CGRect textFrame; //微博文字
@property (nonatomic, assign) CGRect sourceTextFrame; //转发源微博文字
@property (nonatomic, assign) CGRect bgImageFrame; //微博背景
@property (nonatomic, assign) CGRect imageFrame;   //图片frame
@property (nonatomic, assign) CGRect frame; //整个weiboview的frame


@property (nonatomic, strong) WeiboModel *weiboModel;//微博的model
@property (nonatomic, assign) BOOL isDetail;

- (void)layoutFrame;


@end
