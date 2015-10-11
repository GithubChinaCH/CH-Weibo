//
//  WeiboTableView.m
//  XSWeibo
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboTableViewCell.h"
#import "WeiboViewLayoutFrame.h"
#import "UIView+NavigationController.h"
#import "Comment.h"

@implementation WeiboTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
    
}

- (void)initView
{
    self.dataSource = self;
    self.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"WeiboTableViewCell" bundle:nil];
    self.rowHeight = 100;
//    self.backgroundColor = [UIColor orangeColor];
    [self registerNib:nib forCellReuseIdentifier:@"weiboCell"];
}


#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weiboCell" forIndexPath:indexPath];

    WeiboViewLayoutFrame *weiboLayoutFrame = _dataAry[indexPath.row];
    cell.weiboLayoutFrame = weiboLayoutFrame;


    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboViewLayoutFrame *weiboLayoout = _dataAry[indexPath.row];
    return weiboLayoout.frame.size.height + 50;
}


- (CGFloat)contextHeight:(NSIndexPath *)indexPath
{
    WeiboModel *model = _dataAry[indexPath.row];
    NSString *context = model.text;
    CGRect rect = [context boundingRectWithSize:CGSizeMake(kScreenWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]} context:nil];
    CGFloat height = rect.size.height;
    
    if (height < 12) {
        height = height + 20;
    }
    else
    {
        height = height + 80;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出布局对象
    WeiboViewLayoutFrame *layoutWeibo = self.dataAry[indexPath.row];
    Comment *detailVC = [[Comment alloc] init];
    //获得微博model
    detailVC.weiboLayout = layoutWeibo;
    //[detailVC.weiboLayout layoutFrame];
    
    //push页面
    if (self.NavigationController) {
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.NavigationController pushViewController:detailVC animated:YES];
    }
}

@end
