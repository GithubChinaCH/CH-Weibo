//
//  AttentionVC.m
//  XSWeibo
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "AttentionVC.h"
#import "NetWorking.h"
#import "AppDelegate.h"
#import "AttentionModel.h"
#import "CellCollectionViewCell.h"

@interface AttentionVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

{
    UICollectionView *_collectionView;
    NSMutableArray *_allModel;
}

@end

@implementation AttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注列表";
    [self _creatItem];
    [self creatView];
    [self loadData];
}
- (void)creatView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(90, 140);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"CellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _allModel.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _allModel[indexPath.row];
    return cell;
}

- (void)loadData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"199" forKey:@"count"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [parameters setObject:delegate.weib.userID forKey:@"uid"];
    [NetWorking GETURLWithURLStr:@"friendships/friends.json" Parameters:parameters completionBlock:^(id result) {
        NSArray *ary = result[@"users"];
        _allModel = [NSMutableArray array];
        for (NSDictionary *dic in ary) {
            AttentionModel *model = [[AttentionModel alloc] initWithDataDic:dic];
            [_allModel addObject:model];
        }
        [_collectionView reloadData];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
