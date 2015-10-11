//
//  UIView+NavigationController.m
//  XSWeibo
//
//  Created by mac on 15/9/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "UIView+NavigationController.h"

@implementation UIView (NavigationController)

//返回导航控制器
- (UINavigationController *)NavigationController
{
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)responder;
        }
        else
        {
            responder = responder.nextResponder;
        }
    } while (responder != nil);
    return nil;
}

//返回视图控制器
- (UIViewController *)viewController
{
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UINavigationController *)responder;
        }
        else
        {
            responder = responder.nextResponder;
        }
    } while (responder != nil);
    return nil;
}

@end
