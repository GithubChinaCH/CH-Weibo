//
//  FaceView.h
//  XSWeibo
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDelegate <NSObject>

@optional
- (void)showFaceStr:(NSString *)string;

@end

@interface FaceView : UIView

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) id<FaceViewDelegate> delegate;

@end
