//
//  RightViewController.m
//  XSWeibo
//
//  Created by mac on 15/9/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "UIViewController+MMDrawerController.h"
#import "SendViewController.h"
#import "BaseNavController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "NetWorking.h"
#import "NearbyStoreViewController.h"

@interface RightViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *_manager; //定位管理器
    NearbyStoreViewController *_nearbyStore; //附近商场
}
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self _creatButtton];
}

//newbar_icon_1.png   1-5
//创建按钮
- (void)_creatButtton
{
    for (int index = 0; index < 5; index ++) {
        //创建主题按钮
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(10, 64 + index * (40 + 10), 50, 50)];
        if (index == 0) {
            [button addTarget:self action:@selector(writeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (index == 4) {
            [button addTarget:self action:@selector(locationNowPlace) forControlEvents:UIControlEventTouchUpInside];
        }
        button.backgroundImageName = [NSString stringWithFormat:@"newbar_icon_%i",index + 1];
        
        [self.view addSubview:button];
    }
}

//点击第一个按钮执行事件
- (void)writeButtonAction:(UIButton *)sender
{
    //右边部分缩回
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        //完成后弹出模态视图
        SendViewController *sender = [[SendViewController alloc] init];
        BaseNavController *baseNavi = [[BaseNavController alloc] initWithRootViewController:sender];
        [self presentViewController:baseNavi animated:YES completion:nil];
    }];
}


//点击最后一个按钮执行事件
- (void)locationNowPlace
{
    //进入模态视图
    _nearbyStore = [[NearbyStoreViewController alloc] init];
    BaseNavController *navi = [[BaseNavController alloc] initWithRootViewController:_nearbyStore];
    
    [self presentViewController:navi animated:YES completion:^{
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    }];
    
    if (_manager == nil) {
        //创建位置管理器
        _manager = [[CLLocationManager alloc] init];
        if (kDeviceVersion > 8.0) {
            [_manager requestWhenInUseAuthorization];
        }
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.delegate = self;
    }
    
    [_manager startUpdatingLocation];
}
//地理位置管理代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //停止定位
    [_manager stopUpdatingLocation];
    //创建地址
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSString *latitude = [NSString stringWithFormat:@"%lf",coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%lf",coordinate.longitude];
    
    //设置请求信息
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:latitude forKey:@"lat"];
    [dictionary setObject:longitude forKey:@"long"];
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [dictionary setObject:appdelegate.weib.accessToken forKey:@"access_token"];
    
    [dictionary setObject:@"50" forKey:@"count"];
    //发送请求
    [NetWorking GETURLWithURLStr:nearby_pois Parameters:dictionary completionBlock:^(id result) {
        NSArray *allPlace = result[@"pois"];
        _nearbyStore.datas = allPlace;
        _nearbyStore.loadBlock();
        for (NSDictionary *palce in allPlace) {
            NSLog(@"%@",palce[@"title"]);
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
