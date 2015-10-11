//
//  MoreCellTableViewCell.h
//  XSWeibo
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeLabel.h"

@interface MoreCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet ThemeLabel *cellLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *themeLabel;

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *bgImageName;


@end
