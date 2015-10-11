//
//  NetWorking.h
//  XSWeibo
//
//  Created by mac on 15/9/24.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetWorking : NSObject


+ (AFHTTPRequestOperation *)POSTURLWithParameters:(NSString *)text data:(NSMutableDictionary *)datas completionBlock:(void(^)(id result))compltionBlock errorBlock:(void(^)(NSError *error))errorBlock;


+ (AFHTTPRequestOperation *)GETURLWithURLStr:(NSString *)url Parameters:(NSMutableDictionary *)parameters completionBlock:(void(^)(id result))compltionBlock errorBlock:(void(^)(NSError *error))errorBlock;
@end
