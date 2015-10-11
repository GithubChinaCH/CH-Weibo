//
//  LeftViewController.m
//  XSWeibo
//
//  Created by mac on 15/9/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LeftViewController.h"
#import "ThemeLabel.h"
#import "ThemeManager.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;//表视图
    NSArray *_sectionOneAry;
    NSArray *_sectionTwoAry;
}

@end

@implementation LeftViewController

- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBG) name:kThemeDidChangeNotificationName object:nil];
    
    //读取数据
    [self _loadData];
    //创建表视图
    [self _creatTabelView];
}
//设置背景图片
- (void)changeBG
{
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}


//读取数据
- (void)_loadData
{
    _sectionOneAry = @[@"无",@"偏移",@"偏移&缩放",@"旋转",@"视差"];
    _sectionTwoAry = @[@"大图",@"小图"];
}

//创建表视图
- (void)_creatTabelView
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    [self.view addSubview:_tableView];
}

#pragma mark - tabelViewDelegate

//设置主头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    if (section == 0) {
        label.text = @"界面切换效果";
    }
    else
    {
        label.text = @"图片浏览模式";
    }
    label.font = [UIFont boldSystemFontOfSize:20];
    label.colorName = @"Mask_Title_color";
    label.backgroundColor = [UIColor clearColor];
    return label;
}
//组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//每组单元格数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    else
    {
        return 2;
    }
}
//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:cell.contentView.bounds];
    label.colorName = @"More_Item_Text_color";
    if (indexPath.section == 0) {
        label.text = _sectionOneAry[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        label.text = _sectionTwoAry[indexPath.row];
    }
    [cell.contentView addSubview:label];
//    cell.textLabel.text = [NSString stringWithFormat:@"%li",indexPath.row];
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
