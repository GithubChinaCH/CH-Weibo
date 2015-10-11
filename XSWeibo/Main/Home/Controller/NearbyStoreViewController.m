//
//  NearbyStoreViewController.m
//  XSWeibo
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NearbyStoreViewController.h"
#import "UIImageView+WebCache.h"

@interface NearbyStoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;//表视图
    UILabel *_placelabel;
}

@end

@implementation NearbyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近商圈";
    
    __weak NearbyStoreViewController *weekThis = self;
    self.loadBlock = ^{
        __strong NearbyStoreViewController *strong = weekThis;
        [strong ->_tableView reloadData];
    };
    [self _creatTableView];
    [self _creatItem];
}


//创建tableview
- (void)_creatTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //注册单元格
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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

#pragma mark - tabledelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *place = _datas[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:place[@"icon"]]];
//    _placelabel = [UILabel alloc] initWithFrame:<#(CGRect)#>
    cell.textLabel.text = place[@"title"];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
