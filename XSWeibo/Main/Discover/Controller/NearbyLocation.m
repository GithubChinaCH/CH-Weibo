//
//  NearbyLocation.m
//  XSWeibo
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NearbyLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "NetWorking.h"
#import "WeiboModel.h"
#import "Comment.h"
#import "WeiboViewLayoutFrame.h"

@interface NearbyLocation ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_manager;
    MKMapView *_map;
}

@end

@implementation NearbyLocation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近的微博";
    [self _creatMap];
    [self locationNowPlace];
    //[self _creatAnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//创建标注
- (void)_creatAnnotation
{
    //创建标注对象
    WeiboAnnotation *weiboAnnotation = [[WeiboAnnotation alloc] init];
    //设置标题
    weiboAnnotation.title = @"qqq";
    //设置辅助标题
    weiboAnnotation.subtitle = @"www";
    //设置坐标
    CLLocationCoordinate2D coordinate = {29,119};
    weiboAnnotation.coordinate = coordinate;
    //添加标注
    [_map addAnnotation:weiboAnnotation];
    
}
//返回标柱视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //如果是当前位置则返回nil
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    WeiboAnnotationView *pin = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    if (pin == nil) {
        pin = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
    }
    pin.annotation = annotation;
    
    return pin;
}

//返回标柱视图
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    //如果是当前位置则返回nil
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
//    if (pin == nil) {
//        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
//        //设置颜色
//        pin.pinColor = MKPinAnnotationColorPurple;
//        //设置从天而降效果
//       // pin.animatesDrop = YES;
//        //设置显示标题
//        pin.canShowCallout = YES;
//        //设置辅助视图
//        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    }
//    
//    return nil;
//}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[WeiboAnnotationView class]]) {
        WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
        WeiboAnnotation *annotation = (WeiboAnnotation *)view.annotation;
        layout.weiboModel = annotation.weiboModel;
        Comment *comment = [[Comment alloc] init];
        comment.weiboLayout = layout;
        
        [self.navigationController pushViewController:comment animated:YES];
        
    }
}

- (void)_creatMap
{
    //创建地图
    _map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //设置代理
    _map.delegate = self;
    //显示用户位置
    _map.showsUserLocation = YES;
    //设置地图类型 普通 卫星 混合
    _map.mapType = MKMapTypeHybrid;
    
    //显示用户位置
    //>>1
    //跟踪用户
   // _map.userTrackingMode = MKUserTrackingModeFollow;
    
    [self.view addSubview:_map];
}

//_map代理方法获得位置
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    CLLocation *location = userLocation.location;
//    CLLocationCoordinate2D coordinate = location.coordinate;
//    
//    NSLog(@"%lf %lf",coordinate.longitude,coordinate.latitude);
//}




//使用位置管理器来显示位置
- (void)locationNowPlace
{
    _manager = [[CLLocationManager alloc] init];
    if (kDeviceVersion > 8.0) {
        [_manager requestWhenInUseAuthorization];
    }
    _manager.delegate = self;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    [_manager startUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_manager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    //获取附近微博
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //设置经纬度
    NSString *longitude = [NSString stringWithFormat:@"%lf",coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%lf",coordinate.latitude];
    [parameters setObject:longitude forKey:@"long"];
    [parameters setObject:latitude forKey:@"lat"];
    
    //发送请求
    [NetWorking GETURLWithURLStr:nearby_timeline Parameters:parameters completionBlock:^(id result) {
        //接收附近微博
        NSArray *nearbyWeiboAry = result[@"statuses"];
        NSMutableArray *allWeiboAry = [NSMutableArray array];
        for (NSDictionary *dic in nearbyWeiboAry) {
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.weiboModel = model;
            [allWeiboAry addObject:annotation];
        }
        
        [_map addAnnotations:allWeiboAry];
        
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    //创建MKCoordinateRegion
    /*
     typedef struct {
     CLLocationCoordinate2D center;
     MKCoordinateSpan span;
     } MKCoordinateRegion;
     */
    //设置显示范围 值越小 精度越大 范围越小
    MKCoordinateSpan pan = {.1,.1};
    
    //设置显示区域
    MKCoordinateRegion region = {coordinate,pan};
    [_map setRegion:region];
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
