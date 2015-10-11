//
//  WeiboTableViewCell.h
//  XSWeibo
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboViewLayoutFrame.h"
#import "WeiboView.h"
@class WeiboModel;


@interface WeiboTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *respost;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic, strong) WeiboView *weiboView;

@property (nonatomic, strong) WeiboViewLayoutFrame *weiboLayoutFrame;

@end
