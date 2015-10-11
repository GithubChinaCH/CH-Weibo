//
//  MoreViewController.m
//  XSWeibo
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreCellTableViewCell.h"
#import "ThemesViewController.h"
#import "AppDelegate.h"
#import "ThemeImageView.h"
#import "BaseNavController.h"
#import "ThemeButton.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSArray *_nameAry;
    NSArray *_contentAry;
    ThemesViewController *_themeVC;
    
    AppDelegate *_appdelegate;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BaseNavController *navi = (BaseNavController *)self.navigationController;
    navi.titleLabel.text = @"更多";
    
    [self loadData];
    //创建表示图
    [self _creatView];
    
}
- (void)loadData
{
    _appdelegate = [UIApplication sharedApplication].delegate;
    _nameAry = @[@"more_icon_theme",@"more_icon_queue",@"more_icon_feedback"];
    _contentAry = @[@"主题选择",@"账户管理",@"意见反馈"];
}

- (void)_creatView
{
    _themeVC = [[ThemesViewController alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}


#pragma mark - tableViewDelegate
//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//设置单元格数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
    {
        return 1;
    }
}
//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCellTableViewCell *cell = nil;
    NSArray *ary = [[NSBundle mainBundle] loadNibNamed:@"MoreCellTableViewCell" owner:nil options:nil];
    cell = [ary lastObject];
    cell.cellLabel.colorName = @"More_Item_Text_color";
    cell.themeLabel.colorName = @"More_Item_Text_color";
    ThemeImageView *bgImageV = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    bgImageV.imageViewName = @"channel_sectionbar";
    cell.backgroundView = bgImageV;
    
    if (indexPath.section == 2) {
        [cell.cellImageView removeFromSuperview];
        [cell.cellLabel removeFromSuperview];
        [cell.themeLabel removeFromSuperview];
        ThemeLabel *lable = [[ThemeLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, cell.frame.size.height)];
        lable.text = @"退出当前账号";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont boldSystemFontOfSize:20];
        lable.colorName = @"More_Item_Text_color";
//        [button setTitle:@"退出当前账号"forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        //label.backgroundColor = [UIColor orangeColor];

        [cell.contentView addSubview:lable];
        return cell;
    }
    
   // cell.textLabel.text = [NSString stringWithFormat:@"%li %li",indexPath.row,indexPath.section];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.themeLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeNames"];
            _themeVC.nameB = ^(NSArray *ary , NSInteger index)
            {
                cell.themeLabel.text = ary[index];
            };
        }
        else
        {
            cell.themeLabel.text = nil;
        }
        cell.imageName = _nameAry[indexPath.row];
        cell.cellLabel.text = _contentAry[indexPath.row];
    }
    else
    {
        cell.imageName = _nameAry[2];
        cell.cellLabel.text = _contentAry[2];
        cell.themeLabel.text = nil;
    }
    
    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
//    imageV.backgroundColor = [UIColor orangeColor];
//    [cell.contentView addSubview:imageV];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 100, 40)];
//    [cell.contentView addSubview:label];
//    label.text = @"111";
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        _themeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:_themeVC animated:YES];
    }
    if (indexPath.section == 2)
    {
        if (![_appdelegate.weib isLoggedIn]) {
            return;
        }
        [_appdelegate.weib logOut];
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"退出成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }
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
