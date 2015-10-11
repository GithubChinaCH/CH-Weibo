//
//  ProfileViewController.m
//  XSWeibo
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileViewController.h"
#import "WeiboTableView.h"
#import "NetWorking.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "UserView.h"
#import "WeiboViewLayoutFrame.h"
#import "WeiboModel.h"
#import "MJRefresh.h"

@interface ProfileViewController ()<SinaWeiboRequestDelegate>
{
    WeiboTableView *_weiboTable;
    AppDelegate *_appDelegate;
    
    UserModel *_userModel;
    
    NSMutableArray *_layoutAry;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    [self creatTableView];
    
    //读取数据
    [self loadData];
    
    
    
}
- (void)creatTableView
{
    _weiboTable = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)];
    _weiboTable.backgroundColor = [UIColor clearColor];
    _weiboTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreWeibo)];
    _weiboTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewWeibo)];
    [self.view addSubview:_weiboTable];
}


- (void)loadNewWeibo
{
    [self loadData];
}

- (void)loadMoreWeibo
{
    if ([_appDelegate.weib isLoggedIn]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"10" forKey:@"count"];
        if (_layoutAry.count != 0) {
            WeiboViewLayoutFrame *layoutFrame = [_layoutAry lastObject];
            WeiboModel *weiboModel = layoutFrame.weiboModel;
            NSString *weiboId = [weiboModel.weiboId stringValue];
            [params setObject:weiboId forKey:@"max_id"];
        }
        //https://api.weibo.com/2/users/show.json
        SinaWeiboRequest *sin = [_appDelegate.weib requestWithURL:home_timeline
                                    params:params
                                httpMethod:@"GET"
                                  delegate:self];
        sin.tag = 102;
        return;
    }
}
//读取数据
- (void)loadData
{
    _appDelegate = [UIApplication sharedApplication].delegate ;
    if ([_appDelegate.weib isLoggedIn]) {
      SinaWeiboRequest *sina = [_appDelegate.weib requestWithURL:@"users/show.json"
                                   params:[NSMutableDictionary dictionaryWithObject:_appDelegate.weib.userID forKey:@"uid"]
                               httpMethod:@"GET"
                                 delegate:self];
        sina.tag = 100;
    }
    else
    {
        [_appDelegate.weib logIn];
    }
    
    if ([_appDelegate.weib isLoggedIn]) {
        SinaWeiboRequest *sina = [_appDelegate.weib requestWithURL:@"statuses/user_timeline.json"
                                                            params:[NSMutableDictionary dictionaryWithObject:_appDelegate.weib.userID forKey:@"uid"]
                                                        httpMethod:@"GET"
                                                          delegate:self];
        sina.tag = 101;
    }
    else
    {
        [_appDelegate.weib logIn];
    }
    
    
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request.tag == 100) {
        NSDictionary *dic = result;
        _userModel = [[UserModel alloc] initWithDataDic:dic];
        [self creatTableHeaderView:_weiboTable];
    }
    
    else if (request.tag == 101)
    {
        NSArray *ary = result[@"statuses"];
        _layoutAry = [NSMutableArray array];
        for (NSDictionary *dic in ary) {
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
            layout.weiboModel = model;
            [_layoutAry addObject:layout];
        }
        
        _weiboTable.dataAry = _layoutAry;
        [_weiboTable reloadData];
    }
    else if (request.tag == 102)
    {
        NSArray *ary = result[@"statuses"];
        NSMutableArray *newWeiboAry  = [NSMutableArray array];
        for (NSDictionary *dic in ary) {
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
            layout.weiboModel = model;
            [_layoutAry addObject:layout];
        [newWeiboAry removeObjectAtIndex:0];
        
        [_layoutAry addObjectsFromArray:newWeiboAry];
      }
    }
    if (_layoutAry.count > 1) {
        [_weiboTable reloadData];
    }
    [_weiboTable.footer endRefreshing];
    [_weiboTable.header endRefreshing];
    
}


- (void)creatTableHeaderView:(UITableView *)table
{
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    NSArray *ary = [[NSBundle mainBundle] loadNibNamed:@"UserView" owner:nil options:nil];
    UserView *userview = [ary lastObject];
    userview.model = _userModel;
    userview.attention.text = [NSString stringWithFormat:@"%@",_userModel.friends_count];
    userview.fans.text = [NSString stringWithFormat:@"%@",_userModel.followers_count];
    userview.bounds = table.tableHeaderView.frame;
    table.tableHeaderView = userview;
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
