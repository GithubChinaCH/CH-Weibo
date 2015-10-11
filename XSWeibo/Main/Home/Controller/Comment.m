//
//  Comment.m
//  XSWeibo
//
//  Created by mac on 15/9/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "Comment.h"
#import "WeiboView.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"
#import "ThemeManager.h"
#import "WXLabel.h"
#import "MJRefresh.h"

@interface Comment ()<UITableViewDataSource,UITableViewDelegate,SinaWeiboRequestDelegate>
{
    UITableView *_tableView;//创建表视图
    
    UIImageView *_topView;  //顶部视图
    UIImageView *_bottomView; //底部视图
    UIImageView *_iconView; //头像
    UILabel *_nameLabel;    //名称label
    UILabel *_sourceLabel;   //来源label
    UILabel *_commentLabel;  //评论label
    
    NSArray *_dataAry;
    
    NSMutableArray *_commentAry; //评论model数组
    NSMutableArray *_heightAry;
}

@end

@implementation Comment

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _creatTableView];
    [self loadData];
    //设置左边返回按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置标题
    self.title = @"微博详情";
    //设置背景颜色
    UIImage *bgImage =[[ThemeManager shareInstance] getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
}
//读取数据
- (void)loadData
{
    _commentAry = [NSMutableArray array];
    _heightAry = [NSMutableArray array];
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSNumber *weiboID = self.weiboLayout.weiboModel.weiboId;
    
    if ([weiboID isKindOfClass:[NSString class]]) {
        [params setObject:weiboID forKey:@"id"];
    }
    else if ([weiboID isKindOfClass:[NSNumber class]])
    {
        [params setObject:[weiboID stringValue] forKey:@"id"];
    }
    
    //[params setObject:@"10" forKey:@"count"];
    [appdelegate.weib requestWithURL:comments params:params httpMethod:@"GET" delegate:self];
}

//上拉加载之前微博
- (void)loadMoreWeibo
{
    AppDelegate *myAppDelegate = [UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"10" forKey:@"count"];
    if (_commentAry.count != 0) {
        CommentModel *commentModel = [_commentAry lastObject];
        
        NSString *weiboId = commentModel.idstr;
        [params setObject:weiboId forKey:@"max_id"];
    }
    [myAppDelegate.weib requestWithURL:home_timeline
                                params:params
                            httpMethod:@"GET"
                              delegate:self];
    return;
   
}


//接收数据完毕
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    _dataAry = result[@"comments"];
    for (NSDictionary *dic in _dataAry) {
        CommentModel *model = [[CommentModel alloc] initWithDataDic:dic];
        NSLog(@"%@",model.text);
        [_commentAry addObject:model];
        CGFloat height = [WXLabel getTextHeight:20 width:kScreenWidth text:model.text linespace:1.0];
        [_heightAry addObject:@(height)];
    }
    
    [_tableView reloadData];
}

//创建表示图
- (void)_creatTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
   // _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreWeibo)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self _creatHeaderViewIN:_tableView];
//    _tableView.tableHeaderView.height = 100;
//    _tableView.tableHeaderView.backgroundColor = [UIColor yellowColor];
    if (_dataAry.count == 0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_tableView];
}

//创建头部视图
- (void)_creatHeaderViewIN:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    WeiboView *weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
//    weiboView.layoutFrame = self.weiboLayout;
//    weiboView.layoutFrame.isDetail = YES;
//    [weiboView.layoutFrame layoutFrame];
    self.weiboLayout.isDetail = YES;
    weiboView.layoutFrame = self.weiboLayout;
    weiboView.backgroundColor = [UIColor clearColor];
    view.height = weiboView.height;
    view.height += 130;
    weiboView.top = 90;
    [view addSubview:weiboView];
    
    
    //设置顶部视图
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    _topView.layer.borderColor = [UIColor blackColor].CGColor;
    _topView.layer.borderWidth = 1.0;
    _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    //设置底部视图
    _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _bottomView.layer.borderWidth = 1.0;
    _bottomView.layer.borderColor = [UIColor blackColor].CGColor;
    _bottomView.bottom = view.bottom;
    _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    //设置圆圈头像
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 30;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:self.weiboLayout.weiboModel.userModel.profile_image_url]];
    [_topView addSubview:_iconView];
    
    //设置姓名
    CGFloat left = _iconView.right + 20;
    CGFloat top = _iconView.top;
    CGFloat height = _iconView.height / 3;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 100, height)];
    _nameLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _nameLabel.text = self.weiboLayout.weiboModel.userModel.screen_name;
    _nameLabel.numberOfLines = 1;
    _nameLabel.font = [UIFont boldSystemFontOfSize:20];
    [_nameLabel sizeToFit];
    [_topView addSubview:_nameLabel];
    
    //设置来源
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourceLabel.left = _nameLabel.left;
    _sourceLabel.top = _nameLabel.bottom + 20;
    _sourceLabel.numberOfLines = 1;
    _sourceLabel.font = [UIFont systemFontOfSize:15];
    //修改来源str
    NSString *sourceStr = self.weiboLayout.weiboModel.source;
    if (sourceStr) {
        NSString *regex = @">.+<";
        NSArray *ary = [sourceStr componentsMatchedByRegex:regex];
        NSString *str = [ary lastObject];
        sourceStr = [str substringWithRange:NSMakeRange(1, str.length - 2)];
        _sourceLabel.text = [NSString stringWithFormat:@"来源:%@",sourceStr];
    }
    else
    {
        _sourceLabel.text = nil;
    }
    [_sourceLabel sizeToFit];
    [_topView addSubview:_sourceLabel];
    
    //设置评论数
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _commentLabel.left = _bottomView.left + 10;
    _commentLabel.top += 10;
    NSString *num = [self.weiboLayout.weiboModel.commentsCount stringValue];
    _commentLabel.text = [NSString stringWithFormat:@"评论:%@",num];
    _commentLabel.numberOfLines = 1;
    [_commentLabel sizeToFit];
    [_bottomView addSubview:_commentLabel];
    
    
    [view addSubview:_bottomView];
    [view addSubview:_topView];
    tableView.tableHeaderView = view;
    
}

#pragma mark - tableViewDalegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.commentModel = _commentAry[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [_heightAry[indexPath.row] floatValue];
    return height + 50;
}




@end
