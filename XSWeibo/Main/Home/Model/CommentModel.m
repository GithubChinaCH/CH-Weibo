//
//  CommentModel.m
//  XSWeibo
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "CommentModel.h"
#import "RegexKitLite.h"

@implementation CommentModel

- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    if (dataDic[@"user"]) {
        _user = [[UserModel alloc] initWithDataDic:dataDic[@"user"]];
    }
    if (dataDic[@"_reply_comment"]) {
        _reply_comment = [[CommentModel alloc] initWithDataDic:dataDic[@"_reply_comment"]];
    }
    
    //设置表情
    NSString *regex = @"\\[\\w+\\]";
    NSArray *faceAry = [self.text componentsMatchedByRegex:regex];
    //获取表情包pilst文件
    NSString *facePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *allFaceBundleAry = [NSArray arrayWithContentsOfFile:facePath];
    
    //遍历数组修改微博表情内容  [心] －－》<image url = '心.png'>
    for (NSString *faceName in faceAry) {
        //        NSLog(@"%@",faceName);
        NSString *predictStr = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *predict = [NSPredicate predicateWithFormat:predictStr];
        NSArray *items = [allFaceBundleAry filteredArrayUsingPredicate:predict];
        if (items.count > 0) {
            NSDictionary *itemsDic = [items lastObject];
            NSString *imageName = [NSString stringWithFormat:@"<image url = '%@'>",itemsDic[@"png"]];
            self.text = [self.text stringByReplacingOccurrencesOfString:faceName withString:imageName];
        }
    }
    
    
}

@end
