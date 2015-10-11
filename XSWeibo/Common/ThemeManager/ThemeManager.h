//
//  ThemeManager.h
//  XSWeibo
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kThemeDidChangeNotificationName @"kThemeDidChangeNotificationName"

@interface ThemeManager : NSObject

@property (nonatomic, copy) NSString *themeName; //主题名字
@property (nonatomic, strong) NSDictionary *themeConfig; //theme。plist的内容
@property (nonatomic, strong) NSDictionary *allColorDic;

+ (ThemeManager *)shareInstance;//单例方法，获得唯一对象
//获取图片
- (UIImage *)getThemeImage:(NSString *)imageName;
//获取颜色
- (UIColor *)getThemeColor:(NSString *)name;
@end
