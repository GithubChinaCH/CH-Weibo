//
//  NetWorking.m
//  XSWeibo
//
//  Created by mac on 15/9/24.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NetWorking.h"
#import "AppDelegate.h"
#import "AppDelegate.h"

@implementation NetWorking

+ (AFHTTPRequestOperation *)POSTURLWithParameters:(NSString *)text data:(NSMutableDictionary *)datas completionBlock:(void(^)(id result))compltionBlock errorBlock:(void(^)(NSError *error))errorBlock
{
    AFHTTPRequestOperation *operation = nil;
    //创建网络管理对象
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    //设置参数
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    //设置文字内容
    [parames setObject:text forKey:@"status"];
    //设置令牌
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [parames setObject:appdelegate.weib.accessToken forKey:@"access_token"];
    
    //不带图片发送微博
    if (datas == nil) {
        NSString *url = [BaseUrl stringByAppendingString:send_update];
        
        
        
        //发送消息
        operation = [maneger POST:url parameters:parames success:^(AFHTTPRequestOperation *operation, id responseObject) {
            compltionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            errorBlock(error);
        }];
        
    }
    else
    {
        //拼接url
        NSString *url = [BaseUrl stringByAppendingString:send_upload];
        //发送请求
        operation = [maneger POST:url parameters:parames constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSArray *allKeys = [datas allKeys];
            for (NSString *key in allKeys) {
                NSData *data = datas[key];
                [formData appendPartWithFileData:data name:key fileName:key mimeType:@"image/jpeg"];
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            compltionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            errorBlock(error);
        }];
        
    }
    
    return operation;
}


//get请求
+ (AFHTTPRequestOperation *)GETURLWithURLStr:(NSString *)url Parameters:(NSMutableDictionary *)parameters completionBlock:(void(^)(id result))compltionBlock errorBlock:(void(^)(NSError *error))errorBlock
{
    NSString *urlStr = [BaseUrl stringByAppendingString:url];
    //创建管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [parameters setObject:appdelegate.weib.accessToken forKey:@"access_token"];
    
    //设置响应格式化符
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    //发送get请求
    AFHTTPRequestOperation *operation = [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        compltionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
    return operation;
}

@end
