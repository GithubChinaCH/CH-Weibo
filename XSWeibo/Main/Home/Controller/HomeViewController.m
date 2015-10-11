//
//  HomeViewController.m
//  XSWeibo
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//



#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "WeiboViewLayoutFrame.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MainTableBarController.h"

enum Request
{
    LoadWeibo = 0,
    LoadMoreWeibo,
    LoadNewWeibo
};

@interface HomeViewController ()
{
    enum Request             _weiboState; //刷新微博状态
    
    AppDelegate             *_appDelegate;
    NSMutableArray          *_weiboContentAry;  //存储全部微博数据数组
    
    WeiboTableView          *_weiboTable;   //微博列表视图
    ThemeImageView          *_topImageView; //顶部显示更新了几条微博的ImageView
    ThemeLabel              *_topLabel;   //顶部微博label
    
}


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    _weiboContentAry = [NSMutableArray array];
    _appDelegate = [UIApplication sharedApplication].delegate;
    
    
    [self _creatTableView];
    [self weiboLogin];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - weibotableView创建

- (void)_creatTableView
{
    _weiboTable = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)];
    _weiboTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_weiboTable];
    //_weiboTable.hidden = YES;
    _weiboTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewWeibo)];
    _weiboTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreWeibo)];
}





- (IBAction)loggingIN:(UIButton *)sender
{
    _weiboTable.hidden = NO;
    
    [self weiboLogin];
    
    
}

#pragma mark - 加载微博 上拉刷新 下拉加载

//上拉加载之前微博
- (void)loadMoreWeibo
{
    AppDelegate *myAppDelegate = [UIApplication sharedApplication].delegate;
    
    if ([myAppDelegate.weib isLoggedIn]) {
        _weiboState = LoadMoreWeibo;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"10" forKey:@"count"];
        if (_weiboContentAry.count != 0) {
            WeiboViewLayoutFrame *layoutFrame = [_weiboContentAry lastObject];
            WeiboModel *weiboModel = layoutFrame.weiboModel;
            NSString *weiboId = [weiboModel.weiboId stringValue];
            [params setObject:weiboId forKey:@"max_id"];
        }
        //https://api.weibo.com/2/users/show.json
        [myAppDelegate.weib requestWithURL:home_timeline
                                   params:params
                               httpMethod:@"GET"
                                 delegate:self];
        return;
    }
}

//下拉刷新最新微博
- (void)loadNewWeibo
{
    if ([_appDelegate.weib isLoggedIn]) {
        _weiboState = LoadNewWeibo;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [params setObject:@"1" forKey:@"count"];
        if (_weiboContentAry.count != 0) {
            WeiboViewLayoutFrame *layoutFrame = [_weiboContentAry firstObject];
            WeiboModel *weiboModel = layoutFrame.weiboModel;
            NSString *weiboId = [weiboModel.weiboId stringValue];
            [params setObject:weiboId forKey:@"since_id"];
        }
        [_appDelegate.weib requestWithURL:home_timeline
                                   params:params
                               httpMethod:@"GET"
                                 delegate:self];
        return;
    }
}

//加载微博
- (void)weiboLogin
{
//    [self tipViewShow:YES];
    [self hudViewShow:@"正在加载。。。"];
    if ([_appDelegate.weib isLoggedIn]) {
        _weiboState = LoadWeibo;
        [_appDelegate.weib requestWithURL:home_timeline
                                   params:[NSMutableDictionary dictionaryWithObject:_appDelegate.weib.userID forKey:@"uid"]
                               httpMethod:@"GET"
                                 delegate:self];
        return;
    }
    else
    {
        [_appDelegate.weib logIn];
    }
}

//Timeline_Notice_color
//timeline_notify.png
//msgcome.wav

//显示更新了几条微博
- (void)showNewWeiboWithCount:(NSInteger )count
{
    if (_topImageView == nil) {
        _topImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(10, -40, kScreenWidth - 20, 30)];
        _topImageView.imageViewName = @"timeline_notify.png";
        [self.view addSubview:_topImageView];
        
        _topLabel = [[ThemeLabel alloc] initWithFrame:_topImageView.bounds];
        _topLabel.colorName = @"Timeline_Notice_color";
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [_topImageView addSubview:_topLabel];
    }
    if (count > 0) {
        _topLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        [UIView animateWithDuration:.6 animations:^{
            _topImageView.transform = CGAffineTransformMakeTranslation(0, 5 + 40);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                [UIView setAnimationDelay:1.0];
                _topImageView.transform = CGAffineTransformIdentity;
            }];
        }];
        
        //注册系统声音
        NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
        AudioServicesPlaySystemSound(soundId);
    }
}


- (IBAction)logout:(UIButton *)sender
{
    if (![_appDelegate.weib isLoggedIn]) {
        return;
    }
    [_appDelegate.weib logOut];
}




- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
//    NSLog(@"输出结果   %@",result);
    NSArray *ary = result[@"statuses"];
    
    NSMutableArray *newWeiboAry = [NSMutableArray array];
    for (NSDictionary *dic in ary) {
        WeiboViewLayoutFrame *weiboLayout = [[WeiboViewLayoutFrame alloc] init];
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
        weiboLayout.weiboModel = weiboModel;
        [newWeiboAry addObject:weiboLayout];

    }
    if (_weiboState == LoadWeibo) {
        _weiboContentAry = newWeiboAry;
//        [self tipViewShow:NO];
        [self completionLoading:@"加载完成"];
    }
    else if (_weiboState == LoadMoreWeibo)
    {
        [newWeiboAry removeObjectAtIndex:0];

        [_weiboContentAry addObjectsFromArray:newWeiboAry];
    }
    else
    {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newWeiboAry.count)];
        [_weiboContentAry insertObjects:newWeiboAry atIndexes:indexSet];
        [self showNewWeiboWithCount:newWeiboAry.count];
        
        MainTableBarController *main = (MainTableBarController *)self.navigationController.tabBarController;
        main.block();
    }
    
    
    if (_weiboContentAry.count != 0) {
        _weiboTable.dataAry = _weiboContentAry;
        [_weiboTable reloadData];
    }
    
    [_weiboTable.footer endRefreshing];
    [_weiboTable.header endRefreshing];
    
    
}

- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    NSLog(@"!11");//dasdadas
}

- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
   // NSLog(@"response %@",response);
}
- (IBAction)changeTheme:(UIButton *)sender
{
    static int i = 0;
    ThemeManager *manager = [ThemeManager shareInstance];
    if (i == 0 ) {
        manager.themeName = @"Honey";
        i = 1;
    }
    else if(i == 1)
    {
        manager.themeName = @"Dark Knight";
        i = 2;
    }
    else if (i == 2)
    {
        manager.themeName = @"Cat";
        i = 0;
    }
   
}


@end
