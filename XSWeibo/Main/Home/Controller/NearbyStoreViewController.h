//
//  NearbyStoreViewController.h
//  XSWeibo
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loadTableView)(void);
@interface NearbyStoreViewController : UIViewController

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, copy) loadTableView loadBlock;

@end
