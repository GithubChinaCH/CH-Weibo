//
//  ThemesViewController.m
//  XSWeibo
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemesViewController.h"
#import "ThemeManager.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@interface ThemesViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSDictionary *_themesDic; // 存储所有主题 和路径
    NSArray *_themesAry;
}

@end

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"主题";
    [self loadData];
    [self _creatView];
}
- (void)loadData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
    _themesDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    _themesAry = [_themesDic allKeys];
}

- (void)_creatView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}


//delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _themesAry.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        ThemeImageView *imageV = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, cell.frame.size.height)];
        imageV.imageViewName = @"channel_sectionbar";
        [cell.contentView addSubview:imageV];
        ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(50, 0, 150, cell.frame.size.height)];
        label.colorName = @"More_Item_Text_color";
        [cell.contentView addSubview:label];
        label.tag = 100;
    }
    ThemeLabel *label = (ThemeLabel*)[cell.contentView viewWithTag:100];
    label.text = _themesAry[indexPath.row];
    
    //cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThemeManager *manager = [ThemeManager shareInstance];
    manager.themeName = _themesAry[indexPath.row];
    
    self.nameB(_themesAry,indexPath.row);
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:manager.themeName forKey:@"themeNames"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}








@end
