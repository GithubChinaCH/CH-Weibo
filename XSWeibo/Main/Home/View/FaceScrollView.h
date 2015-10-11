//
//  FaceScrollView.h
//  XSWeibo
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@protocol FaceScrollDelegate <NSObject>

- (void)write:(NSString *)str;

@end

@interface FaceScrollView : UIScrollView<FaceViewDelegate>

@property (nonatomic, strong) FaceView *faceView;
@property (nonatomic, assign) id<FaceScrollDelegate> scrollDelegate;

@end
