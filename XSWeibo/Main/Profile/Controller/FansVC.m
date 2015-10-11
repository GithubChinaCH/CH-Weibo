//
//  FansVC.m
//  XSWeibo
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FansVC.h"

@interface FansVC ()

@end

@implementation FansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉丝列表";
    [self _creatItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建item
- (void)_creatItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftItemAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
