//
//  ZoomView.h
//  XSWeibo
//
//  Created by mac on 15/9/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZoomViewDelegate <NSObject>

@optional
//图片放大后的代理方法
- (void)zoomIN;
//图片缩小后的代理方法
- (void)zoomOut;

@end

@interface ZoomView : UIImageView<NSURLConnectionDataDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) NSString *imageURLStr;
@property (nonatomic, strong) UIImageView *gifIcon;
@property (nonatomic, assign) BOOL isGif; //判断是否是gif

@property(nonatomic, assign) id<ZoomViewDelegate>delegate;

@end
