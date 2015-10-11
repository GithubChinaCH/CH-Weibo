//
//  CommentTableViewCell.h
//  XSWeibo
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "WXLabel.h"

@interface CommentTableViewCell : UITableViewCell<WXLabelDelegate>

@property (nonatomic, strong) CommentModel *commentModel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) WXLabel *comment;


@end
