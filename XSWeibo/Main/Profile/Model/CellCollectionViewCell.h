//
//  CellCollectionViewCell.h
//  XSWeibo
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionModel.h"

@interface CellCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AttentionModel *model;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
