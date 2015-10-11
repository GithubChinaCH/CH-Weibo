//
//  WeiboAnnotation.m
//  XSWeibo
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation
- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        //设置标注经纬度
        NSArray *coordinate = weiboModel.geo[@"coordinates"];
        NSString *longitude = coordinate[1];
        NSString *latitude = coordinate[0];
        CLLocationCoordinate2D oneCoordinate = {[latitude floatValue],[longitude floatValue]};

        self.coordinate = oneCoordinate;
    }
}

@end
