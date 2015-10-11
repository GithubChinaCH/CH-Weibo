//
//  WeiboAnnotationView.h
//  XSWeibo
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView
{
    UILabel *_textLabel;//内容
    UIImageView *_iconView; //头像
}

@end
